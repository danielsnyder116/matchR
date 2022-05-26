#---------------------
#   CORE FUNCTIONS
#---------------------


load_data <- function(table_name) {
  
  print(glue("CF-01:Loading table **{table_name}**"))
  
  #Establish connection to DB
  conn <- dbConnect(SQLite(), DB_PATH)
  dbListTables(conn)
  data <- dbGetQuery(conn, glue('SELECT * FROM {table_name}'))
  dbDisconnect(conn)
  
  return(data)
}





#Need to get rvs from tab to then set as current rv when viewing a tab
#TODO
# get_reactive_values <- function() {
#   
# }

update_reactive_values <- function(df_value, row_value){
  
  #Set reactive values 
  rv$id <<- df_value$id[row_value]
  rv$name <<- paste(df_value$first_name[row_value], df_value$last_name[row_value])
  rv$role <<- df_value$role[row_value]
  rv$status<<- df_value$status[row_value]
  
  print(glue("Updated reactive values - current indiv:  {rv$id} {rv$name} {rv$role}"))
  
}






make_profile_tab_info <- function(id_input, name_input, role_input) {
 print("Formatting individual details to display in tab")
  
  #id_input, status_input 
  #"ID: ", id_input, "<br>", 
  #"Status: ", status_input, "<br>"
  
  #TODO: Convert to unit test
  #For testing
  # name_input <- "Danny Snyder"
  # role_input <- "Volunteer"

  tab_info <-  div(HTML(paste0("<b>ID:</b> ", id_input, "<br>",
                               "<b>Name:</b> ", name_input, "<br>",
                               "<b>Role:</b> ", role_input, "<br>")), style ='font-size: 11px;')
  
  return (tab_info)

}



#FUNCTIONS FROM VIEW PROFILE MODULE
#TODO Have one location for functions and distribute to where needed
#(store in core functions and pass into viewProfileServer ?)
#---------------------------------------------------------------



set_match_id <- function(){
  
  #Get all current match ids
  current_max_id <- load_data(MATCH_TABLE) %>% mutate(match_id = as.integer(match_id)) %>% pull(match_id) %>% max()
  
  #For first match when no ids are created
  if (current_max_id == -Inf) {
    match_id <- "0001"
  }
  
  else {
    match_id <- str_pad(as.character(current_max_id + 1), 4, side="left", pad = "0")
  }
  
  return(match_id)
}


