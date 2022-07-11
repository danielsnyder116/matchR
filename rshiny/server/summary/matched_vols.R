#======================
# MATCHES (CONFIRMED)
#======================

new_matches <- reactive({ db_data()$MATCHES() %>% filter(match_type == "New") })
re_matches <- reactive({ db_data()$MATCHES() %>% filter(match_type == "Re") })


output$new_matches_table <- DT::renderDT({
  DT::datatable(new_matches(), #[, c('first_name', 'last_name', 'gender', 'native_lang', 'timestamp',
                #'want_same_tutor')],
                
                class = 'cell-border stripe',
                #editable = list(target = "row", disable = list(columns = )),
                filter = "top",
                extensions = "Buttons",
                
                rownames = FALSE,
                #colnames = c("First Name", "Last Name", "Gender", "Native Language", "Date Registered", "Need New Tutor?"),
                
                selection = 'single',
                options = list(
                  columnDefs = list(list(className = 'dt-left', targets = '_all')),
                  dom = "Btip",
                  buttons = list("copy", 
                                 list(extend = "collection", 
                                      buttons = list(
                                        list(extend = "csv", title = glue("tutoring_new_matches_{str_replace_all(as.character(now()), ' |:', '_')}")),
                                        list(extend = "excel", title = glue("tutoring_new_matches_{str_replace_all(as.character(now()), ' |:', '_')}")),
                                        list(extend = "pdf", title = glue("tutoring_new_matches_{str_replace_all(as.character(now()), ' |:', '_')}"))
                                      ),
                                      text = "Download")
                  )
                )
)
})  # %>% formatStyle()


output$re_matches_table <- DT::renderDT({
  DT::datatable(re_matches(), #[, c('first_name', 'last_name', 'gender', 'native_lang', 'timestamp',
                #'want_same_tutor')],
                
                class = 'cell-border stripe',
                #editable = list(target = "row", disable = list(columns = )),
                filter = "top",
                selection = 'single',
                extensions = "Buttons",
                
                rownames = FALSE,
                #colnames = c("First Name", "Last Name", "Gender", "Native Language", "Date Registered", "Need New Tutor?"),
                
                options = list(
                  columnDefs = list(list(className = 'dt-left', targets = '_all')),
                  dom = "Btip",
                  buttons = list("copy", 
                                 list(extend = "collection", 
                                      buttons = list(
                                        list(extend = "csv", title = glue("tutoring_rematches_{str_replace_all(as.character(now()), ' |:', '_')}")),
                                        list(extend = "excel", title = glue("tutoring_rematches_{str_replace_all(as.character(now()), ' |:', '_')}")),
                                        list(extend = "pdf", title = glue("tutoring_rematches_{str_replace_all(as.character(now()), ' |:', '_')}"))
                                      ),
                                      text = "Download")
                  )
                )
)
})  # %>% formatStyle()

#-------------------------------------------------------------------------------------------------------------------------

#========================
#  MATCHED VOLUNTEERS 
#========================

matched_vols <- reactive({ db_data()$VOL_TUTOR() %>% filter(num_slots_needed == 0) })
num_matched_vols <- reactive({ nrow(matched_vols()) })

#NUM MATCHED VOLUNTEERS
output$num_matched_vols <- renderValueBox({ 
  valueBox(num_matched_vols(), subtitle = "Matched Volunteers", 
           color = "green", icon = icon("user-check"))
})

#SUMMARY NUM MATCHED VOLUNTEERS
output$summ_num_matched_vols <- renderValueBox({ 
  valueBox(num_matched_vols(), subtitle = "Matched Volunteers", 
           color = "green", icon = icon("user-check"))
})



#TODO: Identify key cols to show in unmatched table
#Number of days since signed up
#New or returning volunteer
output$matched_vols_table <- DT::renderDT({
  DT::datatable(matched_vols()[, c('first_name', 'last_name', 'returning_indicator')],
                
                #editable = list(target = "row", disable = list(columns = c(2, 3))),
                class = 'cell-border stripe', 
                filter = "top",
                selection =  'single',
                extensions = "Buttons",
                
                rownames = FALSE,
                colnames = c( 'First Name', 'Last Name', 'Returning?'),
                options = list(
                  
                  columnDefs = list(list(className = 'dt-left', targets = '_all')),
                  dom = "Btip",
                  buttons = list("copy", 
                                 list(extend = "collection", 
                                      buttons = list(
                                        list(extend = "csv", title = glue("matched_tutor_volunteers_{str_replace_all(as.character(now()), ' |:', '_')}")),
                                        list(extend = "excel", title = glue("matched_tutor_volunteers_{str_replace_all(as.character(now()), ' |:', '_')}")),
                                        list(extend = "pdf", title = glue("matched_tutor_volunteers_{str_replace_all(as.character(now()), ' |:', '_')}"))
                                      ),
                                      text = "Download")
                  )
                )
  )
})




