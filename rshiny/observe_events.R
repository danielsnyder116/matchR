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

#SECONDARY VOL MANUAL MATCH
observeEvent(input$secondary_manual_match_vol_button, {
  print("OE: Secondary manual match vol button clicked")
  
  show_toast(title = "Creating new match...", type = "success", timer = 6000, position = "center")
  
  
  #--------------------------------------
  # STEP 1: Determine New Match or Rematch 
  #         and gather row data
  #--------------------------------------

  indicator <- unm_volunteers() %>% filter(id==rv$id) %>% pull(reserved_student_names)
  
  print(indicator)
  
  stud_first_name <- str_split(input$select_student, pattern='\\s+')[[1]][1] %>% str_squish()
  stud_last_name <- str_split(input$select_student, pattern='\\s+')[[1]][2] %>% str_squish()
  
  #--------------------------------------
  # STEP 2: Add match info to matches table
  #--------------------------------------
                                    
  
  #NEW MATCH
  if (indicator == '') {
    
    match_id <- set_match_id()
    match_type <- "New"
    status <- "Newly Assigned"
    meeting_time <- "TBD"
    num_sessions_completed <- 0
    date_first_matched <- as.character(now())
    date_most_recent_match <- as.character(now())
  }
    
  else {

    #Check to see if match has been added to matchR
    df_matches <- db_data()$MATCHES() %>% filter(vol_name==rv$name, stud_name==input$select_student)
    
    #If it has, reference the match info
    if (nrow(df_matches) != 0) {
      
      match_id <- df_matches %>% pull(match_id)
      match_type <- "Re"
      status <- "Re-matched"
      
      date_first_matched <- df_matches %>% pull(date_first_matched)
      date_most_recent_match <- as.character(now())
      meeting_time <- df_matches %>% pull(meeting_time)
      
      num_sessions_completed <- df_matches %>% pull(num_sessions_completed)
      
      #Ensuring only one value pulled
      match_id <- match_id[1]
      date_first_matched <- date_first_matched[1]
      meeting_time <- meeting_time[1]
      num_sessions_completed <- num_sessions_completed[1]
    }
    
    #If not, add it to matchR for first time
    else {
      match_id <- set_match_id()
      match_type <- "Re"
      status <- "Re-matched"
      
      date_first_matched <- "Fill In"
      date_most_recent_match <- as.character(now())
      meeting_time <- "Fill In"
      num_sessions_completed <- 9999
    }
   
  }
    
    
    #Same values for both new matches and rematches
    match_owner <- USER()
   
    vol_id <- rv$id
    vol_name <- rv$name
    vol_email <- unm_volunteers() %>% filter(id==rv$id) %>% pull(email_address)
    vol_email <- vol_email[1]
    
    df_stud <- unm_students() %>% filter(first_name==stud_first_name, last_name==stud_last_name)
    
    stud_id <- df_stud %>% pull(id)
    stud_name <- paste(stud_first_name, stud_last_name)
    stud_email <- df_stud %>% pull(email_address)
    
    #Ensuring we don't get more than one value when duplicates
    #TODO Handle duplicate student registrations!!!!!
    stud_id <- stud_id[1]
    stud_email <- stud_email[1]

   
    #Converting vector into one list with appropriate single quotes
    new_row <- glue_collapse(c(match_id, match_owner, match_type, status, vol_id, vol_name, vol_email,
                               stud_id, stud_name, stud_email, meeting_time, date_first_matched,
                               date_most_recent_match, num_sessions_completed), sep="', '")
    
    print(new_row)

    #Update backend db
    db <- dbConnect(SQLite(), DB_PATH)
    dbExecute(db, glue("INSERT INTO matches VALUES ('{new_row}');"))

 
  # #Student name
  # print(input$select_student)
  # 

  
  #--------------------------------------
  # STEP 3: Update student profile
  # (and unmatched students table)
  #--------------------------------------
  #Update backend db
  dbExecute(db, glue("UPDATE students SET num_slots_needed = num_slots_needed - 1
                          WHERE id = '{stud_id}';"))

  #--------------------------------------
  # STEP 4: Update volunteer profile
  # (and unmatched volunteers table)
  #--------------------------------------
  #Update backend db
  dbExecute(db, glue("UPDATE vol_tutors SET num_slots_needed = num_slots_needed - 1
                          WHERE id = '{rv$id}';"))
  dbDisconnect(db)


  #--------------------------------------
  #STEP 5: Update rec matches table
  # - step 3 should ensure volunteer values and availability are up-to-date
  # - rerun algorithm for everyone
  #--------------------------------------
  run_algorithm_all()
  
  #Refreshing tables
  match_trigger(match_trigger() + 1)
  
  removeModal()
  
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

#SECONDARY STUDENT MANUAL MATCH
observeEvent(input$secondary_manual_match_stud_button, {
  print("OE: Secondary manual match stud button clicked")
  
  
  show_toast(title = "Creating new match...", type = "success", timer = 6000, position = "center")
  
  
  #--------------------------------------
  # STEP 1: Determine New Match or Rematch 
  #         and gather row data
  #--------------------------------------
  
  indicator <- unm_students() %>% filter(id==rv$id) %>% pull(want_same_tutor)
  
  vol_first_name <- str_split(input$select_vol, pattern='\\s+')[[1]][1] %>% str_squish()
  vol_last_name <- str_split(input$select_vol, pattern='\\s+')[[1]][2] %>% str_squish()
  
  #--------------------------------------
  # STEP 2: Add match info to matches table
  #--------------------------------------
  
  #Since we are starting in the middle of tutoring matches already being made
  #We will check to see if match is in matches table, and if not, will treat
  #as if it were a new match with regard to generating data
  
  df_matches <- db_data()$MATCHES() %>% filter(stud_name==rv$name, vol_name==input$select_vol)
  
  
  #NEW MATCH
  if (is.null(indicator) | str_detect(indicator, 'New')) {
    
    match_id <- set_match_id()
    match_type <- "New"
    status <- "Newly Assigned"
    meeting_time <- "TBD"
    num_sessions_completed <- 0
    date_first_matched <- as.character(now())
    date_most_recent_match <- as.character(now())
  }
  
  else if (nrow(df_matches) == 0) {
    
    match_id <- set_match_id()
    match_type <- "Re"
    status <- "Re-matched"
    
    date_first_matched <- as.character(now())
    date_most_recent_match <- as.character(now())
    meeting_time <- "TBD"
    num_sessions_completed <- 0
  }
  
  else {
    
    match_id <- df_matches %>% pull(match_id)
    match_type <- "Re"
    status <- "Re-matched"
    
    date_first_matched <- df_matches %>% pull(date_first_matched)
    date_most_recent_match <- as.character(now())
    meeting_time <- df_matches %>% pull(meeting_time)
    
    num_sessions_completed <- df_matches %>% pull(num_sessions_completed)
    
    # #Ensuring only one value pulled
    # match_id <- match_id[1]
    # date_first_matched <- date_first_matched[1]
    # meeting_time <- meeting_time[1]
    # num_sessions_completed <- num_sessions_completed[1]
  }
  
  
  #Same values for both new matches and rematches
  match_owner <- USER()
  
  stud_id <- rv$id
  stud_name <- rv$name
  stud_email <- unm_students() %>% filter(id==rv$id) %>% pull(email_address)
  # stud_email <- stud_email[1]
  
  df_vol <- unm_volunteers() %>% filter(first_name==vol_first_name, last_name==vol_last_name)
  
  vol_id <- df_vol %>% pull(id)
  vol_name <- paste(vol_first_name, vol_last_name)
  vol_email <- df_vol %>% pull(email_address)
  
  #Ensuring we don't get more than one value when duplicates
  #TODO Handle duplicate student registrations!!!!!
  # vol_id <- vol_id[1]
  # vol_email <- vol_email[1]
  
  
  #Converting vector into one list with appropriate single quotes
  new_row <- glue_collapse(c(match_id, match_owner, match_type, status, vol_id, vol_name, vol_email,
                             stud_id, stud_name, stud_email, meeting_time, date_first_matched,
                             date_most_recent_match, num_sessions_completed), sep="', '")
  
  print(new_row)
  
  #Update backend db
  db <- dbConnect(SQLite(), DB_PATH)
  dbExecute(db, glue("INSERT INTO matches VALUES ('{new_row}');"))
  
  
  # #Student name
  # print(input$select_student)
  # 
  
  
  #--------------------------------------
  # STEP 3: Update student profile
  # (and unmatched students table)
  #--------------------------------------
  #Update backend db
  dbExecute(db, glue("UPDATE students SET num_slots_needed = num_slots_needed - 1
                          WHERE id = '{rv$id}';"))
  
  #--------------------------------------
  # STEP 4: Update volunteer profile
  # (and unmatched volunteers table)
  #--------------------------------------
  #Update backend db
  dbExecute(db, glue("UPDATE vol_tutors SET num_slots_needed = num_slots_needed - 1
                          WHERE id = '{vol_id}';"))
  dbDisconnect(db)
  
  
  #--------------------------------------
  #STEP 5: Update rec matches table
  # - step 3 should ensure volunteer values and availability are up-to-date
  # - rerun algorithm for everyone
  #--------------------------------------
  run_algorithm_all()
  
  #Refreshing tables
  match_trigger(match_trigger() + 1)
  
  removeModal()
  
  
  
})

#CANCEL STUD MANUAL MATCH
observeEvent(input$cancel_manual_match_stud_button, {
  print("OE: Clicked on cancel manual match student button")
  
  removeModal()
})




# #INITIAL RERUN MATCHING ALGORITHM
# observeEvent(input$overall_refresh_button, {
#   print("OE: Clicked on cancel manual match student button")
#   
#   showModal(
#     modalDialog(title = "Re-run Matching Algorithm", footer = NULL,
#                 
#                 h5("Are you sure you want to re-compute matches for all individuals?"),
#                 
#                 actionButton(inputId = "secondary_run_algo_button", label = "Rerun Algorithm"),
#                 actionButton(inputId = "cancel_run_algo_button", label = "Cancel")
#     )
#   )
# })



