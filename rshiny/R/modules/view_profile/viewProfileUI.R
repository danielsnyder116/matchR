#------------------------
#   viewProfileUI.R 
#------------------------
# Module to allow user to view volunter/student profile and take actions specific to that individual

#
viewProfileUI <- function(id) {
  ns <- NS(id)
  
  tabPanel(title = indiv_info,
           value = ns(glue("{rv$id}_tab")),
           
           div(class = 'standard-btn', actionButton(inputId = ns(glue("close_tab_button_{rv$id}")), 
                                                    label = "x", style="color:white;background-color:red; font-weight:bold;"), 
                    style="padding-left:920px;"), 
           
           
           tabsetPanel(id=ns(glue("details_{rv$id}")),
                       
                       tabPanel(title = "Recommended Matches",
                                value = ns("match_recs_tab"),
                              br(), 

                              column(5,
                                     
                                disabled(actionButton(inputId = ns(glue("initial_match_{rec_matches_table_name}")), 
                                                  label = "Match", icon = icon("people-arrows"))), #icon("exchange-alt")
                                br(), br(),
                                     
                                DT::dataTableOutput(ns(rec_matches_table_name))
                              ),
                              
                             
                            
                              
                                
                                
                       ),
                       
                       tabPanel(title = "Current Semester",
                                value = ns("current_semester_tab"),
                                
                                
                                
                                
                       ),
                       
                       tabPanel(title = "Previous Semester",
                                value = ns("previous_semester_tab")
                                
                                
                                
                       ),
                       
                       tabPanel(title = "Profile",
                                value = ns("profile_tab"),

                                br(),
                                
                                DT::dataTableOutput(outputId = ns(profile_table_name))
                       ),
                       
                       tabPanel(title = "All History",
                                value = ns("history_tab")
                       ),
           ) #tabsetPanel   
  ) #tabPanel

  
}