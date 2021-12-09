#------------------------
#   viewProfileServer.R 
#------------------------
# Module to allow user to view volunter/student profile and take actions specific to that individual

#https://appsilon.com/how-to-safely-remove-a-dynamic-shiny-module/
viewProfileServer <- function(id, rv_input, session_input) {
  
  moduleServer(id, function(input, output, session) {
    
    ns <- session$ns
    
    # tables <- reactiveValues()
    # 
    # values <- values_input
    
    OE <- reactiveValues()
    
    
    #Bring in all functions needed only for viewProfile
    source("./R/modules/view_profile/viewProfile_functions.R", local=TRUE)

    # #Function to get user info
    # #tables[[]] <- get_indiv_data
    # tables[[glue("data_{values$id}")]] <- get_indiv_data(values$id)
    
    
    # test$a <- observeEvent()
    # test$b <- observeEvent()
    # 
    # test$destroy()
    
    #CLOSE PROFILE TAB - remember, no ns in Server!! Only in UI
    # OE[[glue("rv_input$id_oe_1")]] <<- 
    observeEvent(input[[glue("close_tab_button_{rv_input$id}")]], {
      
                                          print("Clicked close tab button")
             
                                          #refers to setpanel outside of module so NO ns for input
                                          #as a result, also need to bring in the default session rather than module session
                                          removeTab(inputId = "setpanel_matching", target = ns(glue("{rv_input$id}_tab")),
                                                    session = session_input)
                                          
                                          print(glue("Closed {rv_input$id}_tab"))
    })
    
    #Use lapply to apply destroy function to a list of all the OEs)
    # x <- c(1:10)
    # lapply(OE, )
    # OE[[glue("rv_input$id_oe{x}")]]
    
    
  })
}