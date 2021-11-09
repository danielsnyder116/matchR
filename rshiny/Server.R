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
                
      menuItem('VOLUNTEERS', tabName = 'sidebar_volunteers',
               menuSubItem('Current Semester', tabName = 'sidebar_vol_current_sem'),
               menuSubItem('Historical', tabName = 'sidebar_vol_historical'),
               menuSubItem('Intake', tabName = 'sidebar_vol_intake'),
               menuSubItem('Surveys', tabName = 'sidebar_vol_surveys')
      ),
      
      menuItem('STUDENTS', tabName = 'sidebar_students',
               menuSubItem('Current Semester', tabName = 'sidebar_stud_current_sem'),
               menuSubItem('Historical', tabName = 'sidebar_stud_historical'),
               menuSubItem('Intake', tabName = 'sidebar_stud_intake'),
               menuSubItem('Surveys', tabName = 'sidebar_stud_survey')
      ),
      

      menuItem('MATCHING', tabName = 'sidebar_matching' ,
               menuSubItem('Students', tabName = 'sidebar_match_process', newtab = TRUE)
             
              
      ),
    
      #menuItem('ATTENDANCE', tabName = 'sidebar_attendance'),
      
      menuItem('ANALYSIS', tabName = 'sidebar_analysis', icon=icon('chart-bar')
      ),
      
      menuItem('REPORTS', tabName = 'sidebar_reports', icon = icon('file-alt'),
               menuSubItem('Students', tabName = "sidebar_stud_reports"),
               menuSubItem('Volunteers', tabName = "sidebar_vol_reports")
      ),

      menuItem('EXPORT DATA', tabName = 'sidebar_export'),
      
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