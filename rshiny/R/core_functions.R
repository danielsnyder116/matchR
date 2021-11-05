#---------------------
#   CORE FUNCTIONS
#---------------------


load_data <- function(table_name) {
  
  print(glue("CF-01:Loading table **{table_name}**"))
  
  #Establish connection to DB
  conn <- dbConnect(SQLite(), DB_PATH)
  dbListTables(conn)
  data <- dbGetQuery(conn, glue('SELECT * FROM {table_name}'))
  dbDisconnect(conn)
  
  return(data)
}