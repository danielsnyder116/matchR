# #-----------------------
# #   MATCHING PROCESS
# #-----------------------
# 
# library(dplyr)
# library(stringr)
# library(tibble)
# library(lubridate)
# library(tidyr)
# 
# #We'll want this to be triggered to rerun every time new data is added
# # so more than likely an eventReactive()
# # reactive({ db_data()$STUD_FORM %>% filter(status == 'Unmatched')
# 
# #STUDENTS
# #-------------------------
# #Get all unmatched students
# df_stud <- load_data("students") %>% filter(status == 'Unmatched')
# 
# #Separate out the rematches
# df_stud_rematch <- df_stud %>% filter(want_same_tutor != "Needs New Tutor")
# df_stud <- df_stud %>% filter(want_same_tutor == "Needs New Tutor")
# 
# #TODO: ensure students who need to be match sorted by students who have made some form
# # of payment /scholarship and have been waiting the longest since the date of that payment 
# # (rather than registration date)
# 
# 
# 
# 
# #VOLUNTEERS
# #-------------------------
# #Get all unmatched volunteers
# df_vol <- load_data("vol_tutors") %>% filter(status == 'Unmatched')
# 
# #Separate out the rematches
# #TODO: Check on new studen indicator - currently couldn't find any 'No's
# #which might indicate something unclear in the choice logic
# df_vol_rematch <- df_vol %>% filter(want_new_student_role_indicator != "Yes")
# df_vol <- df_vol %>% filter(want_new_student_role_indicator == "Yes")
# 
# #Filter out writing volunteers
# df_vol_writing <- df_vol %>% filter(tutor_type_pref == "Online Writing Tutor")
# df_vol <- df_vol %>% filter(tutor_type_pref != "Online Writing Tutor")
# 
# 
# #Pivot volunteer data to match by timeslots
# vol_time_cols <- names(df_vol)[str_detect(names(df_vol), "time_avail")]
# 
# long_vol <- df_vol %>% select(id, first_name, last_name, vol_time_cols) %>% 
#                 pivot_longer(., vol_time_cols, names_to = "timeslot", values_to = "time") %>% select(-c(timeslot)) %>%
#                 rename(vol_id = id)
# 
# 
# calculate_matches <- function(stud_df, vol_df) {
#   
#   for (i in 1:nrow(stud_df)) {
#     #i <- 1
# 
#     #Get one student row and drop na cols
#     student <- stud_df %>% slice(i) %>% select(where(~!is.na(.)))
#     
#     #print(glue("{i}: {student$first_name} {student$last_name}"))
#     
#     
#     #----------------
#     #   TIME SLOT
#     #----------------
#     
#     #Get student availability
#     stud_time_cols <- student %>% select(starts_with("time_avail")) %>% names()
#     
#     long_stud <- student %>% select(id, first_name, last_name, stud_time_cols) %>% 
#       pivot_longer(., stud_time_cols, names_to = "timeslot", values_to = "time") %>%
#       rename(student_id = id)
#     
#     match_time <- left_join(long_stud, long_vol, by=c("time"))
#     #------------------------------------------------------------------------
#     
#     
#     #Once we've narrowed down (filtered) possible volunteer matches by time, we look at other factors
#     vol_matches <- vol_df %>% filter(first_name %in% match_time$first_name.y & last_name %in% match_time$last_name.y) %>%
#       select(c(id, first_name, last_name, email_address, 
#                timestamp, native_langs, other_langs, tutor_level_prefs,
#                desired_start_date, avail_before_date_indicator, num_tutees))
#     
#     
#     stud_matches <- match_time %>% select(student_id, first_name.x, last_name.x, vol_id) %>% distinct()
#     
#     #-----------------
#     #NUMBER OF 
#     #SHARED TIMESLOTS
#     #-----------------
#     #We bring in the number of matched timeslots as a factor in match process
#     num_matched_slots_col <- match_time %>% group_by(vol_id, first_name.y, last_name.y) %>% 
#       summarize(num_matched_slots = n())
#     
#     vol_matches <- left_join(vol_matches, num_matched_slots_col, by=c("id" = "vol_id", 
#                                                                       "first_name" = "first_name.y",
#                                                                       "last_name" = "last_name.y"))
#     
#     
#     #-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
#     #Create weight columns for each relative factor
#     #-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
#     
#     
#     
#     #-----------------
#     #FOREIGN LANGUAGE
#     #-----------------
#     #TODO: Clean up native language listings - need to be in English - will ensure we can do dynamic language searching
#     native_lang <- student %>% pull(native_lang)
#     #native_lang <- "French"
#     
#     #Making volunteer entries more consistent to ensure proper parsing and weighting
#     #One can pipe/chain multiple str_replace_all together woo
#     #Can't handle case of putting level first and then language, oh well
#     vol_matches <- vol_matches %>% mutate(other_langs = str_replace_all(other_langs, " +- +", "-") %>% 
#                                             str_replace_all("[[,;]] [[Aa]]dv", "-Adv") %>% 
#                                             str_replace_all("[[,;]] [[Bb]]eg", "-Beg") %>%
#                                             str_replace_all("[[,;]] [[Ii]]nt", "-Int") %>%
#                                             str_replace_all("[[^^]][[Aa]]dvanced \\b", ", Advanced-") %>% 
#                                             str_replace_all("[[^^]][[Bb]]eginner \\b", ", Beginner-") %>%
#                                             str_replace_all("[[^^]][[Ii]]ntermediate \\b", ", Intermediate-") ) %>%
#       
#       
#       #Separate multiple langauges within other_langs col to ensure proper parsing - keep col as reference
#       separate(other_langs, into = c(paste0("other_lang_", 1:5)), sep=", +\\b|; +|\\. +| and +", remove = FALSE) 
#     
#     
#     #Start all at 1 for native/advanced speaker and subtract
#     vol_matches <- vol_matches %>% mutate(same_native_lang = if_else(str_detect(native_langs, native_lang), 1, 0))
#     
#     
#     #Going through to subract depending on level - end totals should be:#1 - native/advanced speaker; .75 - intermediate; .5 - beginner; 0 - none
#     #---------------------------------------------
#     #FIRST FOREIGN LANGUAGE SPOKEN
#     vol_matches <- vol_matches %>% mutate(same_lang_1 = if_else(str_detect(other_lang_1, native_lang), 1, 0),
#                                           same_lang_level_1 = case_when(str_detect(other_lang_1, native_lang) & str_detect(other_lang_1, regex("Beginner|Beg|A1|A2|Minimal|Min|Some|Little", ignore_case = TRUE )) ~ "-.5",
#                                                                         str_detect(other_lang_1, native_lang) & str_detect(other_lang_1, regex("Intermediate|Int|B1|B2", ignore_case = TRUE)) ~ "-.25",
#                                                                         str_detect(other_lang_1, native_lang) & str_detect(other_lang_1, regex("Advanced|Adv|Fluent|C1|C2", ignore_case = TRUE)) ~ "0",
#                                                                         TRUE ~ NA_character_)) %>%
#       
#       #SECOND FOREIGN LANGUAGE SPOKEN
#       mutate(same_lang_2 = if_else(str_detect(other_lang_2, native_lang), 1, 0),
#              same_lang_level_2 = case_when(str_detect(other_lang_2, native_lang) & str_detect(other_lang_2, regex("Beginner|Beg|A1|A2|Minimal|Min|Some|Little", ignore_case = TRUE )) ~ "-.5",
#                                            str_detect(other_lang_2, native_lang) & str_detect(other_lang_2, regex("Intermediate|Int|B1|B2", ignore_case = TRUE)) ~ "-.25",
#                                            str_detect(other_lang_2, native_lang) & str_detect(other_lang_2, regex("Advanced|Adv|C1|C2", ignore_case = TRUE)) ~ "0",
#                                            TRUE ~ NA_character_)) %>% 
#       
#       #THIRD FOREIGN LANGUAGE SPOKEN
#       mutate(same_lang_3 = if_else(str_detect(other_lang_3, native_lang), 1, 0),
#              same_lang_level_3 = case_when(str_detect(other_lang_3, native_lang) & str_detect(other_lang_3, regex("Beginner|Beg|A1|A2|Minimal|Min|Some|Little", ignore_case = TRUE )) ~ "-.5",
#                                            str_detect(other_lang_3, native_lang) & str_detect(other_lang_3, regex("Intermediate|Int|B1|B2", ignore_case = TRUE)) ~ "-.25",
#                                            str_detect(other_lang_3, native_lang) & str_detect(other_lang_3, regex("Advanced|Adv|C1|C2", ignore_case = TRUE)) ~ "0",
#                                            TRUE ~ NA_character_)) %>% 
#       
#       #FOURTH FOREIGN LANGUAGE SPOKEN
#       mutate(same_lang_4 = if_else(str_detect(other_lang_4, native_lang), 1, 0),
#              same_lang_level_4 = case_when(str_detect(other_lang_4, native_lang) & str_detect(other_lang_4, regex("Beginner|Beg|A1|A2|Minimal|Min|Some|Little", ignore_case = TRUE )) ~ "-.5",
#                                            str_detect(other_lang_4, native_lang) & str_detect(other_lang_4, regex("Intermediate|Int|B1|B2", ignore_case = TRUE)) ~ "-.25",
#                                            str_detect(other_lang_4, native_lang) & str_detect(other_lang_4, regex("Advanced|Adv|C1|C2", ignore_case = TRUE)) ~ "0",
#                                            TRUE ~ NA_character_)) %>% 
#       
#       #FIFTH FOREIGN LANGUAGE SPOKEN
#       mutate(same_lang_5 = if_else(str_detect(other_lang_5, native_lang), 1, 0),
#              same_lang_level_5 = case_when(str_detect(other_lang_5, native_lang) & str_detect(other_lang_5, regex("Beginner|Beg|A1|A2|Minimal|Min|Some|Little", ignore_case = TRUE )) ~ "-.5",
#                                            str_detect(other_lang_5, native_lang) & str_detect(other_lang_5, regex("Intermediate|Int|B1|B2", ignore_case = TRUE)) ~ "-.25",
#                                            str_detect(other_lang_5, native_lang) & str_detect(other_lang_5, regex("Advanced|Adv|C1|C2", ignore_case = TRUE)) ~ "0",
#                                            TRUE ~ NA_character_)) %>% 
#       
#       #Ensuring all values are numeric type
#       mutate(across(c(same_lang_level_1, same_lang_level_2, same_lang_level_3,
#                       same_lang_level_4, same_lang_level_5), ~as.numeric(.)))
#     
#     
#     #-----------------
#     #LEVEL PREFERENCE
#     #-----------------
#     stud_level <- student %>% pull(eng_level)
#     
#     #Volunteer has very specific preference (only one level)
#     vol_matches <- vol_matches %>% mutate(same_eng_level_pref = case_when(str_detect(tutor_level_prefs, regex(as.character(glue("^{stud_level}$")), ignore_case = TRUE)) ~ 2,
#                                                                           str_detect(tutor_level_prefs, regex(as.character(glue("{stud_level}|No Preference")), ignore_case = TRUE)) ~ 1,
#                                                                           TRUE ~ 0))
#     
#     
#     #-----------------
#     # VOLUNTEER WAIT TIME
#     # SINCE REGISTERED
#     #-----------------
#     
#     #Ensure timestamp is datetime
#     vol_matches <- vol_matches %>% mutate(timestamp = as_datetime(timestamp), 
#                                           vol_wait_time = as.numeric(round((now() - timestamp) / 100, 2))
#     )
#     
#     
#     #-----------------
#     # AVAILABILITY / START DATE
#     #-----------------                                                                 
#     
#     #The sooner they are available, the more they are prioritized (higher weight value)
#     # The earlier, the higher the number will be, the later, the lower the number will be (sooner = better, later = worse)
#     vol_matches <- vol_matches %>% mutate(desired_start_date = as_date(mdy(desired_start_date)),
#                                           vol_start_date_avail = as.numeric(round((today() - desired_start_date) / 100, 2)))
#     
#     #-----------------
#     # NUMBER OF TUTEES VOLUNTEER 
#     # ALREADY HAS
#     #-----------------     
#     
#     #The fewer they have, the more of a priority they are to match
#     vol_matches <- vol_matches %>% mutate(vol_num_tutees_avail = case_when(num_tutees == 0 ~ 2,
#                                                                            num_tutees == 1 ~ 1,
#                                                                            num_tutees == 2 ~ 0))
#     
#     #TODO: On hold - need to add practicum question to volunteer form!
#     #------------
#     # UNIVERSITY STUDENTS
#     # COMPLETING TESOL PRACTICUM (especially American University Students)
#     #------------
#     #vol_matches <- vol_matches %>% mutate(grad_student_need_hours = )
#     
#     
#     #OPTIONAL FACTOR
#     #-----------------
#     # SIMILAR AGE 
#     #-----------------     
#     #vol_matches <- vol_matches %>% mutate(same_gender = if_else(vol_gender == student_gender, 1,0))
#     
#     #----------------------------------------------------------------------------------------------------
#     
#     #ADD UP WEIGHTS
#     
#     #Fill in NAs with zero
#     vol_matches <- vol_matches %>% mutate(across(c(17:32), ~replace_na(., 0)))
#     
#     #Get aggregate weight and ranking (allows for ties when two or more volunteers get same score)
#     ranked_vol_matches <- vol_matches %>% rowwise() %>% mutate(agg_weight = sum(c_across(17:32))) %>% arrange(desc(agg_weight)) %>%
#       ungroup() %>% mutate(ranking = dense_rank(desc(agg_weight)))
#     
#     
#     #Bring in potential volunteer matches via join using volunteer id
#     stud_matches <- left_join(stud_matches, ranked_vol_matches, by=c("vol_id" = "id")) %>% arrange(ranking)
#     
#     
#     #Concatenate/bind all matches together
#     if (i == 1) {
#       
#       df_all <- stud_matches
#     }
#     
#     else {
#       
#       df_all <- bind_rows(df_all, stud_matches)
#       
#     }
#   } #for loop
#   
#   return(df_all)
# }
# 
# 
# 
# df_matches <- calculate_matches(df_stud, df_vol)
# 
# 
# 
# # source("/Users/Daniel/Desktop/WEC/Shiny/matchr/db/db_functions.R")
# # 
# # DB_PATH <- glue("/Users/Daniel/Desktop/WEC/Shiny/database/active/matchr.db")
# # DB_NAME <- strsplit(DB_PATH, split = "active/")[[1]][2]
# # 
# # conn <- dbConnect(SQLite(), DB_PATH)
# # 
# # update_table(DB_PATH, "rec_matches", df_matches, overwrite = TRUE)
# # 
# # 
# # 
# # #Verify
# # dbListTables(conn)
# 
# #Disconnect from DB to avoid errors
# dbDisconnect(conn)
# 
# 
# 
# 
# #First, we want to find volunteers available the same time as students
# #But that's just the beginning
# 
# #We want to consider these other factors:
# 
# # - 
# # 
# #   
# # Student
# # - Has paid
# # - 
# # 
# # Volunteer
# # - How many open 'student slots' left (Up to 3 students)
# # - Preferred timeslot
# # - 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