calculate_matches <- function(stud_df, vol_df) {
  # stud_df <- df_stud
  # vol_df <- df_vol
  
  #Pivot volunteer data to match by timeslots
  vol_time_cols <- names(vol_df)[str_detect(names(vol_df), "time_avail")]
  
  long_vol <- vol_df %>% select(id, first_name, last_name, vol_time_cols) %>%
    pivot_longer(., vol_time_cols, names_to = "timeslot", values_to = "time") %>% select(-c(timeslot)) %>%
    rename(vol_id = id) %>% lazy_dt()
  
  
  for (i in 1:nrow(stud_df)) {
    # i <- 1
    
    #Get one student row and drop na cols
    student <- stud_df %>% slice(i) %>% select(where(~!is.na(.)))
    
    #print(glue("{i}: {student$first_name} {student$last_name}"))
    
    
    #----------------
    #   TIME SLOT
    #----------------
    
    #Get student availability
    stud_time_cols <- student %>% select(starts_with("time_avail")) %>% names()
    
    long_stud <- student %>% select(id, first_name, last_name, stud_time_cols) %>%
                             pivot_longer(., stud_time_cols, names_to = "timeslot", values_to = "time") %>%
                             rename(student_id = id) %>% lazy_dt()
    
    match_time <- left_join(long_stud, long_vol, by=c("time"))
    #------------------------------------------------------------------------
    
    
    #Once we've narrowed down (filtered) possible volunteer matches by time, we look at other factors
    vol_matches <- lazy_dt(vol_df) %>% filter(first_name %in% match_time$first_name.y & last_name %in% match_time$last_name.y) %>%
                              select(c(id, first_name, last_name, email_address, returning_indicator,
                                       timestamp, native_langs, other_langs, tutor_level_prefs,
                                       desired_start_date, avail_before_date_indicator, num_slots_needed))
                            
    
    stud_matches <- match_time %>% select(student_id, first_name.x, last_name.x, vol_id) %>% distinct() %>% as_tibble()
    
    #-----------------
    #NUMBER OF
    #SHARED TIMESLOTS
    #-----------------
    #We bring in the number of matched timeslots as a factor in match process
    num_matched_slots_col <- match_time %>% group_by(vol_id, first_name.y, last_name.y) %>%
      summarize(num_matched_slots = n())
    
    vol_matches <- left_join(vol_matches, num_matched_slots_col, by=c("id" = "vol_id",
                                                                      "first_name" = "first_name.y",
                                                                      "last_name" = "last_name.y"))
    
    #-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
    #Create weight columns for each relative factor
    #-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
    
    #-----------------
    #FOREIGN LANGUAGE
    #-----------------
    #TODO: Clean up native language listings - need to be in English - will ensure we can do dynamic language searching
    native_lang <- student %>% pull(native_lang)
    #native_lang <- "French"
    
    #Making volunteer entries more consistent to ensure proper parsing and weighting
    #One can pipe/chain multiple str_replace_all together woo
    #Can't handle case of putting level first and then language, oh well
    vol_matches <- vol_matches %>% mutate(other_langs = str_replace_all(other_langs, " +- +", "-") %>%
                                            str_replace_all("[[,;]] [[Aa]]dv", "-Adv") %>%
                                            str_replace_all("[[,;]] [[Bb]]eg", "-Beg") %>%
                                            str_replace_all("[[,;]] [[Ii]]nt", "-Int") %>%
                                            str_replace_all("[[^^]][[Aa]]dvanced \\b", ", Advanced-") %>%
                                            str_replace_all("[[^^]][[Bb]]eginner \\b", ", Beginner-") %>%
                                            str_replace_all("[[^^]][[Ii]]ntermediate \\b", ", Intermediate-") ) %>%
      
      as_tibble() %>% #converting back to tibble as no dtplyr method for separate
      
      
      #Separate multiple langauges within other_langs col to ensure proper parsing - keep col as reference
      separate(other_langs, into = c(paste0("other_lang_", 1:5)), sep=", +\\b|; +|\\. +| and +", remove = FALSE) 
    
    
    #Start all at 1 for native/advanced speaker and subtract
    vol_matches <- vol_matches %>% mutate(same_native_lang = if_else(str_detect(native_langs, native_lang), 1, 0))
    
    
    #Going through to subract depending on level - end totals should be:#1 - native/advanced speaker; .75 - intermediate; .5 - beginner; 0 - none
    #---------------------------------------------
    #FIRST FOREIGN LANGUAGE SPOKEN
    vol_matches <- vol_matches %>% mutate(same_lang_1 = if_else(str_detect(other_lang_1, native_lang), 1, 0),
                                          same_lang_level_1 = case_when(str_detect(other_lang_1, native_lang) & str_detect(other_lang_1, regex("Beginner|Beg|A1|A2|Minimal|Min|Some|Little", ignore_case = TRUE )) ~ "-.5",
                                                                        str_detect(other_lang_1, native_lang) & str_detect(other_lang_1, regex("Intermediate|Int|B1|B2", ignore_case = TRUE)) ~ "-.25",
                                                                        str_detect(other_lang_1, native_lang) & str_detect(other_lang_1, regex("Advanced|Adv|Fluent|C1|C2", ignore_case = TRUE)) ~ "0",
                                                                        TRUE ~ NA_character_)) %>%
      
      #SECOND FOREIGN LANGUAGE SPOKEN
      mutate(same_lang_2 = if_else(str_detect(other_lang_2, native_lang), 1, 0),
             same_lang_level_2 = case_when(str_detect(other_lang_2, native_lang) & str_detect(other_lang_2, regex("Beginner|Beg|A1|A2|Minimal|Min|Some|Little", ignore_case = TRUE )) ~ "-.5",
                                           str_detect(other_lang_2, native_lang) & str_detect(other_lang_2, regex("Intermediate|Int|B1|B2", ignore_case = TRUE)) ~ "-.25",
                                           str_detect(other_lang_2, native_lang) & str_detect(other_lang_2, regex("Advanced|Adv|C1|C2", ignore_case = TRUE)) ~ "0",
                                           TRUE ~ NA_character_)) %>%
      
      #THIRD FOREIGN LANGUAGE SPOKEN
      mutate(same_lang_3 = if_else(str_detect(other_lang_3, native_lang), 1, 0),
             same_lang_level_3 = case_when(str_detect(other_lang_3, native_lang) & str_detect(other_lang_3, regex("Beginner|Beg|A1|A2|Minimal|Min|Some|Little", ignore_case = TRUE )) ~ "-.5",
                                           str_detect(other_lang_3, native_lang) & str_detect(other_lang_3, regex("Intermediate|Int|B1|B2", ignore_case = TRUE)) ~ "-.25",
                                           str_detect(other_lang_3, native_lang) & str_detect(other_lang_3, regex("Advanced|Adv|C1|C2", ignore_case = TRUE)) ~ "0",
                                           TRUE ~ NA_character_)) %>%
      
      #FOURTH FOREIGN LANGUAGE SPOKEN
      mutate(same_lang_4 = if_else(str_detect(other_lang_4, native_lang), 1, 0),
             same_lang_level_4 = case_when(str_detect(other_lang_4, native_lang) & str_detect(other_lang_4, regex("Beginner|Beg|A1|A2|Minimal|Min|Some|Little", ignore_case = TRUE )) ~ "-.5",
                                           str_detect(other_lang_4, native_lang) & str_detect(other_lang_4, regex("Intermediate|Int|B1|B2", ignore_case = TRUE)) ~ "-.25",
                                           str_detect(other_lang_4, native_lang) & str_detect(other_lang_4, regex("Advanced|Adv|C1|C2", ignore_case = TRUE)) ~ "0",
                                           TRUE ~ NA_character_)) %>%
      
      #FIFTH FOREIGN LANGUAGE SPOKEN
      mutate(same_lang_5 = if_else(str_detect(other_lang_5, native_lang), 1, 0),
             same_lang_level_5 = case_when(str_detect(other_lang_5, native_lang) & str_detect(other_lang_5, regex("Beginner|Beg|A1|A2|Minimal|Min|Some|Little", ignore_case = TRUE )) ~ "-.5",
                                           str_detect(other_lang_5, native_lang) & str_detect(other_lang_5, regex("Intermediate|Int|B1|B2", ignore_case = TRUE)) ~ "-.25",
                                           str_detect(other_lang_5, native_lang) & str_detect(other_lang_5, regex("Advanced|Adv|C1|C2", ignore_case = TRUE)) ~ "0",
                                           TRUE ~ NA_character_)) %>%
      
      #Ensuring all values are numeric type
      mutate(across(c(same_lang_level_1, same_lang_level_2, same_lang_level_3,
                      same_lang_level_4, same_lang_level_5), ~as.numeric(.))) %>% lazy_dt()
    
    
    #-----------------
    #LEVEL PREFERENCE
    #-----------------
    stud_level <- student %>% pull(eng_level)
    
    #Volunteer has very specific preference (only one level)
    vol_matches <- vol_matches %>% mutate(same_eng_level_pref = case_when(str_detect(tutor_level_prefs, regex(as.character(glue("^{stud_level}$")), ignore_case = TRUE)) ~ 2,
                                                                          str_detect(tutor_level_prefs, regex(as.character(glue("{stud_level}|No Preference")), ignore_case = TRUE)) ~ 1,
                                                                          TRUE ~ 0))
    
    #-----------------
    # VOLUNTEER WAIT TIME
    # SINCE REGISTERED
    #-----------------
    
    #Ensure timestamp is datetime
    vol_matches <- vol_matches %>% mutate(timestamp = as_datetime(timestamp),
                                          vol_wait_time = as.numeric(round((now() - timestamp) / 100, 2))
    )
    
    #-----------------
    # AVAILABILITY / START DATE
    #-----------------
    
    #The sooner they are available, the more they are prioritized (higher weight value)
    # The earlier, the higher the number will be, the later, the lower the number will be (sooner = better, later = worse)
    vol_matches <- vol_matches %>% mutate(desired_start_date = as_date(mdy(desired_start_date)),
                                          vol_start_date_avail = as.numeric(round((today() - desired_start_date) / 100, 2))) 
    
    #-----------------
    # NUMBER OF TUTEES VOLUNTEER
    # ALREADY HAS
    #-----------------
    #The fewer they have, the more of a priority they are to match
    # vol_matches <- vol_matches %>% mutate(vol_num_tutees_avail = case_when(num_slots_needed == 2 ~ 2,
    #                                                                        num_slots_needed == 1 ~ 1,
    #                                                                        num_slots_needed == 0 ~ 0))
    
    #-----------------
    # NEW VS RETURNING
    #-----------------
    
    #Newer volunteers are prioritized (positive 1)
    vol_matches <- vol_matches %>% mutate(vol_new = case_when(str_detect(returning_indicator, "No") ~ 1, TRUE ~ 0))
    
    
    #TODO: On hold - need to add practicum question to volunteer form!
    #------------
    # UNIVERSITY STUDENTS
    # COMPLETING TESOL PRACTICUM (especially American University Students)
    #------------
    #vol_matches <- vol_matches %>% mutate(grad_student_need_hours = )
    
    
    #OPTIONAL FACTOR
    #-----------------
    # SIMILAR AGE
    #-----------------
    #vol_matches <- vol_matches %>% mutate(same_gender = if_else(vol_gender == student_gender, 1,0))
    
    #----------------------------------------------------------------------------------------------------
    
    #ADD UP WEIGHTS
    
    #Fill in NAs with zero
    vol_matches <- vol_matches %>% mutate(across(c(17:33), ~replace_na(., 0))) %>% as_tibble() #back to tibble from dt
    
    #Get aggregate weight and ranking (allows for ties when two or more volunteers get same score)
    ranked_vol_matches <- vol_matches %>% rowwise() %>% mutate(agg_weight = sum(c_across(17:33))) %>% arrange(desc(agg_weight)) %>%
      ungroup() %>% mutate(ranking = dense_rank(desc(agg_weight)))
    
    
    #Bring in potential volunteer matches via join using volunteer id
    stud_matches <- left_join(stud_matches, ranked_vol_matches, by=c("vol_id" = "id")) %>% 
                          arrange(ranking) %>% as_tibble()
    
    
    #Concatenate/bind all matches together
    if (i == 1) {
      df_all <- stud_matches
    }
    
    else {
      df_all <- bind_rows(df_all, stud_matches)
    }
  } #for loop
  
  return(df_all)
}


