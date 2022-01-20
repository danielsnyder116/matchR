#---------------------
#      SERVER.R
#---------------------


server <- function(id, input, output) {

  
  #REACTIVE VALUES
  #------------------------------------------
  # #List of active tabs in unmatched section
  active_tabs <- c()
  
  #Any Reactive Values Needed
  USER <- reactiveVal()
  
  #Instantiate reactive values to maintain active individual 
  values <- reactiveValues(id = "", name = "", role = "", status = "")
  
  match_trigger <- reactiveVal(0) #reactive value used to trigger updates to data when match/unmatch made
  
  
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
      menuItem('Matching', tabName = 'sidebar_matching'),
      # menuItem('ANALYSIS', tabName = 'sidebar_analysis', icon=icon('chart-bar')),
      # menuItem('REPORTS', tabName = 'sidebar_reports', icon = icon('file-alt')),
      # menuItem('EXPORT DATA', tabName = 'sidebar_export'),
      menuItem('Settings', tabName = 'sidebar_settings')
      
    ) #sidebarMenu
    
  })
  
  
  #------------------
  #      DATA
  #------------------
  
  VOL_FORM_TABLE <<- "volunteers"
  VOL_HIST_TABLE <<- "vols_historical"
  
  STUD_FORM_TABLE <<- "students"
  #STUD_HIST_TABLE <<- "stud_historical"
  
 
 
  
  
  #Data will be updated when specific changes are recorded
  
  
  db_data <- eventReactive(match_trigger(), {
              
              print("S-ER-1: Updating data tables")
    
              #Loading data and saving in list to access later
              #Want to ensure that all data updates at the same time
              db_data <- list( VOL_FORM = reactive({  load_data(VOL_FORM_TABLE) }),
                               VOL_HIST = reactive({ load_data(VOL_HIST_TABLE) }),
                               STUD_FORM = reactive({ load_data(STUD_FORM_TABLE) })#,
                               #STUD_HIST = reactive({ load_data(STUD_HIST_TABLE) })
                             )
  })
  
  
  unmatched_vol_list <<- reactive({ db_data()$VOL_FORM() %>% 
                                          filter(status == "Unmatched") %>% select(id, first_name, last_name) })
  
  unmatched_stud_list <<- reactive({ db_data()$STUD_FORM() %>% 
                                          filter(status == "Unmatched") %>% select(id, first_name, last_name) })

  

  #-----------------------------------------------------------------------------------------
  #  VOLUNTEERS
  #------------------
  
  #=============
  #  OVERVIEW
  #=============
  
  #Inputs & Calculated Reactives
  #-----------------------------
  vol_hist <- reactive({ db_data()$VOL_HIST() })
  kpi_total_vol <- reactive({  kpi_total_vol <- "100" })
  
  
  
  #Outputs
  #------------------
  output$vol_hist_table <- renderDT({
    datatable(vol_hist()[, c("category", "day", "name", "email", "phone", "new_volunteer","semester",
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
  
  unm_volunteers <- reactive({ db_data()$VOL_FORM() %>% filter(status == "Unmatched") })
  
  #TODO: Identify key cols to show in unmatched table
  #Number of days since signed up
  #New or returning volunteer
  output$unmatched_vols_table <- renderDT({
    datatable(unm_volunteers()[, c('first_name', 'last_name', 'gender','timestamp',
                                 'returning_indicator' )],
              
              selection =  'single',
              rownames = FALSE,
              #colnames = c(),
              options = list()
    )
  })
  
  
  
  
  #-----------------------------------------------------------------------------------------
  #  STUDENTS
  #------------------
    
  unm_students <- reactive({ db_data()$STUD_FORM() %>% filter(status == "Unmatched") })
  
  #stud_hist <- reactive({ db_data()$STUD_HIST })
  
  #Outputs
  #------------------
  output$unmatched_stud_table <- renderDT({
    datatable(unm_students()[, c('first_name', 'last_name', 'gender', 'native_lang', 'timestamp')],
              
              rownames = FALSE,
              #colnames = c(),
              selection = 'single',
              options = list()
    )
  })  # %>% formatStyle()
  
  
  
 
  #================
  # IMPORT ALL OEs HERE
  source("./observe_events.R", local = TRUE)
  

}
