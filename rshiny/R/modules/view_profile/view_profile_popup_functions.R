#-----------------------------
# viewProfile Popup Functions
#-----------------------------
# Popups only used within scope of the viewProfileServer module


show_match_popup <- function(session_input) {
  print("P-F-01:Showing match popup")
  ns <- session_input$ns
  
  showModal(
    modalDialog(title = "Match Student and Volunteer", 
                
    p("Are you sure you'd like to match these two individuals?"),
    
    actionButton(class = "standard-btn", inputId = ns(glue("secondary_match_{rec_matches_table_name}")),
                 label = "Match"),
    
    actionButton(class = "standard-btn", inputId = ns(glue("cancel_match_{rec_matches_table_name}")),
                 label = "Cancel"),
        
    footer = NULL)
  )
}