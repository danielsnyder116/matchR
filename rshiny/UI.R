#---------------------
#       UI.R
#---------------------






sidebar <- dashboardSidebar(
  
  sidebarMenuOutput("sidebar_menu")
  
)
  
  



body <- dashboardBody(
  
  
  
  tabItems(
    
    tabItem(
      tabName = 'item_1',
      
      tabsetPanel(id='one', 
                  
        tabPanel(
          title = 'First Tab',
          value = 'msi_one',
          br()
          
        ),
        
        tabPanel(
          title = 'Second Tab',
          value = 'second_tab',
          br()
        )
      )
      
       
    ) #tabItem
  ) #tabItems
  
) #dashboardBody



ui <- dashboardPage(header = dashboardHeader(title = NULL),
                    sidebar = sidebar,
                    body = body)