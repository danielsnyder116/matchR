#------------------------
#   viewProfileServer.R 
#------------------------
# Module to allow user to view volunter/student profile and take actions specific to that individual

#https://appsilon.com/how-to-safely-remove-a-dynamic-shiny-module/
viewProfileServer <- function(id, session_input) {
  
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    NUM_OBSERVERS <- 7
    
    #Bring in all functions needed only for viewProfile
    source("./R/modules/view_profile/view_profile_data_functions.R", local=TRUE)
    source("./R/modules/view_profile/view_profile_popup_functions.R", local=TRUE)
   
    #Need these here to ensure they are updated accordingly after a refresh
    observeEvent(rv$id, {
      print("Change in rv detected")
      
      # #Qualified/Unique ids for tables
      # contact_table_name <<- glue("contact_{rv$id}")
      # details_table_name <<- glue("details_{rv$id}")
      # dem_table_name <<- glue("dem_{rv$id}")
      # 
      # rec_matches_table_name <<- glue("rec_matches_{rv$id}")
      # 
      # indiv_notes_table_name <<- glue("notes_{rv$id}")
    })
    
    #Qualified/Unique ids for tables
    contact_table_name <<- glue("contact_{rv$id}")
    details_table_name <<- glue("details_{rv$id}")
    dem_table_name <<- glue("dem_{rv$id}")
    
    rec_matches_table_name <<- glue("rec_matches_{rv$match_ids}")
    
    indiv_notes_table_name <<- glue("indiv_notes_{rv$id}")
    match_notes_table_name <<- glue("match_notes_{rv$match_ids}")
   

    #VP REACTIVE VALUES - for storing info related to student/volunteer dynamically
    #---------------------------
    #---------------------------
    tables <<- reactiveValues() #rv to hold different tables of data
    OE <<- reactiveValues() #rv to hold all observes and observeEvents to be destroyed when tab is closed
    
   
    
    #BRINGING IN ALL THE DATA
    dataframes <- get_profile()
    
    #Unpacking dfs from data and loading into separate tables
    tables[[contact_table_name]] <<- dataframes[['df_contact']]
    tables[[dem_table_name]] <<- dataframes[['df_dem']]
    tables[[details_table_name]] <<- dataframes[['df_detail']]
         
    tables[[rec_matches_table_name]] <<- get_rec_matches()
    tables[[indiv_notes_table_name]] <<- get_indiv_notes()
    
  
    
    #output[[glue("")]] <- renderText()
    
    #CONTACT INFO
    output[[contact_table_name]] <- DT::renderDT({
        DT::datatable(tables[[contact_table_name]], #[, c("field", "value")],
                  
                  class = 'cell-border stripe',
                  selection = 'single',
                  
                  rownames = FALSE,
                  #colnames =,
                  options = list(
                    #columnDefs = list(list(className = 'dt-left', targets = '_all')),
                    dom = ""
                  )
        )
    })
    
    
    #DEMOGRAPHIC INFO
    output[[dem_table_name]] <- DT::renderDT({
      DT::datatable(tables[[dem_table_name]], #[, c("field", "value")],
                    
                    class = 'cell-border stripe',
                    selection = 'single',
                    
                    rownames = FALSE,
                    #colnames =,
                    options = list(
                      #columnDefs = list(list(className = 'dt-left', targets = '_all')),
                      dom = "tip"
                    )
      )
    })

    
    #DETAILS
    output[[details_table_name]] <- DT::renderDT({
      DT::datatable(tables[[details_table_name]], #[, c("field", "value")],
                    
                    class = 'cell-border stripe',
                    selection = 'single',
                    
                    rownames = FALSE,
                    #colnames =,
                    options = list(
                      #columnDefs = list(list(className = 'dt-left', targets = '_all')),
                      dom = "tip"
                    )
      )
    })
    

    
    #RECOMMENDED MATCHES
    output[[rec_matches_table_name]] <- DT::renderDT({
      DT::datatable(tables[[rec_matches_table_name]][, c("id", "agg_weight", "ranking",
                                                         "first_name", "last_name", "email_address", 
                                                         
                                                         #INPUT AND CORRESPONDING SCORE
                                                         #-----------------------------
                                                         
                                                         #Open Slots
                                                         "num_tutees", "vol_num_tutees_avail", 
                                                         
                                                         #Availability
                                                         "desired_start_date", "avail_before_date_indicator", "vol_start_date_avail",
                                                         
                                                         #Languages,
                                                         "native_langs", "same_native_lang",
                                                         "other_lang_1", "same_lang_1", "same_lang_level_1",
                                                         "other_lang_2", "same_lang_2", "same_lang_level_2", 
                                                         "other_lang_3", "same_lang_3", "same_lang_level_3", 
                                                         "other_lang_4", "same_lang_4", "same_lang_level_4",
                                                         "other_lang_5", "same_lang_5", "same_lang_level_5",
                                                         
                                                         #Waiting
                                                         "timestamp", "vol_wait_time", 
                                                         "tutor_level_prefs", "same_eng_level_pref"
                                                         
                                                         )],
                    
                    class = 'cell-border stripe',
                    selection = 'single',
                    filter = "top",
                    
                    rownames = FALSE,
                    #colnames = c("ID", "First Name", "Last Name", "Email", "Score", "Best Fit Ranking"),
                    options = list(
                      #columnDefs = list(list(className = 'dt-left', targets = '_all')),
                      dom = "tip"
                    )
      )
    })
    
    
    #NOTES
    output[[indiv_notes_table_name]] <- DT::renderDT({
      DT::datatable(tables[[indiv_notes_table_name]][, c("note_category", "note_contents", "note_owner", "note_date")],
                    
                    class = 'cell-border stripe',
                    selection = 'single',
                    
                    rownames = FALSE,
                    colnames = c("Category", "Content", "Made By", "Date Made"),
                    options = list(
                      #columnDefs = list(list(className = 'dt-left', targets = '_all')),
                      dom = "tip"
                    )
      )
    })
    
    
    
    
    #OBSERVERS
    #---------------------
    #---------------------
    
    
    
    #REC MATCH ROW CLICKED
    OE[[glue("1_{rv$id}")]] <- observeEvent(input[[glue("{rec_matches_table_name}_rows_selected")]], ignoreInit = TRUE, {
                                  print("VP-OE-01: Recommended match row clicked")

                                  enable(id = glue("initial_match_{rec_matches_table_name}"))
    })
    
    
    OE[[glue("2_{rv$id}")]] <- observeEvent(input[[glue("initial_match_{rec_matches_table_name}")]], ignoreInit = TRUE, {
      print("VP-OE-02: Initial match button clicked")
      
      show_match_popup(session)
      
    })
    
    
    # #VALIDATE
    # OE[[glue("3_{rv$id}")]] <- observeEvent(input[[glue("{rec_matches_table_name}_rows_selected")]], ignoreInit = TRUE, {
    #   print("VP-OE-0: Recommended match row clicked")
    #   
    # })
    
    
    
    #SECONDARY MATCH BUTTON CLICKED
    OE[[glue("3_{rv$id}")]] <- observeEvent(input[[glue("secondary_match_{rec_matches_table_name}")]], ignoreInit = TRUE, {
      print("VP-OE-04: Secondary match button clicked")
      
      #--------------------------------------
      # STEP 1: Add new match to matches table
      #--------------------------------------
      
      #Get row index
      row <- input[[glue("{rec_matches_table_name}_rows_selected")]]

      #Fill out matches row
      match_id <- set_match_id()
      match_owner <- USER()
      match_type <- "New"
     
      status <- "blah"
      vol_id <- tables[[rec_matches_table_name]][row, ]$id
      vol_name <- paste(tables[[rec_matches_table_name]][row, ]$first_name, tables[[rec_matches_table_name]][row, ]$last_name)
      vol_email <- tables[[rec_matches_table_name]][row, ]$email_address
      
      stud_id <- tables[[rec_matches_table_name]][row, ]$student_id
      stud_name <- paste(tables[[rec_matches_table_name]][row, ]$first_name.x, tables[[rec_matches_table_name]][row, ]$last_name.x)
      stud_email <- ""
      
      meeting_time <- ""
      date_matched <- as.character(now())
      num_sessions_completed <- 0
      
      #Converting vector into one list with appropriate single quotes
      new_row <- glue_collapse(c(match_id, match_owner, match_type, status, vol_id, vol_name, vol_email, 
                                 stud_id, stud_name, stud_email, meeting_time, date_matched, 
                                 num_sessions_completed), sep="', '")

      #Update backend db
      db <- dbConnect(SQLite(), DB_PATH)
      dbExecute(db, glue("INSERT INTO matches VALUES ('{new_row}');"))
      
      
      
      #--------------------------------------
      # STEP 2: Update student profile 
      # (and unmatched students table)
      #--------------------------------------
      #Update backend db
      dbExecute(db, glue("UPDATE students SET num_slots_needed = num_slots_needed - 1
                          WHERE id = '{tables[[rec_matches_table_name]][row, ]$student_id}';"))
      
      #--------------------------------------
      # STEP 3: Update volunteer profile 
      # (and unmatched volunteers table)
      #--------------------------------------
      #Update backend db
      dbExecute(db, glue("UPDATE vol_tutors SET num_slots_needed = num_slots_needed - 1
                          WHERE id = '{tables[[rec_matches_table_name]][row, ]$id}';"))
      dbDisconnect(db)

      
      #--------------------------------------
      #STEP 4: Update rec matches table
      # - step 3 should ensure volunteer values and availability are up-to-date
      # - rerun algorithm 
      #--------------------------------------
      run_rec_algorithm()
      
      tables[[rec_matches_table_name]] <<- get_rec_matches()

      
      #--------------------------------------
      # STEP 5: Refresh tables and close modal
      #--------------------------------------
      match_trigger()
      
      removeModal()
    })
    
    
    
    #CANCEL MATCH BUTTON CLICKED
    OE[[glue("4_{rv$id}")]] <- observeEvent(input[[glue("cancel_match_{rec_matches_table_name}")]], ignoreInit = TRUE, {
                                  print("VP-OE-05: Cancel match button clicked")
                                  
                                  removeModal()
    })
    

    #RE-RUN ALGORITM BUTTON CLICKED
    OE[[glue("5_{rv$id}")]] <- observeEvent(input[[glue("initial_run_algo_{rec_matches_table_name}")]], ignoreInit = TRUE, {
      print("VP-OE-05: Initial re-run algorithm button clicked")
      
      show_run_algo_popup(session)
      
    })
    
    
    # #VALIDATE
    # OE[[glue("7_{rv$id}")]] <- observeEvent(input[[glue("{rec_matches_table_name}_rows_selected")]], ignoreInit = TRUE, {
    #   print("VP-OE-0: Recommended match row clicked")
    #   
    # })
    
    
    
    #SECONDARY RE-RUN ALGORITHM BUTTON CLICKED
    OE[[glue("6_{rv$id}")]] <- observeEvent(input[[glue("secondary_run_algo_{rec_matches_table_name}")]], ignoreInit = TRUE, {
      print("VP-OE-08: Secondary rerun algorithm button clicked")
      
      run_rec_algorithm()
      
      tables[[rec_matches_table_name]] <<- get_rec_matches()

      removeModal()
    })
    
    
    #CANCEL RERUN ALGORITHM BUTTON CLICKED
    OE[[glue("7_{rv$id}")]] <- observeEvent(input[[glue("cancel_run_algo_{rec_matches_table_name}")]], ignoreInit = TRUE, {
      print("VP-OE-07: Cancel rerun algorithm button clicked")
      
      removeModal()
    })
    
    
    
    

    
    
    
    
    #CLOSE PROFILE TAB
    observeEvent(input[[glue("close_tab_button_{rv$id}")]], ignoreInit = TRUE, {
      
                                          print("Clicked close tab button")
             
                                          #refers to setpanel outside of module so NO ns for input
                                          #as a result, also need to bring in the default session rather than module session
                                          removeTab(inputId = "setpanel_matching", target = ns(glue("{rv$id}_tab")),
                                                    session = session_input)
                                          
                                          #"Destroying" all of the OEs to ensure proper functioning
                                          #OE[[glue("{rv$id}_oe_1")]] <- 
                                          #OE[[glue("{rv$id}_oe_1")]]$destroy()
                                          
                                          #Use lapply to apply destroy function to a list of all the OEs)
                                          # x <- c(1:NUM_OBSERVERS)
                                          # lapply(OE, )
                                          # OE[[glue("rv$id_oe{x}")]]
                                          
                                          print(glue("Closed {rv$id}_tab"))
    })
    
  
    
    
   
    
    
  })
}