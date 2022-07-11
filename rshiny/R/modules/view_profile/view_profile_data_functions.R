#-----------------------------
# View Profile Data Functions
#-----------------------------
# Data Functions only used within scope of the viewProfileServer module


get_profile <- function(){
  print("VP-F-01: Getting profile data")
  
  #VOLUNTEERS
  if (rv$role == "Volunteer") {
    data <- load_data(VOL_TUTOR_TABLE) %>% filter(id == rv$id) %>% mutate(across(everything(), ~as.character(.)))
    
    contact <- data %>% select(id, first_name, last_name, email_address, phone_num, city_state_zip)
    dem <- data %>% select(id, gender, native_langs, other_langs, race, ethnicity, age, highest_education,
                           returning_indicator, prior_experience, teach_certs, educ_credentials) %>%
                    pivot_longer(!id, names_to ="field") %>% select(-id) 

    details <- data %>% select(id, previous_role, reserved_student_names, desired_start_date, details_multiple_dates, 
                                  want_additional_student_indicator, 
                                  past_apply_not_placed, had_onboard_call_with_staff,
                                  pref_role_1, tutor_type_pref, pref_tutor_slot, am_time_avail_1, am_time_avail_2, 
                                  am_time_avail_3, am_time_avail_4, pm_time_avail_1, pm_time_avail_2, pm_time_avail_3, 
                                  pm_time_avail_4, wknd_time_avail_1, wknd_time_avail_2, tutor_level_prefs, 
                                  num_new_students, avail_before_date_indicator, other_tutor_sched_info) %>% 
      
                  pivot_longer(!id, names_to ="field") %>% select(-id) 

    dfs <- list(df_contact=contact, df_dem=dem, df_detail=details)
  }
  
  #STUDENTS
  else {
    
    data <- load_data(STUD_FORM_TABLE) %>% filter(id == rv$id) %>% mutate(across(everything(), ~as.character(.))) 
    contact <- data %>% select(id, first_name, last_name, email_address, phone_num, address_1, city_state_zip)
    dem <- data %>% select(id, gender, home_country, native_lang, race, ethnicity, age, highest_education,
                              student_employ_status, student_monthly_income, student_num_dependents,
                              spouse_employ_status, spouse_monthly_income, employ_affected_by_covid) %>% 
                       
                    pivot_longer(!id, names_to ="field") %>% select(-id) 
    
    details <- data %>% select(id, timestamp, class_interest, eng_level, want_same_tutor, tutor_name,
                                  time_avail_1,  time_avail_2,  time_avail_3,  time_avail_4,  time_avail_5,
                                  time_avail_6,  time_avail_7,  time_avail_8,  time_avail_9,  time_avail_10 ) %>%
      
                           pivot_longer(!id, names_to ="field") %>% select(-id) 

    dfs <- list(df_contact=contact, df_dem=dem, df_exp=exp, df_detail=details)
  }
  return (dfs)
}




calculate_matches <- function(stud_df, vol_df) {
  
  # stud_df <- df_stud
  # vol_df <- df_vol
  
  #Pivot volunteer data to match by timeslots
  vol_time_cols <- names(vol_df)[str_detect(names(vol_df), "time_avail")]
  
  long_vol <- vol_df %>% select(id, first_name, last_name, vol_time_cols) %>%
    pivot_longer(., vol_time_cols, names_to = "timeslot", values_to = "time") %>% select(-c(timeslot)) %>%
    rename(vol_id = id)
  
  
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
      rename(student_id = id)
    
    match_time <- left_join(long_stud, long_vol, by=c("time"))
    #------------------------------------------------------------------------
    
    
    #Once we've narrowed down (filtered) possible volunteer matches by time, we look at other factors
    vol_matches <- vol_df %>% filter(first_name %in% match_time$first_name.y & last_name %in% match_time$last_name.y) %>%
      select(c(id, first_name, last_name, email_address, returning_indicator,
               timestamp, native_langs, other_langs, tutor_level_prefs,
               desired_start_date, avail_before_date_indicator, num_slots_needed))
    
    
    stud_matches <- match_time %>% select(student_id, first_name.x, last_name.x, vol_id) %>% distinct()
    
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
                      same_lang_level_4, same_lang_level_5), ~as.numeric(.)))
    
    
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
    vol_matches <- vol_matches %>% mutate(across(c(17:33), ~replace_na(., 0)))
    
    #Get aggregate weight and ranking (allows for ties when two or more volunteers get same score)
    ranked_vol_matches <- vol_matches %>% rowwise() %>% mutate(agg_weight = sum(c_across(17:33))) %>% arrange(desc(agg_weight)) %>%
      ungroup() %>% mutate(ranking = dense_rank(desc(agg_weight)))
    
    
    #Bring in potential volunteer matches via join using volunteer id
    stud_matches <- left_join(stud_matches, ranked_vol_matches, by=c("vol_id" = "id")) %>% arrange(ranking)
    
    
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

