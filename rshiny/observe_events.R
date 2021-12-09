#---------------------
#  OBSERVE EVENTS
#---------------------
# When possible, all OEs used in Server.R are stored here for clarity

#CANCEL LOGIN
observeEvent(input$cancel_login_button, {

  removeModal()


})

#VOLUNTEER TABLE ROW CLICKED
observeEvent(input$unmatched_vols_table_rows_selected, ignoreInit = TRUE, {
  print("Clicked on volunteer table row")
  
  #Provides the row index of the row selected/clicked
  row <- input$unmatched_vols_table_rows_selected
  
  update_reactive_values(values, volunteers(), row)
  
  enable(id = "view_vol_button")
  enable(id = "initial_match_vol_button")
  enable(id = "view_stud_button")
})




#VIEW VOLUNTEER PROFILE
observeEvent(input$view_vol_button, ignoreInit = TRUE, {
  print("Clicked view_vol_button")
  
  disable(id="view_vol_button")
  disable(id="initial_match_vol_button")
  
  indiv_info <<- make_profile_tab_info(values$name, values$role)
  
  default_session <- getDefaultReactiveDomain()
  viewProfileServer(id='view_vol', values, default_session)
  
  #PREVENT DUPLICATE TABS
  #If tab already open, view that tab with error
  #Otherwise insert/create new tab
  if ( glue("{values$name}_tab") %in% active_tabs ) {
    
    showFeedbackWarning(inputId = "duplicate_tab",
                        text = "Tab is already open")
  }
  
  else {
    
    hideFeedback(inputId = "duplicate_tab")
    
    #Adding new tab (see module for UI structure)
    insertTab(inputId = "setpanel_matching", viewProfileUI(id="view_vol", values)) 
    
    #Bring new tab into focus
    updateTabsetPanel(inputId = "setpanel_matching", selected = glue("view_vol-{values$id}_tab"))
  
    print(glue("Active tabs: {active_tabs}"))
    
    #active_tabs <- append(active_tabs, glue("{values$id}_tab"))
    #print(active_tabs)

  }
 
})







#START MANUAL MATCH
observeEvent(input$initial_match_vol_button, {
  
  showModal(
    modalDialog(title = "Manual Match", footer = NULL,
    
    textInput(inputId = "select_student", 
              value="list of students!",
              label = "Select a student to pair with the volunteer")    
             ),
    
    
    actionButton(inputId = "secondary_match_button", label = "Match")
  )
  
})




#TODO: Replicate volunteer table interactions for STUDENTS



