#---------------------
#      SERVER.R
#---------------------


server <- function(id, input, output) {

  #List of active tabs in unmatched section
  active_tabs <- c()
  
  #Any Reactive Values Needed
  USER <- reactiveVal()
  
  #Instantiate reactive values to maintain active individual 
  values <- reactiveValues(id = "", name = "", role = "", status = "")
  
  #Initial Popup for LOGIN
  showModal(
    modalDialog(title = "Login!", footer = NULL,

      textInput(inputId = "user_name", label = "User Name"),
      textInput(inputId = "user_password", label = "Password"),

      actionButton(inputId = "login_button", label = "Login"),
      actionButton(inputId = "cancel_login_button", label = "Cancel")
    )
  )

  
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
  
  #=============
  #  OVERVIEW
  #=============
  
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
  
  
  
  #========================
  #  UNMATCHED VOLUNTEERS 
  #========================
  
  volunteers <- reactive({ load_data("volunteers") })
  
  #TODO: Identify key cols to show in unmatched table
  #Number of days since signed up
  #New or returning volunteer
  output$unmatched_vols_table <- renderDT({
    datatable(volunteers()[, c('first_name', 'last_name', 'gender','timestamp',
                                 'returning_indicator' )],
              
              selection =  'single',
              rownames = FALSE,
              #colnames = c(),
              options = list()
    )
  })
    
  
 
  #================
  # IMPORT ALL OEs HERE
  source("./observe_events.R", local = TRUE)
  

}
