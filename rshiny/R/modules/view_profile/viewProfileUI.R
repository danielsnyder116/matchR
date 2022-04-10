#------------------------
#   viewProfileUI.R 
#------------------------
# Module to allow user to view volunter/student profile and take actions specific to that individual

#
viewProfileUI <- function(id) {
  ns <- NS(id)
  
  tabPanel(title = indiv_info,
           value = ns(glue("{rv$id}_tab")),
           
           
           div(actionButton(inputId = ns(glue("close_tab_button_{rv$id}")),
                                                    label = "X", style="color:white;background-color:#d95755; font-weight:bold;"), 
                    style="padding-left:1300px; padding-top:8px;"), 
           
           
           tabsetPanel(id=ns(glue("details_{rv$id}")),
                       
                       #PROFILE
                       tabPanel(title = "Profile",
                                value = ns("profile_tab"),
                                br(),
                                
                                fluidRow(
                                  column(12,
                                         disabled(actionButton(class = 'standard-btn', inputId = ns(glue('initial_update_profile_{indiv_notes_table_name}')),
                                                               label = "Update Info", icon=icon("user-edit", style="padding-right: 4px;"))),
                                         br(), br(),
                                         div(DT::dataTableOutput(outputId = ns(contact_table_name)), style="white-space:nowrap;")
                                  )
                                ),
                                
                                br(),
                                
                                fluidRow(
                                  column(6,
                                     div(DT::dataTableOutput(outputId = ns(dem_table_name)), style="white-space:nowrap;")
                                  ),
                               
                                  column(6,
                                         div(DT::dataTableOutput(outputId = ns(details_table_name)), style="white-space:nowrap;")
                                  )
                               ) #fluidRow
                       ), #tabPanel
                       
                       
                       #RECOMMENDED MATCHES
                       tabPanel(title = "Recommended Matches",
                                value = ns("match_recs_tab"),
                              br(), 

                              
                                     
                                disabled(actionButton(class='standard-btn', inputId = ns(glue("initial_match_{rec_matches_table_name}")), 
                                                  label = "Match", icon = icon("people-arrows"))), #icon("exchange-alt")
                                
                                actionButton(class='standard-btn', inputId = ns(glue("initial_run_algo_{rec_matches_table_name}")),
                                                      label = "Rerun Algorithm", icon = icon("redo", style='padding-right: 4px;')),
                              
                                h5("Click on a row to enable button and confirm new match."),
                                
                                br(),
                              
                              column(5,
                                     
                                div(DT::dataTableOutput(ns(rec_matches_table_name)), style="white-space:nowrap;")
                              ),
                              
                       ),
                       
                   
                       #NOTES
                       tabPanel(title = "Notes",
                                value = ns("notes_tab"),
                                br(),
                                
                                disabled(actionButton(class = 'standard-btn', inputId = ns(glue('initial_add_note_{indiv_notes_table_name}')),
                                             label = "Add", icon=icon("plus", style="padding-right: 4px;"))),
                                
                                disabled(actionButton(class = 'standard-btn', inputId = ns(glue('initial_edit_note_{indiv_notes_table_name}')),
                                             label = "Edit", icon=icon("edit", style="padding-right: 4px;"))),
                                
                                disabled(actionButton(class = 'standard-btn', inputId = ns(glue('initial_delete_note_{indiv_notes_table_name}')),
                                             label = "Delete", icon=icon("trash-alt", style="padding-right: 4px;"))),
                                br(), 
                                
                                div(DT::dataTableOutput(outputId = ns(indiv_notes_table_name)), style="white-space:nowrap; padding:0px 20px 20px 20px;")
       
                       )#,
                       
                       # #CURRENT SEMESTER
                       # tabPanel(title = "Current Semester",
                       #          value = ns("current_semester_tab"),
                       #          
                       # ),
                       # 
                       # #PREVIOUS SEMESTER
                       # tabPanel(title = "Previous Semester",
                       #          value = ns("previous_semester_tab")
                       #          
                       # ),
                       # 
                       # 
                       # #ALL HISTORY
                       # tabPanel(title = "All History",
                       #          value = ns("history_tab")
                       # ),
           ) #tabsetPanel   
  ) #tabPanel

  
}