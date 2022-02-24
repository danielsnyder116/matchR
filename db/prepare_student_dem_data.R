#-----------------------------------
#  PREPARE STUDENT DEMOGRAPHIC DATA
#-----------------------------------

library(dplyr)
library(stringr)
library(tidyr)
library(lubridate)
library(tibble)

#TUTORING ONLY FORM
#-------------------


df <- read.csv("./../../data/Winter 2022 Online Tutoring Registration (Responses) - Form Responses 1.csv")

names(df) <- c('timestamp', 'notes', 'email_address', 'class_interest', 'eng_level',
               'last_name','first_name','phone_num', 'address_1', 'city_state_zip', 
               'birthday', 'gender', 'home_country', 'native_lang', 'ethnicity', 'race',
               'student_employ_status', 'student_monthly_income', 'student_num_dependents', 
               'spouse_employ_status', 'spouse_monthly_income',
               'employ_affected_by_covid', 'highest_education', 'want_same_tutor', 
               'tutor_name', 'time_available',  'where_hear_wec', 'trash_1')
               
df <- df %>% select(-c(trash_1, notes)) %>% mutate(role = "Student", status = "Unmatched")

             #removing most of the Spanish translations
df <- df %>% mutate(across(c(class_interest, eng_level, gender, ethnicity, race, 
                             student_employ_status, spouse_employ_status, highest_education, 
                             want_same_tutor, where_hear_wec), ~str_extract(., ".*/"))) %>%
  
             mutate(across(c(class_interest, eng_level, gender, ethnicity, race, 
                             student_employ_status, spouse_employ_status, highest_education, 
                             want_same_tutor, where_hear_wec), ~str_remove(., "/$| /"))) %>% 
  
             #Spanish in parentheses for this col
             mutate(ethnicity = str_extract(ethnicity, ".*\\(")) %>% mutate(ethnicity = str_remove(ethnicity, "\\(")) %>% 

             #Time available is more complicated and needs to be treated separately ;) 
             separate(time_available, into = c(paste0("time_avail_", 1:10)), sep=",", remove = TRUE) %>% 
  
             #remove Spanish translation
             mutate(across(starts_with("time_avail"), ~str_extract(., ".*/"))) %>% 
  
             #mutliple pattern not working so have to keep separate
             mutate(across(starts_with("time_avail"), ~str_remove(., "EST"))) %>%
             mutate(across(starts_with("time_avail"), ~str_remove(., "/"))) %>%
             mutate(across(everything(), ~str_squish(.)))

  
#Can't do two hours of speaking AND a Group - only case
#Shorten class_interest
df <- df %>% mutate(class_interest = case_when(str_detect(class_interest, "Conversation and") ~ "Conversation + Writing",
                                               str_detect(class_interest, "Conversation: 1") ~ "Conversation: 1 hour",
                                               str_detect(class_interest, "Conversation: 2") ~ "Conversation: 2 hours",
                                               TRUE ~ class_interest),
                    
                    want_same_tutor = case_when(str_detect(want_same_tutor, "new student") ~ "Needs New Tutor",
                                                str_detect(want_same_tutor, "new tutor") ~ "Needs New Tutor",
                                                str_detect(want_same_tutor, "and writing") ~ "Keep Same Tutor(s)",
                                                str_detect(want_same_tutor, "conversation tutor") ~ "Keep Same Tutor(s)",
                                                TRUE ~ want_same_tutor),
                    
                    
                    timestamp = as.character(mdy_hms(timestamp)),
                    birthday = as.character(mdy(birthday))
                                             
            )



#Adding age column based on birthday
df <- df %>% add_column(age = (year(now()) - year(ymd(df$birthday))) , .after = "birthday") %>%
             mutate(age = as.character(age))


write.csv(df, "../../data/students.csv", row.names = FALSE) 




#GROUP CLASS + TUTORING FORM
#---------------------------






