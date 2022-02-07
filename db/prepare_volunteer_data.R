#---------------------------
#  PREPARE VOLUNTEER DATA
#---------------------------

#Lots of work to do here but skipping for now to get prototype working in Shiny

library(dplyr)
library(stringr)
library(tidyr)
library(lubridate)
library(tibble)

df <- read.csv("./../../data/Fall 2021 Volunteer Form (Responses) - Form Responses 1.csv")

names(df) <- c(   'timestamp',
                  'email_address', 
                  'notes',
                  'placed_as_tutor_teacher', 
                  'proof_of_vax',                    #5
                  'vol_intention', 
                  'leave_wec_full_name',
                  'leave_student_name_tutor',
                  'student_notified_indicator',
                  'first_name',                      #10
                  'last_name',
                  'phone_num',
                  'returning_indicator',
                  'previous_role',
                  'reserved_student_names',          #15
                  'reregister_ackn_1',
                  'reregister_ackn_2',
                  'desired_start_date',
                  'details_multiple_dates',
                  'want_new_student_role_indicator', #20
                  'where_hear_wec',
                  'why_serve',
                  'past_apply_not_placed',
                  'had_onboard_call_with_staff',
                  'pref_role_1',                     #25
                  'pref_program', 
                  'avail_am_class_online',
                  'avail_am_class_person',
                  'avail_pm_class_online',
                  'avail_pm_class_person',           #30
                  'avail_citizen_class_online',
                  'class_level_prefs',
                  'pref_solo_indicator',
                  'co_teach_info',
                  'teacher_format_prefs',            #35
                  'other_class_sched_info',
                  'tutor_type_pref',
                  'pref_tutor_slot',
                  'avail_am_tutor',
                  'avail_pm_tutor',                  #40
                  'avail_wknd_tutor',
                  'tutor_level_prefs',
                  'num_new_students',
                  'avail_before_sep_27_indicator',
                  'other_tutor_sched_info',          #45
                  'pref_role_2',
                  'pref_program_2',
                  'avail_am_class_online_2',
                  'avail_am_class_person_2',
                  'avail_pm_class_online_2',         #50
                  'avail_pm_class_person_2', 
                  'avail_citizen_class_online_2',
                  'class_level_prefs_2',
                  'pref_solo_indicator_2', 
                  'co_teach_info_2',                 #55
                  'teacher_format_prefs_2',
                  'open_to_accept_both_roles_indicator',
                  'other_class_sched_info_2',
                  'tutor_type_pref_2',
                  'pref_tutor_slot_2',               #60
                  'avail_am_tutor_2',
                  'avail_pm_tutor_2',
                  'tutor_level_prefs_2',
                  'num_new_students_2',
                  'open_to_accept_both_roles_indicator_2', #65
                  'avail_before_sep_27_indicator_2',
                  'other_tutor_sched_info_2',
                  'interest_in_sub_list',
                  'address_1',
                  'address_2',                       #70
                  'city_state_zip',
                  'emerg_cont_first_name',
                  'emerg_cont_last_name',
                  'emerg_cont_phone',
                  'emerg_cont_relation',            #75
                  'gender',
                  'birthday',
                  'race',
                  'ethnicity',
                  'native_langs',                  #80
                  'other_langs',
                  'highest_education',
                  'prior_experience',
                  'teach_certs',
                  'educ_credentials',              #85
                  'employer',
                  'position',
                  'work_field',
                  'retired_past_work_field',
                  'med_conditions',                #90
                  'med_details',
                  'trash_1',
                  'trash_2',
                  'trash_3',
                  'trash_4')

#Ignore warning with birthday - because some volunteers purposefully did not give birthday
df <- df %>% select(-c(trash_1, trash_2, trash_3, trash_4, notes)) %>% 
             unite(open_to_accept_both_roles_all, open_to_accept_both_roles_indicator, open_to_accept_both_roles_indicator_2, sep="") %>%
             unite(avail_before_date_indicator, avail_before_sep_27_indicator, avail_before_sep_27_indicator_2, sep="") %>%
             mutate(timestamp = as.character(mdy_hms(timestamp)),
                    birthday = as.character(mdy(birthday)))

