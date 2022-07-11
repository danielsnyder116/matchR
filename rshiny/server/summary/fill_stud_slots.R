#======================
# FILLED STUDENT SLOTS
#======================

filled_studs <- reactive({ db_data()$STUD_FORM() %>% filter(num_slots_needed == 1) })
num_filled_stud_slots <- reactive({ nrow(filled_studs()) })


#FILLED STUDENT SLOTS
output$num_filled_studs <- renderValueBox({ 
  valueBox(value = num_filled_stud_slots(), subtitle = "Filled Student Slots", 
           color = "green", icon = icon("th-list"))  
})

#SUMMARY NUM FILLED STUDENT SLOTS
output$summ_num_filled_studs <- renderValueBox({ 
  valueBox(value = num_filled_stud_slots(), subtitle = "Filled Student Slots", 
           color = "green", icon = icon("th-list"))  
})
