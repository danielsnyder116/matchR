#------------------------
#   viewProfileServer.R 
#------------------------
# Module to allow user to view volunter/student profile and take actions specific to that individual

#https://appsilon.com/how-to-safely-remove-a-dynamic-shiny-module/
viewProfileServer <- function(id, session_input) {
  
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    NUM_OBSERVERS <- 1
    
    #Bring in all functions needed only for viewProfile
    source("./R/modules/view_profile/view_profile_data_functions.R", local=TRUE)
    source("./R/modules/view_profile/view_profile_popup_functions.R", local=TRUE)
   
    # #Need these here to ensure they are updated accordingly after a refresh
    # observeEvent(rv$id, {
    #   print("Change in rv detected")
    #   
    #   #Qualified/Unique ids for tables
    #   contact_table_name <<- glue("profile_{rv$id}")
    #   rec_matches_table_name <<- glue("rec_matches_{rv$id}")
    # })
   
    #Qualified/Unique ids for tables
    contact_table_name <<- glue("contact_{rv$id}")
    details_table_name <<- glue("details_{rv$id}")
    dem_table_name <<- glue("dem_{rv$id}")
    
    
    rec_matches_table_name <<- glue("rec_matches_{rv$id}")
    notes_table_name <<- glue("notes_{rv$id}")
    
    
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
    
    
    tables[[notes_table_name]] <<- get_notes()
    
  
    
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
      DT::datatable(tables[[rec_matches_table_name]][, c("id", "first_name", "last_name", 
                                                         "email_address", "agg_weight", "ranking")],
                    
                    class = 'cell-border stripe',
                    selection = 'single',
                    filter = "top",
                    
                    rownames = FALSE,
                    colnames = c("ID", "First Name", "Last Name", "Email", "Score", "Best Fit Ranking"),
                    options = list(
                      #columnDefs = list(list(className = 'dt-left', targets = '_all')),
                      dom = "tip"
                    )
      )
    })
    
    
    #NOTES
    output[[notes_table_name]] <- DT::renderDT({
      DT::datatable(tables[[notes_table_name]][, c("note_category", "note_contents", "note_owner", "note_date")],
                    
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
    OE[[glue("4_{rv$id}")]] <- observeEvent(input[[glue("{rec_matches_table_name}_rows_selected")]], ignoreInit = TRUE, {
      print("VP-OE-04: Secondary match button clicked")
      
      
      
    })
    
    
    
    #CANCEL MATCH BUTTON CLICKED
    OE[[glue("5_{rv$id}")]] <- observeEvent(input[[glue("cancel_match_{rec_matches_table_name}")]], ignoreInit = TRUE, {
                                  print("VP-OE-05: Cancel match button clicked")
                                  
                                  removeModal()
    })
    
    # test$a <- observeEvent()
    # test$b <- observeEvent()
    # 
    # test$destroy()
    
    
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