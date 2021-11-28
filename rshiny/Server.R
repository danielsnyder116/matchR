#---------------------
#      SERVER.R
#---------------------


#Any Reactive Values Needed



server <- function(id, input, output) {

  #SIDEBAR
  
  #Dynamic Sidebar to hide certain sections from staff
  #NOTE: In UI.R, each menuSubItem needs to have its own tabItem() to ensure
  #tabName below is registered.
  output$sidebar_menu <- renderMenu({
    sidebarMenu(id = 'sidebar_tabs',
         
      menuItem("Home", icon = icon("home"), tabName = "sidebar_home"),
     
      menuItem('MATCHING', tabName = 'sidebar_matching'),
      # menuItem('ANALYSIS', tabName = 'sidebar_analysis', icon=icon('chart-bar')),
      # 
      # menuItem('REPORTS', tabName = 'sidebar_reports', icon = icon('file-alt')),
      # menuItem('EXPORT DATA', tabName = 'sidebar_export'),
      menuItem('Settings', tabName = 'sidebar_settings')
      
    ) #sidebarMenu
    
  })
  

  #-----------------------------------------------------------------------------------------
  #  VOLUNTEER 
  #------------------
  
   
  #OVERVIEW
  
  #Inputs & Calculated Reactives
  #-----------------------------
  all_vol <- reactive({ all_vol <- load_data('vols_historical') })
  
  
  kpi_total_vol <- reactive({  kpi_total_vol <- "100" })


  
  #Outputs
  #------------------
  output$all_vol_table <- renderDT({

    datatable(all_vol()[, c("category", "day", "name", "email", "phone", "new_volunteer","semester",
                               "year", "tutor_type", "class", "time", "club_name", "nickname")],

              rownames = FALSE,
              #colnames = c(),

              options = list()

    )

  })  # %>% formatStyle()



  #Total Number Volunteers
  output$total_vol_box <- renderValueBox({
    valueBox(kpi_total_vol(), subtitle = "Total Volunteers", color = "green")
  })
  
  #Compared to last semester
  #Compared to last year
    
  

}