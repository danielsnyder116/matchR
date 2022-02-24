#-----------------------
#   MATCHING PROCESS
#-----------------------

#We'll want this to be triggered to rerun every time new data is added
# so more than likely an eventReactive()
# reactive({ db_data()$STUD_FORM %>% filter(status == 'Unmatched')

#STUDENTS
#-------------------------
#Get all unmatched students
df_stud <- load_data("students") %>% filter(status == 'Unmatched')

#Separate out the rematches
df_stud_rematch <- df_stud %>% filter(want_same_tutor != "Needs New Tutor")
df_stud <- df_stud %>% filter(want_same_tutor == "Needs New Tutor")


#VOLUNTEERS
#-------------------------
#Get all unmatched volunteers
df_vol <- load_data("vol_tutors") %>% filter(status == 'Unmatched')

#Separate out the rematches
#TODO: Check on new studen indicator - currently couldn't find any 'No's
#which might indicate something unclear in the choice logic
df_vol_rematch <- df_vol %>% filter(want_new_student_role_indicator != "Yes")
df_vol <- df_vol %>% filter(want_new_student_role_indicator == "Yes")

#Filter out writing volunteers
df_vol_writing <- df_vol %>% filter(tutor_type_pref == "Online Writing Tutor")
df_vol <- df_vol %>% filter(tutor_type_pref != "Online Writing Tutor")


#Pivot volunteer data to match by timeslots
vol_time_cols <- names(df_vol)[str_detect(names(df_vol), "time_avail")]

long_vol <- df_vol %>% select(first_name, last_name, vol_time_cols) %>% 
                pivot_longer(., vol_time_cols, names_to = "timeslot", values_to = "time") %>% select(-c(timeslot))


#For each student


#So we want each factor 

for (i in 1:nrow(df_stud)) {
  
  i <- 1
  
  #Get one student row and drop na cols
  student <- df_stud %>% slice(i) %>% select(where(~!is.na(.)))

  
  
  #----------------
  #   TIME SLOT
  #----------------
  
  
  #Get student availability
  stud_time_cols <- student %>% select(starts_with("time_avail")) %>% names()

  long_stud <- student %>% select(first_name, last_name, stud_time_cols) %>% 
                  pivot_longer(., stud_time_cols, names_to = "timeslot", values_to = "time")
  
  match_time <- left_join(long_stud, long_vol, by=c("time"))
  
  
 
  
  #------------------------------------------------------------------------
  

  #Once we've narrowed down possible volunteer matches by time, we look at other factors
  match_vol <- df_vol %>% filter(first_name %in% match_time$first_name.y & last_name %in% match_time$last_name.y)
  
  
  #Create weight columns for each relative factor
  
  #FOREIGN LANGUAGE
  #TODO: Clean up native language listings - need to be in English
  native_lang <- student %>% pull(native_lang)
  
  #Add weights 1 - native/advanced speaker; .75 - intermediate; .5 - beginner; 0 - none
  match_vol <- match_vol %>% mutate(same_native_lang = if_else(str_detect(native_langs, "French"), 1, 0),
                                    same_lang = if_else(str_detect(other_langs, "French"), 1, 0),
                                    same_lang_level = case_when(str_detect(other_langs, "French") & str_detect(other_langs, regex("Beginner|A1|A2|Minimal", ignore_case = TRUE )) ~ "-.5",
                                                                str_detect(other_langs, "French") & str_detect(other_langs, regex("Intermediate|B1|B2", ignore_case = TRUE)) ~ "-.25",
                                                                str_detect(other_langs, "French") & str_detect(other_langs, regex("Advanced|C1|C2", ignore_case = TRUE)) ~ "0",
                                                                TRUE ~ NA_character_)
                                    )
  
  #LEVEL PREFERENCE
  stud_level <- student %>% pull(eng_level)
  
                                    #Volunteer has very specific preference (only one level)
  match_vol <- match_vol %>% mutate(same_eng_level_pref = case_when(str_detect(tutor_level_prefs, regex(glue("^{stud_level}$"), ignore_case = TRUE)) ~ 2,
                                                                    str_detect(tutor_level_prefs, regex(glue("{stud_level}|No Preference"), ignore_case = TRUE)) ~ 1,
                                                                    TRUE ~ 0))
                                                                    
                                                                    
                                                                    
  
  

}



#First, we want to find volunteers available the same time as students
#But that's just the beginning

#We want to consider these other factors:

# - 
# 
#   
# Student
# - Has paid
# - 
# 
# Volunteer
# - How many open 'student slots' left (Up to 3 students)
# - Preferred timeslot
# - 













