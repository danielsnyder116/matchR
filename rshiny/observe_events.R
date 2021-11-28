#---------------------
#  OBSERVE EVENTS
#---------------------
# When possible, all OEs used in Server.R are stored here for clarity

#CANCEL LOGIN
observeEvent(input$cancel_login_button, ignoreInit = TRUE, {


  
  removeModal()


})