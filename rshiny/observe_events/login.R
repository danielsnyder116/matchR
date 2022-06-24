#CANCEL LOGIN
observeEvent(input$cancel_login_button, {
  print("OE: Cancel login button clicked")
  
  removeModal()
})