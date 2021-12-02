#------------------------
#   viewProfileUI.R 
#------------------------
# Module to allow user to view volunter/student profile and take actions specific to that individual

#
viewProfileUI <- function(id) {
  ns <- NS(id)
  
  insertTab(inputId = "setpanel_matching", 
            
            tabPanel(title = "VIEW PROFILE")
  )
  

  h4("VIEW PROFILE")

  
  
  
}