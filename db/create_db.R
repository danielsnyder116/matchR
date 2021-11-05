#---------------------
#   CREATE DB
#---------------------


setwd("/Users/Daniel/Desktop/WEC/Shiny/volman")

source("db/db_functions.R")

DB_PATH <- glue("/Users/Daniel/Desktop/WEC/Shiny/database/active/volman_db_{Sys.Date()}.db")
DB_NAME <- strsplit(DB_PATH, split = "active/")[[1]][2]

conn <- dbConnect(SQLite(), DB_PATH)

#Create DB
create_db(DB_PATH)


#Adding users table by saving pre-made csv
df_users <- read_csv("../data/initial_users.csv")
df_historical_vols <- read_csv("/Users/Daniel/Desktop/WEC/Data/Non-GS/All (2006 - Present)/all_volunteers_2006_2021_final.csv") %>%
                            mutate(across(everything(), as.character))


#Add tables
update_table(DB_PATH, "user", df_users, overwrite = TRUE)
update_table(DB_PATH, "vols_historical", df_historical_vols, overwrite = TRUE)

#Verify
dbListTables(conn)

#Disconnect from DB to avoid errors
dbDisconnect(conn)

#Delete any previously created tables if necessary
#drop_table(DB_PATH, "user")

