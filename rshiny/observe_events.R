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
  
  print("Foo")
  
  row <- input$unmatched_vols_table_rows_selected
  print(row)
  
  enable(id = "view_vol_button")
  enable(id = "view_stud_button")
})


# #STUDENT TABLE ROW CLICKED
# observeEvent(input$unmatched_stud_table_cells_selected, ignoreInit = TRUE, {
#   
#   print("Foo")
#   
#   row <- input$unmatched_vols_table_cells_selected
#   print(row)
#   
#   #enable(id = "view_vol_button")
# })

#mechanism to check all of the open tabs
#If tab is in them, send a message
#Otherwise, create a new tab
#populate it with relevant details of individual 

# #To see active tab within setpanel section (in this case, MATCHING)
# observeEvent(input$sidebar_tabs, {
#   
#   if (input$sidebar_tabs == "sidebar_matching") {
#     print(glue("Current Tab: {input$setpanel_matching}"))
#   }
#   
# })

# if (str_detect(input$setpanel, pattern = "this_tab|that_tab|another_tab")) {
# }
# 
# else {
# }

indiv_info = 

#VIEW VOLUNTEER PROFILE
observeEvent(input$view_vol_button, ignoreInit = TRUE, {
  print("Clicked view_vol_button")
  
  
  
  indiv_info <- make_profile_tab_info()
  
  insertTab(inputId = "setpanel_matching", 
            
            tabPanel(title = indiv_info,
                     
                  tabsetPanel(id="blah",
                              
                              tabPanel("ONE"),
                              tabPanel("TWO"),
                              tabPanel("THREE"),
                              tabPanel("FOUR"),
                  )   
                     
                     
                     )
  )
  
  viewProfileServer(id='viewVolProfile')
  
})


#VIEW STUDENT PROFILE
observeEvent(input$view_stud_button, ignoreInit = TRUE, {
  print("Clicked view_stud_button")
  
  indiv_info <- make_profile_tab_info()
  
  insertTab(inputId = "setpanel_matching", 
            
            tabPanel(title = indiv_info,
                     
                     tabsetPanel(id="blah",
                                 
                                 tabPanel("ONE"),
                                 tabPanel("TWO"),
                                 tabPanel("THREE"),
                                 tabPanel("FOUR"),
                     )   
                     
                     
            )
  )
  
  
  viewProfileServer(id='viewStudProfile')
})



