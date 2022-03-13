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
    source("./R/modules/view_profile/view_profile_functions.R", local=TRUE)
    
   
    # #Need these here to ensure they are updated accordingly after a refresh
    # observeEvent(rv$id, {
    #   print("Change in rv detected")
    #   
    #   #Qualified/Unique ids for tables
    #   profile_table_name <<- glue("profile_{rv$id}")
    #   rec_matches_table_name <<- glue("rec_matches_{rv$id}")
    # })
   
    #Qualified/Unique ids for tables
    profile_table_name <<- glue("profile_{rv$id}")
    rec_matches_table_name <<- glue("rec_matches_{rv$id}")
    
    
    #VP REACTIVE VALUES - for storing info related to student/volunteer dynamically
    #---------------------------
    #---------------------------
    tables <<- reactiveValues() #rv to hold different tables of data
    OE <<- reactiveValues() #rv to hold all observes and observeEvents to be destroyed when tab is closed
    
   
    
    #BRINGING IN ALL THE DATA
    tables[[profile_table_name]] <<- get_profile() %>% mutate(across(everything(), ~as.character(.))) %>% 
                                                      pivot_longer(!id, names_to ="field") %>% select(-id)
                                                      
    tables[[rec_matches_table_name]] <<- get_rec_matches()
    
  
    
    #output[[glue("")]] <- renderText()
    
    #PROFILE
    output[[profile_table_name]] <- DT::renderDT({
        DT::datatable(tables[[profile_table_name]][, c("field", "value")],
                  
                  selection = 'single',
                  rownames = FALSE,
                  #colnames =,
                  options = list(
                    
                    dom = "tip"
                  )
        )
    })
    
    
    #RECOMMENDED MATCHES
    output[[rec_matches_table_name]] <- DT::renderDT({
      DT::datatable(tables[[rec_matches_table_name]][, c("id", "first_name", "last_name", 
                                                         "email_address", "agg_weight", "ranking")],
                    selection = 'single',
                    rownames = FALSE,
                    colnames = c("ID", "First Name", "Last Name", "Email", "Score", "Best Fit Ranking"),
                    options = list(
                      
                      dom = "tip"
                    )
      )
    })
    
    
    
    
    
    #OBSERVERS
    #---------------------
    #---------------------
    
    OE[[glue("1_{rv$id}")]] <- observeEvent(input[[glue("{rec_matches_table_name}_rows_selected")]], ignoreInit = TRUE, {
                                  print("VP-OE-01: Recommended match row clicked")

                                  enable(id = glue("initial_match_{rec_matches_table_name}"))
      
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