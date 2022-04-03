#---------------------
#  OBSERVE EVENTS
#---------------------
# When possible, all OEs used in Server.R are stored here for clarity

#CANCEL LOGIN
observeEvent(input$cancel_login_button, {
  print("OE: Cancel login button clicked")
  
  removeModal()
})

#VOLUNTEER TABLE ROW CLICKED
observeEvent(input$unmatched_vols_table_rows_selected, ignoreInit = TRUE, {
  print("OE: Clicked on volunteer row")
  
  #Provides the row index of the row selected/clicked
  row <- input$unmatched_vols_table_rows_selected
  
  update_reactive_values(unm_volunteers(), row)
  
  enable(id = "view_vol_button")
  enable(id = "initial_manual_match_vol_button")
})






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


#STUDENT TABLE ROW CLICKED
observeEvent(input$unmatched_stud_table_rows_selected, ignoreInit = TRUE, {
  print("OE: Clicked on student row")
  
  #Provides the row index of the row selected/clicked
  row <- input$unmatched_stud_table_rows_selected
  
  update_reactive_values(unm_students(), row)
  
  enable(id = "view_stud_button")
  enable(id = "initial_manual_match_stud_button")
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


# #GET CURRENT ACTIVE TAB
# observeEvent(input$setpanel_matching, {
#   
#   print(glue("OE: Current active tab is {isolate(input$setpanel_matching)}"))
#   
#   #get rv
#   
#   #set current individual
#   update_reactive_values()
# 
# })


#VOLUNTEER PROFILE TAB CLICKED
#need to make sure that when a tab is clicked on, it updates reactive values
# observeEvent(, {
#   
#   
#   
# })


#START VOL MANUAL MATCH
observeEvent(input$initial_manual_match_vol_button, {
  print("OE: Initial manual match vol button clicked")
  
  showModal(
    modalDialog(title = "Manual Match", footer = NULL,
    
      pickerInput(inputId = "select_student", label = "Select a student to pair with the volunteer",
                  choices = unmatched_stud_names(), multiple = FALSE),  
      
      actionButton(inputId = "secondary_manual_match_vol_button", label = "Match"),
      actionButton(inputId = "cancel_manual_match_vol_button", label = "Cancel")
    )
  )
  
})

#CANCEL VOL MANUAL MATCH
observeEvent(input$cancel_manual_match_vol_button, {
  print("OE: Clicked on cancel manual match volunteer button")
  
  removeModal()
})




#START STUD MANUAL MATCH
observeEvent(input$initial_manual_match_stud_button, {
  print("OE: Initial match stud button clicked")
  
  showModal(
    modalDialog(title = "Manual Match", footer = NULL,
       
      pickerInput(inputId = "select_vol", label = "Select a volunteer to pair with the student",
                  choices = unmatched_vol_names(), multiple = FALSE),  
           
      actionButton(inputId = "secondary_manual_match_stud_button", label = "Match"),
      actionButton(inputId = "cancel_manual_match_stud_button", label = "Cancel")
    )
  )
})

#CANCEL STUD MANUAL MATCH
observeEvent(input$cancel_manual_match_stud_button, {
  print("OE: Clicked on cancel manual match student button")
  
  removeModal()
})


