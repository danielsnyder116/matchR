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