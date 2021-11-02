#---------------------
#      SERVER.R
#---------------------


#Any Reactive Values Needed



server <- function(id, input, output) {
  
  
  #Dynamic Sidebar to hide certain sections from staff
  output$sidebar_menu <- renderMenu({
    sidebarMenu(id = "sidebar_tabs",
                
      menuItem("MI ONE", tabName = "item_1",
               menuSubItem("msi_one", tabName = "blah"),
               menuSubItem("msi_two", tabName = "dah")
      ),
      
      menuItem("MI TWO")
    )
    
    
    
  })
  
  
  
  
  
  
  
  
  
}