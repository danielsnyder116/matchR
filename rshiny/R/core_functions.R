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


make_profile_tab_info <- function(id_input, name_input, role_input, status_input) {
 print("Formatting individual details to display in tab")
  
  #TODO: Convert to unit test
  #For testing
  # id_input <- "12345678"
  # name_input <- "Danny Snyder"
  # role_input <- "Volunteer"
  # status_input <- "Active"

  tab_info <-  HTML(paste0("ID: ", id_input, "<br>", 
                           "Name: ", name_input, "<br>",
                           "Role: ", role_input, "<br>",
                           "Status: ", status_input, "<br>"))
  
  return (tab_info)

}