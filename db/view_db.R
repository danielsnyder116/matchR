#---------------------
#       VIEW DB
#---------------------

source("./../db/db_functions.R")

conn <- dbConnect(SQLite(), DB_PATH)
dbListTables(conn)


df <- load_data("vol_tutors")

glimpse(df)

df <- df %>% mutate(across(everything(), ~as.character(.))) %>% replace_na(list(age = NA_character_))



update_table(DB_PATH, "vol_tutors", df, overwrite = TRUE)

dbDisconnect(conn)
