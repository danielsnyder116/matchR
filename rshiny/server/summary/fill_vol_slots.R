#========================
# FILLED VOLUNTEER SLOTS
#========================

filled_vols <- reactive({ db_data()$VOL_TUTOR() %>% filter(num_slots_needed == 1) })
num_filled_vol_slots <- reactive({ nrow(filled_vols()) })


#NUM FILLED VOL SLOTS
output$num_filled_vols <- renderValueBox({
  valueBox(num_filled_vol_slots(), subtitle = "Filled Volunteer Slots", 
           color = "green", icon = icon("th-list"))
})


#SUMMARY NUM FILLED VOL SLOTS
output$summ_num_filled_vols <- renderValueBox({
  valueBox(num_filled_vol_slots(), subtitle = "Filled Volunteer Slots", 
           color = "green", icon = icon("th-list"))
})
