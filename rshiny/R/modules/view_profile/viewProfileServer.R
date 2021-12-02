#------------------------
#   viewProfileServer.R 
#------------------------
# Module to allow user to view volunter/student profile and take actions specific to that individual

#https://appsilon.com/how-to-safely-remove-a-dynamic-shiny-module/
viewProfileServer <- function(id) {
  
  moduleServer(id, function(input, output, session) {
    
    ns <- session$ns
    
    tables <- reactiveVal(NULL)
    
    
    #Bring in all functions needed only for viewProfile
    source("./")
    
    #Function to get user info
    #tables[[]] <- get_user_info()
    
    
    # test$a <- observeEvent()
    # test$b <- observeEvent()
    # 
    # test$destroy()
    
    #Use lapply to apply destroy function to a list of all the OEs)
    
    
    
  })
}