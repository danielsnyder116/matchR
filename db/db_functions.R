#---------------------
#   DB_FUNCTIONS
#---------------------


#'
#'
#'
#'
#'--------------------------------------------------
create_db <- function() {
  db <- dbConnect(SQLite(), glue("volman_db_{Sys.Date()}"))
  dbListTables(db)
  dbDisconnect(db)
  
  
  dbExecute(db, "CREATE TABLE blah (
                  field TEXT,
                  field1 TEXT
                );")
  
  
}



#'
#'
#'
#'
#'--------------------------------------------------
update_table <- function(conn, table_name, table_contents, overwrite = FALSE, append = TRUE) {
  
  if (overwrite == FALSE) {
    dbWriteTable(conn, table_name, table_contents, overwrite = FALSE, append = TRUE) 
  }
  
  else {
    dbWriteTable(conn, table_name, table_contents, overwrite = TRUE, append = FALSE) 
  }
  
}




