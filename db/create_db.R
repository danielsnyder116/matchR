#---------------------
#   CREATE DB
#---------------------

setwd("/Users/Daniel/Desktop/WEC/Shiny/database")

source("/Users/Daniel/Desktop/WEC/Shiny/matchr/db/db_functions.R")

DB_PATH <- glue("/Users/Daniel/Desktop/WEC/Shiny/database/active/matchr_db_draft.db")
DB_NAME <- strsplit(DB_PATH, split = "active/")[[1]][2]

conn <- dbConnect(SQLite(), DB_PATH)

#Create DB
create_db(DB_PATH)

#Adding users table by saving pre-made csv
df_users <- read_csv("../data/initial_users.csv")
df_historical_vols <- read_csv("/Users/Daniel/Desktop/WEC/Data/Non-GS/All (2006 - Present)/all_volunteers_2006_spring_2021.csv") %>%
                            mutate(across(everything(), as.character))

#Data volunteers submitted via google form
volunteers <- read_csv("../data/volunteers.csv") 
volunteers <- volunteers %>% mutate(id = 1:nrow(volunteers)) %>% select(id, everything())

#Data students submitted via google forms
students <- read.csv("../data/students.csv")
students <- students %>% mutate(id = 1:nrow(students)) %>% select(id, everything())

#Add tables
update_table(DB_PATH, "user", df_users, overwrite = TRUE)
update_table(DB_PATH, "students", students, overwrite = TRUE)
update_table(DB_PATH, "vols_historical", df_historical_vols, overwrite = TRUE)
update_table(DB_PATH, "volunteers", volunteers, overwrite = TRUE)

#Verify
dbListTables(conn)

#Disconnect from DB to avoid errors
dbDisconnect(conn)

#Delete any previously created tables if necessary
#drop_table(DB_PATH, "user")

