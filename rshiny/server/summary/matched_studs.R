#====================
#  MATCHED STUDENTS
#====================

matched_studs <- reactive({ db_data()$STUD_FORM() %>% filter(num_slots_needed == 0) })
num_matched_studs <- reactive({ nrow(matched_studs()) })


#Outputs
#------------------

#NUM MATCHED STUDENTS
output$num_matched_studs <- renderValueBox({ 
  valueBox(value = num_matched_studs(), subtitle = "Matched Students", 
           color = "green", icon = icon("user-check"))  
})


#SUMMARY NUM MATCHED STUDENTS
output$summ_num_matched_studs <- renderValueBox({ 
  valueBox(value = num_matched_studs(), subtitle = "Matched Students", 
           color = "green", icon = icon("user-check"))  
})


#stud_hist <- reactive({ db_data()$STUD_HIST })

output$matched_studs_table <- DT::renderDT({
  DT::datatable(matched_studs()[, c('first_name', 'last_name')],
                
                class = 'cell-border stripe',
                #editable = list(target = "row", disable = list(columns = c(2, 3))),
                filter = "top",
                extensions = "Buttons",
                
                rownames = FALSE,
                colnames = c("First Name", "Last Name"),
                
                selection = 'single',
                options = list(
                  columnDefs = list(list(className = 'dt-left', targets = '_all')),
                  dom = "Btip",
                  buttons = list("copy", 
                                 list(extend = "collection", 
                                      buttons = list(
                                        list(extend = "csv", title = glue("matched_tutee_students_{str_replace_all(as.character(now()), ' |:', '_')}")),
                                        list(extend = "excel", title = glue("matched_tutee_students_{str_replace_all(as.character(now()), ' |:', '_')}")),
                                        list(extend = "pdf", title = glue("matched_tutee_students_{str_replace_all(as.character(now()), ' |:', '_')}"))
                                      ),
                                      text = "Download")
                  )
                )
  )
})  # %>% formatStyle()