#Adding age column based on birthday
df <- df %>% add_column(age = as.integer(year(now()) - year(ymd(df$birthday))) , .after = "birthday")


#Recoding variables for clarity and brevity
df <- df %>% mutate(open_to_accept_both_roles_all = case_when(str_detect(open_to_accept_both_roles_all, "Yes") ~ "Yes",
                                                              str_detect(open_to_accept_both_roles_all, "^$|No") ~ "No",
                                                              TRUE ~ open_to_accept_both_roles_all),
                    
                    pref_solo_indicator = case_when(str_detect(pref_solo_indicator, "pair") ~ "Pair",
                                                    str_detect(pref_solo_indicator, "flexible") ~ "Prefer Alone but Flexible",
                                                    str_detect(pref_solo_indicator, "alone\\.") ~ "Solo",
                                                    str_detect(pref_solo_indicator, "^$") ~ "NA - Tutor",
                                                    TRUE ~ pref_solo_indicator),
                    
                    pref_solo_indicator_2 = case_when(str_detect(pref_solo_indicator_2, "co-") ~ "Pair",
                                                      str_detect(pref_solo_indicator_2, "flexible") ~ "Prefer Alone but Flexible",
                                                      str_detect(pref_solo_indicator, "^$") ~ "No Response",
                                                      TRUE ~ pref_solo_indicator_2))

                   
          

#Volunteers Letting WEC Know They ARE NOT Returning
#--------------------------------------------------
df_leave <- df %>% filter(vol_intention == "NO") %>% select(1:8)
#--------------------------------------------------

#Filtering out the non-returning volunteers and dropping columns no longer needed
df <- df %>% filter(vol_intention == "YES") %>% 
             select(-c(leave_wec_full_name, leave_student_name_tutor, student_notified_indicator))

#Tutor with same student
#--------------------------------------------------
df_same_match <- df %>% filter(pref_role_1 == "") %>% select(1:want_new_student_role_indicator)



#--------------------------------------------------

#Filtering out continued tutor matches
df <- df %>% filter(pref_role_1 != "")

# Only want first choice
#--------------------------------------------------
df_first <- df %>% filter(str_detect(pref_role_2, "^$|None"))

df_first_tutor <- df_first %>% filter(pref_role_1 == "Online One-on-One Tutor")
#--------------------------------------------------

#Filtering out only first choice
# First AND Second Choice
#--------------------------------------------------
df_both_choices <- df %>% filter(!str_detect(pref_role_2, "^$|None")) %>% filter(pref_role_1 == "Online One-on-One Tutor" | pref_role_2 == "Online One-on-One Tutor")
#--------------------------------------------------


#FOCUSING ON THOSE INTERESTED IN ONLINE TUTORING

#Get rid of unused cols
#Getting rid of First Instances of CLASS-related fields and ALL 2ND CHOICE fields
df_first_tutor <- df_first_tutor %>% select(-c(pref_program,  avail_am_class_online, 
                                               avail_am_class_person, avail_pm_class_online, 
                                               avail_pm_class_person, avail_citizen_class_online, 
                                               class_level_prefs, pref_solo_indicator, co_teach_info,  
                                               teacher_format_prefs, open_to_accept_both_roles_all, 
                                               other_class_sched_info, 
                                               
                                               pref_role_2, pref_program_2, avail_am_class_online_2, 
                                               avail_am_class_person_2, avail_pm_class_online_2, 
                                               avail_pm_class_person_2, avail_citizen_class_online_2, 
                                               class_level_prefs_2, pref_solo_indicator_2, co_teach_info_2,  
                                               teacher_format_prefs_2, other_class_sched_info_2, 
                                               tutor_type_pref_2,  pref_tutor_slot_2,
                                               avail_am_tutor_2, avail_pm_tutor_2, tutor_level_prefs_2,  
                                               num_new_students_2, other_tutor_sched_info_2 ))
                                                

#All the first preferences are tutoring
df_both_tutor <- df_both_choices %>% filter(pref_role_2 == "Online One-on-one tutor")

