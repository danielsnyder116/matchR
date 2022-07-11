#====================
# UNMATCHED STUDENTS
#====================

unm_students <- reactive({ db_data()$STUD_FORM() %>% filter(status == "Unmatched" & num_slots_needed != 0) })
num_unmatched_studs <- reactive({ nrow(unm_students()) })

unmatched_stud_names <- reactive({ db_data()$STUD_FORM() %>% 
    filter(status == "Unmatched" & !str_detect(first_name, "^$|\\s+")) %>% 
    arrange(first_name, last_name) %>%
    mutate(full_name = paste(first_name, last_name)) %>% 
    select(full_name)
})



#Outputs
#------------------

#NUM UNMATCHED STUDENTS
output$num_unmatched_studs <- renderValueBox({ 
  valueBox(value = num_unmatched_studs(), subtitle = "Students to Match", 
           color = "orange", icon = icon("user-times"))  
})

#SUMMARY NUM UNMATCHED STUDENTS
output$summ_num_unmatched_studs <- renderValueBox({ 
  valueBox(value = num_unmatched_studs(), subtitle = "Students to Match", 
           color = "orange", icon = icon("user-times"))  
})



#stud_hist <- reactive({ db_data()$STUD_HIST })

output$unmatched_stud_table <- DT::renderDT({
  DT::datatable(unm_students()[, c('first_name', 'last_name', 'num_slots_needed', 'timestamp', 'native_lang', 
                                   'want_same_tutor', 'tutor_name', 'made_payment')],
                
                class = 'cell-border stripe',
                #editable = list(target = "row", disable = list(columns = c(2, 3))),
                filter = "top",
                extensions = "Buttons",
                
                rownames = FALSE,
                colnames = c("First Name", "Last Name", "Number Slots to Fill", "Date Registered", "Native Language", 
                             "Need New Tutor?", 'Reserved Tutor(s)', "Paid?"),
                
                selection = 'single',
                options = list(
                  columnDefs = list(list(className = 'dt-left', targets = '_all')),
                  dom = "Btip",
                  buttons = list("copy", 
                                 list(extend = "collection", 
                                      buttons = list(
                                        list(extend = "csv", title = glue("unmatched_tutee_students_{str_replace_all(as.character(now()), ' |:', '_')}")),
                                        list(extend = "excel", title = glue("unmatched_tutee_students_{str_replace_all(as.character(now()), ' |:', '_')}")),
                                        list(extend = "pdf", title = glue("unmatched_tutee_students_{str_replace_all(as.character(now()), ' |:', '_')}"))
                                      ),
                                      text = "Download")
                  )
                )
  )
})  # %>% formatStyle()



