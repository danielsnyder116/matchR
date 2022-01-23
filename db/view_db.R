#---------------------
#       VIEW DB
#---------------------

conn <- dbConnect(SQLite(), DB_PATH)
dbListTables(conn)


df <- load_data("students")

options <- df %>% select(class_interest)
df_1 <- load_data("volunteers")


dbDisconnect(conn)
