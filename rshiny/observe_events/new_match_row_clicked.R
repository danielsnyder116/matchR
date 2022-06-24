#NEW MATCHES TABLE ROW CLICKED
observeEvent(input$new_matches_table_rows_selected, ignoreInit = TRUE, {
  print("OE: Clicked on new match row")
  
  # #Provides the row index of the row selected/clicked
  # row <- input$new_matches_table_rows_selected
  # 
  # update_reactive_values(unm_volunteers(), row)
  
  #Determine if separate set of reactive values need to be held for matches
  #Or just use match id?
  
  enable(id = "initial_unmatch_button")
  enable(id = "view_new_match_button")
})