run_algorithm_all <- function(){
  print("VP-F-07: Rerunning recommended matches algorithm with updated data for all of matchR")
  
  #TODO: ensure students who need to be match sorted by students who have made some form
  # of payment /scholarship and have been waiting the longest since the date of that payment
  # (rather than registration date)
  
  #STUDENTS
  #-------------------------
  #Get all unmatched students and separate out rematches
  df_stud <- load_data("students") %>% filter(status == 'Unmatched' & 
                                                num_slots_needed != 0 &
                                                want_same_tutor == "Needs New Tutor")
  
  #VOLUNTEERS
  #-------------------------
  #Get all unmatched volunteers
  df_vol <- load_data("vol_tutors") %>% filter(status == 'Unmatched' & 
                                                 num_slots_needed != 0 &
                                                 want_additional_student_indicator == "Yes" &
                                                 tutor_type_pref != "Online Writing Tutor") 
 
  
  
  
  #Call the match algorithm function
  df_matches <- calculate_matches(df_stud, df_vol)
  
  #Update entire table
  update_table(DB_PATH, "rec_matches", df_matches, overwrite = TRUE)
  
}


# get_rv_from_profile_tab <- function(tab_input) {
#   print("Extracting individual from tab html")
#   
#   #Set reactive values 
#   rv_input$id <<-
#   rv_input$name <<- 
#   rv_input$role <<- 
#   rv_input$status <<- 
#   
#   print(glue("Updated reactive values - current indiv: {rv$name} {rv$role}"))
#   
# }