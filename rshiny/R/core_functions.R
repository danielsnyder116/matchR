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

get_reactive_values <- function() {
  
}

update_reactive_values <- function(rv_input, df_value, row_value){
  
  #Set reactive values 
  rv_input$id <- df_value$id[row_value]
  rv_input$name <- paste(df_value$first_name[row_value], df_value$last_name[row_value])
  rv_input$role <- "Volunteer"
  
  print(glue("Updated reactive values - current indiv: {rv_input$name}"))
  
}






make_profile_tab_info <- function(name_input, role_input) {
 print("Formatting individual details to display in tab")
  
  #id_input, status_input 
  #"ID: ", id_input, "<br>", 
  #"Status: ", status_input, "<br>"
  
  #TODO: Convert to unit test
  #For testing
  # name_input <- "Danny Snyder"
  # role_input <- "Volunteer"

  tab_info <-  HTML(paste0("Name: ", name_input, "<br>",
                           "Role: ", role_input, "<br>"))
  
  return (tab_info)

}