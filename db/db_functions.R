#---------------------
#   DB_FUNCTIONS
#---------------------


#'
#'
#'
#'
#'--------------------------------------------------
create_db <- function(db_path_input) {
  
  conn <- dbConnect(SQLite(), db_path_input)
  
  db_name <- strsplit(DB_PATH, split = "active/")[[1]][2]
  
  print(glue("Created db called **{db_name}**"))
  print("Tables already in db (if previously created):")
  print(dbListTables(conn))
  
  dbDisconnect(conn)
  
  
}



#'
#'
#'
#'
#'--------------------------------------------------
update_table <- function(db_path, table_name, table_contents, overwrite = FALSE, append = TRUE) {
  
  conn <- dbConnect(SQLite(), db_path)
  
  
  if (overwrite == FALSE) {
    dbWriteTable(conn, table_name, table_contents, overwrite = FALSE, append = TRUE) 
    dbDisconnect(conn)
  }
  
  else {
    dbWriteTable(conn, table_name, table_contents, overwrite = TRUE, append = FALSE) 
    dbDisconnect(conn)
  }
  
}

drop_table <- function(db_path, table_name) {
  
  conn <- dbConnect(SQLite(), db_path)
  dbExecute(conn, glue('DROP TABLE {table_name};'))
  dbDisconnect(conn)
  
}



