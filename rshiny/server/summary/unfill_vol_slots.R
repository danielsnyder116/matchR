#======================
# UNFILLED VOL SLOTS
#======================

num_unfilled_vol_slots <- reactive({  unm_volunteers() %>% summarize(n = sum(num_slots_needed)) %>% pull(n) })

#Outputs
#------------------

#NUM VOLUNTEER SLOTS UNFILLED
output$num_unfilled_vols <- renderValueBox({ 
  valueBox(num_unfilled_vol_slots(), subtitle = "Volunteers Slots to Fill", 
           color = "orange", icon = icon("th-list"))
})


#SUMMARY NUM VOLUNTEER SLOTS UNFILLED
output$summ_num_unfilled_vols <- renderValueBox({ 
  valueBox(num_unfilled_vol_slots(), subtitle = "Volunteers Slots to Fill", 
           color = "orange", icon = icon("th-list"))
})