run_algorithm_one <- function() {
  print("VP-F-09: Rerunning recommended matches algorithm for specific individual")
  
  #TODO: ensure students who need to be match sorted by students who have made some form
  # of payment /scholarship and have been waiting the longest since the date of that payment
  # (rather than registration date)
  
  #STUDENTS
  #-------------------------
  #Get student info
  df_stud <- load_data("students") %>% filter(id == rv$id)
  
  
  #VOLUNTEERS
  #-------------------------
  #Get all unmatched volunteers
  df_vol <- load_data("vol_tutors") %>% filter(status == 'Unmatched' & 
                                                 num_slots_needed != 0 &
                                                 want_additional_student_indicator == "Yes" &
                                                 tutor_type_pref != "Online Writing Tutor")
  
  #Pivot volunteer data to match by timeslots
  vol_time_cols <- names(df_vol)[str_detect(names(df_vol), "time_avail")]
  
  long_vol <- df_vol %>% select(id, first_name, last_name, vol_time_cols) %>%
    pivot_longer(., vol_time_cols, names_to = "timeslot", values_to = "time") %>% select(-c(timeslot)) %>%
    rename(vol_id = id)
  
  #Get updated recommended matches
  new_matches <- calculate_matches(df_stud, df_vol) %>% mutate(across(everything(), ~as.character(.)))
  
  #Bring in current matches and remove old recs by student id
  df_matches <- load_data('rec_matches') %>% filter(id != rv$id) %>% mutate(across(everything(), ~as.character(.)))
  
  df_updated <- bind_rows(df_matches, new_matches)
  #Replace with new recs
  
  #Save updates
  update_table(DB_PATH, "rec_matches", df_updated, overwrite = TRUE)
}


get_rec_matches <- function() {
  print("VP-F-02: Getting potential matches for the individual")
  
  #Filter to rows associated with volunter id and then show students (using their id)
  if (rv$role == "Volunteer") {
    data <- load_data("rec_matches") %>% filter(vol_id == rv$id) %>% rename(id = student_id) #%>% select(id, st)
  }
  
  #Filter to rows associated with student id and then show volunteers (using their id)
  else {
    data <- load_data("rec_matches") %>% filter(student_id == rv$id) %>% rename(id = vol_id)
  }
  
  return(data)
}


get_indiv_notes <- function(){
  print("VP-F-03: Getting notes on viewed individual")
  
  #Filter to rows associated with volunter id and then show students (using their id)
  if (rv$role == "Volunteer") {
    data <- load_data("indiv_notes") %>% filter(id == rv$id) 
  }
  
  #Filter to rows associated with student id and then show volunteers (using their id)
  else {
    data <- load_data("indiv_notes") %>% filter(id == rv$id)
  }
  
  return(data)
}

# get_match_notes <- function(){
#   print("VP-F-03: Getting notes on match")
#   
#   #Filter to rows associated with volunter id and then show students (using their id)
#   data <- load_data("match_notes") %>% filter(match_id == rv$id)
#   
#   return(data)
# }


#get_current_semester <- function() {}
#get_previous_semester <- function() {}
#get_all_history <- function() {}


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



