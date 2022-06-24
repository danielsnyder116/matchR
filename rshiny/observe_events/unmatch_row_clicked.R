#VOLUNTEER TABLE ROW CLICKED
observeEvent(input$unmatched_vols_table_rows_selected, ignoreInit = TRUE, {
  print("OE: Clicked on volunteer row")
  
  #Provides the row index of the row selected/clicked
  row <- input$unmatched_vols_table_rows_selected
  
  update_reactive_values(unm_volunteers(), row)
  
  enable(id = "view_vol_button")
  enable(id = "initial_manual_match_vol_button")
})

#STUDENT TABLE ROW CLICKED
observeEvent(input$unmatched_stud_table_rows_selected, ignoreInit = TRUE, {
  print("OE: Clicked on student row")
  
  #Provides the row index of the row selected/clicked
  row <- input$unmatched_stud_table_rows_selected
  
  update_reactive_values(unm_students(), row)
  
  enable(id = "view_stud_button")
  enable(id = "initial_manual_match_stud_button")
})