#------------------------
#   viewProfileUI.R 
#------------------------
# Module to allow user to view volunter/student profile and take actions specific to that individual

#
viewProfileUI <- function(id, rv_input) {
  ns <- NS(id)
  
  tabPanel(title = indiv_info,
           value = ns(glue("{rv_input$id}_tab")),
           
           div(class = 'standard-btn', actionButton(inputId = ns(glue("close_tab_button_{rv_input$id}")), 
                                                    label = "Close Tab"), style="padding-left:210px;"),  #910
           
           br(),
           
           tabsetPanel(id=ns(glue("details_{rv_input$id}")),
                       
                       tabPanel(title = "Profile",
                                value = ns("profile_tab"),
                                
                                
                                br()
                       ),
                       
                       tabPanel(title = "Current Semester",
                                value = ns("current_semester_tab"),
                                
                                
                                
                                
                       ),
                       
                       tabPanel(title = "Previous Semester",
                                value = ns("previous_semester_tab")
                                
                                
                                
                       ),
                       
                       tabPanel(title = "History",
                                value = ns("history_tab")
                       ),
           ) #tabsetPanel   
  ) #tabPanel

  
}