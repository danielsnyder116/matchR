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

show_run_algo_popup <- function(session_input) {
  print("P-F-02:Showing run algorithm popup")
  ns <- session_input$ns
  
  showModal(
    modalDialog(title = "Re-Run Matching Algorithm", 
                
                p("Are you sure you want to re-run the matching algorithm? 
                  You should only do this when you've updated student or volunteer information.
                  The matching algorithm is automatically re-run after matches and unmatches for you."),
                
                actionButton(class = "standard-btn", inputId = ns(glue("secondary_run_algo_{rec_matches_table_name}")),
                             label = "Rerun Algorithm"),
                
                actionButton(class = "standard-btn", inputId = ns(glue("cancel_run_algo_{rec_matches_table_name}")),
                             label = "Cancel"),
                
                footer = NULL)
  )
}