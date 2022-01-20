#-----------------------------------
#  PREPARE STUDENT DEMOGRAPHIC DATA
#-----------------------------------

library(dplyr)
library(stringr)
library(tidyr)

df <- read.csv("./../../data/Winter 2022 Online Tutoring Registration (Responses) - Form Responses 1.csv")


names(df) <- c('timestamp', 'notes', 'email_address', 'class_interest', 'eng_level',
               'last_name','first_name','phone_num', 'address_1', 'city_state_zip', 
               'birthday', 'gender', 'home_country', 'native_lang', 'ethnicity', 'race',
               'student_employ_status', 'student_monthly_income', 'student_num_dependents', 
               'spouse_employ_status', 'spouse_monthly_income',
               'employ_affected_by_covid', 'highest_education', 'want_same_tutor', 
               'tutor_name', 'time_available',  'where_hear_wec', 'trash_1')
               
df <- df %>% select(-trash_1)

write.csv(df, "../../data/students.csv", row.names = FALSE) 