#Getting rid of First and Second Instances of CLASS-related fields
df_both_tutor <- df_both_tutor %>% select(-c(pref_program, avail_am_class_online, 
                                             avail_am_class_person, avail_pm_class_online, 
                                             avail_pm_class_person, avail_citizen_class_online, 
                                             class_level_prefs, pref_solo_indicator, co_teach_info,  
                                             teacher_format_prefs, open_to_accept_both_roles_all,  
                                             other_class_sched_info,
                                             
                                             pref_role_2, pref_program_2, avail_am_class_online_2, 
                                             avail_am_class_person_2, avail_pm_class_online_2, 
                                             avail_pm_class_person_2, avail_citizen_class_online_2, 
                                             class_level_prefs_2, pref_solo_indicator_2, co_teach_info_2,  
                                             teacher_format_prefs_2, other_class_sched_info_2))

#Getting rid of First Instance of CLASS-related fields and Second Instance of TUTOR-related fields
df_mixed_tutor <- df_both_choices %>% filter(pref_role_2 != "Online One-on-one tutor") %>%
                                      select(-c(pref_program, avail_am_class_online, 
                                                avail_am_class_person, avail_pm_class_online, 
                                                avail_pm_class_person, avail_citizen_class_online, 
                                                class_level_prefs, pref_solo_indicator, co_teach_info,  
                                                teacher_format_prefs, open_to_accept_both_roles_indicator,  
                                                other_class_sched_info,
                                                
                                                tutor_type_pref_2,  pref_tutor_slot_2,
                                                avail_am_tutor_2, avail_pm_tutor_2, tutor_level_prefs_2,  
                                                num_new_students_2, other_tutor_sched_info_2))


# - same_match -> Already matched
# - first_tutor -> only want tutoring, unmatched
# - both_tutor -> only want tutoring, conversation vs writing preference 
# - mixed_tutor -> 

#Reordering columns 
# df_criteria <- df %>% select('first_name', 'last_name', 'email_address',
#                              'gender','native_langs', 'other_langs',
#                              'prior_experience', 'teach_certs', 'educ_credentials',
#                              
#                              'timestamp', 'proof_of_vax', 
#                              'returning_indicator',
#                              'previous_role',
#                              'reserved_student_names',
#                              'reregister_ackn_1',
#                              'reregister_ackn_2',
#                              'desired_start_date',
#                              'details_multiple_dates',
#                              'want_new_student_role_indicator',
#                              'past_apply_not_placed',
#                              'had_onboard_call_with_staff',
#                              'pref_role_1',
#                              'pref_program',
#                              'avail_am_class_online',
#                              'avail_am_class_person',
#                              'avail_pm_class_online',
#                              'avail_pm_class_person',
#                              'avail_citizen_class_online',
#                              'class_level_prefs',
#                              'pref_solo_indicator',
#                              'co_teach_info',
#                              'teacher_format_prefs',
#                              'other_class_sched_info',
#                              'tutor_type_pref',
#                              'pref_tutor_slot',
#                              'avail_am_tutor',
#                              'avail_pm_tutor',
#                              'avail_wknd_tutor',
#                              'tutor_level_prefs',
#                              'num_new_students',
#                              'avail_before_sep_27_indicator',
#                              'other_tutor_sched_info',
#                              'pref_role_2',
#                              'pref_program_2',
#                              'avail_am_class_online_2',
#                              'avail_am_class_person_2',
#                              'avail_pm_class_online_2',
#                              'avail_pm_class_person_2',
#                              'avail_citizen_class_online_2',
#                              'class_level_prefs_2',
#                              'pref_solo_indicator_2',
#                              'co_teach_info_2',
#                              'teacher_format_prefs_2',
#                              'open_to_accept_both_roles_indicator',
#                              'other_class_sched_info_2',
#                              'tutor_type_pref_2',
#                              'pref_tutor_slot_2',
#                              'avail_am_tutor_2',
#                              'avail_pm_tutor_2',
#                              'tutor_level_prefs_2',
#                              'num_new_students_2',
#                              'open_to_accept_both_roles_indicator_2',
#                              'avail_before_sep_27_indicator_2',
#                              'other_tutor_sched_info_2'
# )


df <- df %>% mutate(role = "Volunteer", status = "Unmatched")
write.csv(df_criteria, "../../data/volunteers.csv", row.names = FALSE) 

#For cases where 2nd and 3rd choice roles are not filled, drop

