#VIEW VOLUNTEER PROFILE
observeEvent(input$view_vol_button, ignoreInit = TRUE, {
  print("OE: Clicked view_vol_button")
  
  disable(id="view_vol_button")
  disable(id="initial_match_vol_button")
  
  #Prepare inputs for viewProfile module
  indiv_info <<- make_profile_tab_info(rv$id, rv$name, rv$role)
  default_session <- getDefaultReactiveDomain()
  
  #Launch module
  viewProfileServer(id='view_vol', default_session)
  
  #PREVENT DUPLICATE TABS
  #If tab already open, view that tab with error
  #Otherwise insert/create new tab
  if ( glue("{rv$name}_tab") %in% active_tabs ) {
    
    showFeedbackWarning(inputId = "duplicate_tab",
                        text = "Tab is already open")
  }
  
  else {
    
    hideFeedback(inputId = "duplicate_tab")
    
    #Adding new tab (see module for UI structure)
    insertTab(inputId = "setpanel_matching", viewProfileUI(id="view_vol")) 
    
    #Bring new tab into focus
    updateTabsetPanel(inputId = "setpanel_matching", selected = glue("view_vol-{rv$id}_tab"))
    
    print(glue("Active tabs: {active_tabs}"))
    
    #active_tabs <- append(active_tabs, glue("{rv$id}_tab"))
    #print(active_tabs)
    
  }
  
})

#VIEW STUDENT PROFILE
observeEvent(input$view_stud_button, ignoreInit = TRUE, {
  print("OE: Clicked view_stud_button")
  
  disable(id="view_stud_button")
  disable(id="initial_match_stud_button")
  
  #Prepare inputs for viewProfile module
  indiv_info <<- make_profile_tab_info(rv$id, rv$name, rv$role)
  default_session <- getDefaultReactiveDomain()
  
  #Launch module
  viewProfileServer(id='view_stud', default_session)
  
  #PREVENT DUPLICATE TABS
  #If tab already open, view that tab with error
  #Otherwise insert/create new tab
  if ( glue("{rv$name}_tab") %in% active_tabs ) {
    
    showFeedbackWarning(inputId = "duplicate_tab",
                        text = "Tab is already open")
  }
  
  else {
    
    hideFeedback(inputId = "duplicate_tab")
    
    #Adding new tab (see module for UI structure)
    insertTab(inputId = "setpanel_matching", viewProfileUI(id="view_stud")) 
    
    #Bring new tab into focus
    updateTabsetPanel(inputId = "setpanel_matching", selected = glue("view_stud-{rv$id}_tab"))
    
    print(glue("Active tabs: {active_tabs}"))
    
    #active_tabs <- append(active_tabs, glue("{rv$id}_tab"))
    #print(active_tabs)
    
  }
  
})

