#---------------------
#   CREATE DB
#---------------------
library(RSQLite)
library(dplyr)
library(glue)

setwd("/Users/Daniel/Desktop/WEC/Shiny/database")

source("/Users/Daniel/Desktop/WEC/Shiny/matchr/db/db_functions.R")

DB_PATH <- glue("/Users/Daniel/Desktop/WEC/Shiny/database/active/matchr.db")
DB_NAME <- strsplit(DB_PATH, split = "active/")[[1]][2]

conn <- dbConnect(SQLite(), DB_PATH)

#Create DB
create_db(DB_PATH)
#drop_table(DB_PATH, "volunteers")

#Adding users table by saving pre-made csv
df_users <- read.csv("../data/initial_users.csv")
# df_historical_vols <- read.csv("/Users/Daniel/Desktop/WEC/Data/Non-GS/All (2006 - Present)/all_volunteers_2006_spring_2021.csv") %>%
#                             mutate(across(everything(), as.character))
# 
# #Data volunteers submitted via google form
# volunteers <- read.csv("../data/volunteers.csv") 
# volunteers <- volunteers %>% mutate(id = 1:nrow(volunteers)) %>% select(id, everything())

df_tutors <- read.csv("../data/tutor_vols.csv") 
df_tutors <- df_tutors %>% mutate(id = 1:nrow(df_tutors), num_slots_needed = 2) 

#Data students submitted via google forms
students <- read.csv("../data/students.csv")
students <- students %>% mutate(id = 1:nrow(students), num_slots_needed = 2) %>% select(id, everything())


#Matches
matches <- tibble(match_id = character(),
                  match_owner = character(),
                  match_type = character(),
                  status = character(),
                  vol_id = integer(),
                  vol_name = character(),
                  vol_email = character(),
                  stud_id = integer(),
                  stud_name = character(),
                  stud_email = character(),
                  meeting_time = character(),
                  date_matched = character(),
                  num_sessions_completed = character()
            )


#Empty dataframe for notes
indiv_notes <- tibble(id = character(),
                   role = character(),
                   note_category = character(), 
                   note_contents = character(),
                   note_owner = character(),
                   note_date = character()
               )

#Empty dataframe for match notes
match_notes <- tibble(match_id = character(),
                   note_category = character(), 
                   note_contents = character(),
                   note_owner = character(),
                   note_date = character()
            )

#Add tables
update_table(DB_PATH, "user", df_users, overwrite = TRUE)
update_table(DB_PATH, "students", students, overwrite = TRUE)


# update_table(DB_PATH, "vols_historical", df_historical_vols, overwrite = TRUE)
# update_table(DB_PATH, "volunteers", volunteers, overwrite = TRUE)

update_table(DB_PATH, "vol_tutors", df_tutors, overwrite = TRUE)

update_table(DB_PATH, "matches", matches, overwrite = TRUE)
update_table(DB_PATH, "match_notes", match_notes, overwrite = TRUE)

update_table(DB_PATH, "indiv_notes", indiv_notes, overwrite = TRUE)



#Verify
dbListTables(conn)

#Disconnect from DB to avoid errors
dbDisconnect(conn)

#Delete any previously created tables if necessary
#drop_table(DB_PATH, "user")

