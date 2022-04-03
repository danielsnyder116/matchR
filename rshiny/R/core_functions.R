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





#Need to get rvs from tab to then set as current rv when viewing a tab
#TODO
# get_reactive_values <- function() {
#   
# }

update_reactive_values <- function(df_value, row_value){
  
  #Set reactive values 
  rv$id <<- df_value$id[row_value]
  rv$name <<- paste(df_value$first_name[row_value], df_value$last_name[row_value])
  rv$role <<- df_value$role[row_value]
  rv$status<<- df_value$status[row_value]
  
  print(glue("Updated reactive values - current indiv:  {rv$id} {rv$name} {rv$role}"))
  
}






make_profile_tab_info <- function(id_input, name_input, role_input) {
 print("Formatting individual details to display in tab")
  
  #id_input, status_input 
  #"ID: ", id_input, "<br>", 
  #"Status: ", status_input, "<br>"
  
  #TODO: Convert to unit test
  #For testing
  # name_input <- "Danny Snyder"
  # role_input <- "Volunteer"

  tab_info <-  div(HTML(paste0("<b>ID:</b> ", id_input, "<br>",
                               "<b>Name:</b> ", name_input, "<br>",
                               "<b>Role:</b> ", role_input, "<br>")), style ='font-size: 11px;')
  
  return (tab_info)

}


# get_rv_from_profile_tab <- function(tab_input) {
#   print("Extracting individual from tab html")
#   
#   #Set reactive values 
#   rv_input$id <<-
#   rv_input$name <<- 
#   rv_input$role <<- 
#   rv_input$status <<- 
#   
#   print(glue("Updated reactive values - current indiv: {rv$name} {rv$role}"))
#   
# }