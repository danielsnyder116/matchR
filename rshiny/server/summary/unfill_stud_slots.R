#======================
# UNFILLED STUD SLOTS
#======================

num_unfilled_stud_slots <- reactive({ unm_students() %>% summarize(n = sum(num_slots_needed)) %>% pull(n) })

#NUM UNMATCHED STUDENT SLOTS TO FILL
output$num_unfilled_studs <- renderValueBox({ 
  valueBox(value = num_unfilled_stud_slots(), subtitle = "Student Slots to Fill", 
           color = "orange", icon = icon("th-list"))  
})

#SUMMARY NUM UNFILLED STUDENT SLOTS
output$summ_num_unfilled_studs <- renderValueBox({ 
  valueBox(value = num_unfilled_stud_slots(), subtitle = "Student Slots to Fill", 
           color = "orange", icon = icon("th-list"))  
})
