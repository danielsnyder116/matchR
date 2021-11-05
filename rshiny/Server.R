#---------------------
#      SERVER.R
#---------------------


#Any Reactive Values Needed



server <- function(id, input, output) {

  
  #Dynamic Sidebar to hide certain sections from staff
  output$sidebar_menu <- renderMenu({
    sidebarMenu(id = 'sidebar_tabs',
         
      menuItem("Home", icon = icon("home"), tabName = "sidebar_home"),    
                
      menuItem('VOLUNTEERS', tabName = 'sidebar_volunteers'
               # ,
               # menuSubItem('Current Semester', tabName = 'vol_current_sem_tabs'),
               # menuSubItem('Historical', tabName = 'vol_historical_tabs'),
               # menuSubItem('Intake', tabName = 'vol_intake_tabs'),
               # menuSubItem('Surveys', tabName = 'vol_survey_tabs')
      ),
      
      menuItem('STUDENTS', tabName = 'sidebar_volunteers',
               menuSubItem('Current Semester', tabName = 'vol_current_sem_tabs'),
               menuSubItem('Historical', tabName = 'vol_historical_tabs'),
               menuSubItem('Intake', tabName = 'vol_intake_tabs'),
               menuSubItem('Surveys', tabName = 'vol_survey_tabs')
      ),
      

      menuItem('MATCHING', tabName = 'sidebar_matching',
               menuSubItem('Students', tabName = 'setpanel_matching')
              
      ),
    
      #menuItem('ATTENDANCE', tabName = 'sidebar_attendance'),
      
      menuItem('ANALYSIS', icon=icon('chart-bar'), tabName = 'sidebar_analysis',
        menuSubItem('Help', tabName = 'help')       
              #
      ),
      
      menuItem('REPORTS', icon = icon('file-alt'), tabName = 'sidebar_reports',
               menuSubItem('Students', tabName = "sidebar_student_reports_tab"),
               menuSubItem('Volunteers', tabName = "sidebar_vol_reports_tab")
      ),

      menuItem('EXPORT DATA', tabName = 'sidebar_export')

    ) #sidebarMenu
    
  })
  

  #-----------------------------------------------------------------------------------------
  #  VOLUNTEER 
  #------------------
  
   
  #OVERVIEW
  
  #Inputs & Calculated Reactives
  
  all_vol <- reactive({ all_vol <- load_data('vols_historical') })
  
  
  
  # output$all_vol_table <- dataTableOutput(outputId = "all_vol_table",
  # 
  # DT::renderDT({ all_vol()[, c("category", "day", "name", "email", "phone", "new_volunteer","semester", 
  #                              "year", "tutor_type", "class", "time", "club_name", "nickname")]
  #   
  #   })  # %>% formatStyle()
  # )
  
  
  
  
  kpi_total_vol <- reactive({  kpi_total_vol <- "100" })
  
  
  
  #Outputs
  
  #Total Number Volunteers
  output$total_vol_box <- renderValueBox({
    valueBox(kpi_total_vol(), subtitle = "Total Volunteers", color = "green")
  })
  
  #Compared to last semester
  #Compared to last year
    

  

}