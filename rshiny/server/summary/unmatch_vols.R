#========================
#  UNMATCHED VOLUNTEERS 
#========================

unm_volunteers <- reactive({ db_data()$VOL_TUTOR() %>% filter(status == "Unmatched" & num_slots_needed != 0) })

unmatched_vol_names <- reactive({ db_data()$VOL_TUTOR() %>% 
                          filter(status == "Unmatched" & !str_detect(first_name, "^$|\\s+")) %>% 
                          arrange(first_name, last_name) %>%
                          mutate(full_name = paste(first_name, last_name)) %>% 
                          select(full_name)
})

num_unmatched_vols <- reactive ({ nrow(unm_volunteers()) })

#NUM UNMATCHED VOLUNTEERS
output$num_unmatched_vols <- renderValueBox({ 
  valueBox(num_unmatched_vols(), subtitle = "Volunteers to Match", 
           color = "orange", icon = icon("user-times"))
})

#SUMMARY NUM UNMATCHED VOLUNTEERS
output$summ_num_unmatched_vols <- renderValueBox({ 
  valueBox(num_unmatched_vols(), subtitle = "Volunteers to Match", 
           color = "orange", icon = icon("user-times"))
})

#TODO: Identify key cols to show in unmatched table
#Number of days since signed up
#New or returning volunteer
output$unmatched_vols_table <- DT::renderDT({
  DT::datatable(unm_volunteers()[, c('first_name', 'last_name', 'num_slots_needed', 'timestamp','returning_indicator',
                                     'reserved_student_names', 'want_additional_student_indicator')],
                
                #editable = list(target = "row", disable = list(columns = c(2, 3))),
                class = 'cell-border stripe', 
                filter = "top",
                selection =  'single',
                extensions = 'Buttons',
                
                rownames = FALSE,
                colnames = c( 'First Name', 'Last Name', 'Number Slots to Fill', 'Date Registered', 'Returning?',
                              'Reserved Students', 'Want Additional New Student?'),
                
                options = list(
                  
                  columnDefs = list(list(className = 'dt-left', targets = '_all')),
                  dom = "Btip",
                  buttons = list("copy", 
                                 list(extend = "collection", 
                                      buttons = list(
                                        list(extend = "csv", title = glue("unmatched_tutor_volunteers_{str_replace_all(as.character(now()), ' |:', '_')}")),
                                        list(extend = "excel", title = glue("unmatched_tutor_volunteers_{str_replace_all(as.character(now()), ' |:', '_')}")),
                                        list(extend = "pdf", title = glue("unmatched_tutor_volunteers_{str_replace_all(as.character(now()), ' |:', '_')}"))
                                      ),
                                      text = "Download")
                  )
                )
  )
})

