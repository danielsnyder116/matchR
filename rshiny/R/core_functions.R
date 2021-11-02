#---------------------
#   CORE FUNCTIONS
#---------------------


load_data <- function(table_name) {
  
  
  #Establish connection to DB
  dbConnect()
  data <- dbGetQuery()
  dbDisconnect()
  
  return(data)
}