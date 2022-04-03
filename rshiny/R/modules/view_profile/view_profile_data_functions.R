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
                                  want_new_student_role_indicator, past_apply_not_placed, had_onboard_call_with_staff,
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


get_notes <- function(){
  print("VP-F-03: Getting notes on viewed individual")
  
  #Filter to rows associated with volunter id and then show students (using their id)
  if (rv$role == "Volunteer") {
    data <- load_data("notes") %>% filter(id == rv$id) 
  }
  
  #Filter to rows associated with student id and then show volunteers (using their id)
  else {
    data <- load_data("notes") %>% filter(id == rv$id)
  }
  
  return(data)
}



#get_current_semester <- function() {}
#get_previous_semester <- function() {}
#get_all_history <- function() {}



