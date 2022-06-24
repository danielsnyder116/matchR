#---------------------
#  OBSERVE EVENTS
#---------------------
# When possible, all OEs used in Server.R are stored here for clarity

#Getting all modularized scripts
scripts <- list.files(path="./observe_events")

#Sourcing each script dynamically
for (script in scripts) {
  source(glue("./observe_events/{script}"), local=TRUE)
}

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
