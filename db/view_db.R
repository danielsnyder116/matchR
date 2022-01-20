#---------------------
#       VIEW DB
#---------------------

conn <- dbConnect(SQLite(), DB_PATH)
dbListTables(conn)


df <- load_data("vols_historical")
df_1 <- load_data("volunteers")


dbDisconnect(conn)
