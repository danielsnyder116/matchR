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
  VOL_TUTOR_TABLE <<- "vol_tutors"
  VOL_HIST_TABLE <<- "vols_historical"
  
  STUD_FORM_TABLE <<- "students"
  #STUD_HIST_TABLE <<- "stud_historical"
  
 
 
  
  
  #Data will be updated when specific changes are recorded
  
  
  db_data <- eventReactive(match_trigger(), {
              
              print("S-ER-1: Updating data tables")
    
              #Loading data and saving in list to access later
              #Want to ensure that all data updates at the same time
              db_data <- list( VOL_FORM = reactive({  load_data(VOL_FORM_TABLE) }),
                               VOL_TUTOR = reactive({  load_data(VOL_TUTOR_TABLE) }),
                               
                               #VOL_HIST = reactive({ load_data(VOL_HIST_TABLE) }),
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
    datatable(vol_hist(), #[, c("category", "day", "name", "email", "phone", "new_volunteer","semester",
                               #"year", "tutor_type", "class", "time", "club_name", "nickname")],
              #editable = list(target = "row"),
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
  
  unm_volunteers <- reactive({ db_data()$VOL_TUTOR() %>% filter(status == "Unmatched") })
  
  #TODO: Identify key cols to show in unmatched table
  #Number of days since signed up
  #New or returning volunteer
  output$unmatched_vols_table <- renderDT({
    datatable(unm_volunteers(), #[, c('first_name', 'last_name', 'gender','timestamp','returning_indicator' )],
              
              #editable = list(target = "row"),
              selection =  'single',
              rownames = FALSE,
              # colnames = c( 'First Name', 'Last Name', 'Email', 'Gender', 'Native Language(s)',
              #               'Other Language(s)', 'Prior Experience?', 'Teaching Certificates', 
              #               'Education Credentials', 'Timestamp', 'Proof of Vaccination', 
              #               'Returning Volunteer?', 'Previous Role', 'Students Already Tutoring', 
              #               'Reregister Acknowledgement 1', 'Reregister Acknowledgement 2', 
              #               'Desired Start Date', 'Details Regarding Multiple Dates', 'Want New Student?', 
              #               'Applied in the Past & Not Placed?', 'Had Onboard Call With Staff?', 
              #               
              #               'Preferred Role 1', 'Preferred Time 1', 'Online AM Availability 1', 
              #               'In-Person AM Availability 1', 'Online PM Availability 1', 
              #               'In-Person PM Availability 1', 'Online Citizenship Availability 1', 
              #               'Class Level Preference(s)', 'Prefer to Teach Solo? 1', 'Co-Teacher Info 1', 
              #               'Teaching Format Preference(s) 1', 'Other Class Schedule Info 1', 
              #               
              #               'Tutor Type Preference 1', 'Preferred Tutor Slot 1', 'AM Tutoring Availability 1', 
              #               'PM Tutoring Availability 1', 'Weekend Tutoring Availability 1', 
              #               'Tutor Level Preference(s) 1', 'Number of New Students 1', 
              #               'Available Before Specific Date? 1', 'Other Tutoring Schedule Info 1', 
              #               'Preferred Role 2', 'Preferred Time 2', 'Online AM Availability 2', 
              #               'In-Person AM Availability 2', 'Online PM Availability 2', 
              #               'In-Person PM Availability 2', 'Online Citizenship Availability 2', 
              #               'Class Level Preference(s) 2', 'Prefer to Teach Solo? 2', 'Co-Teacher Info 2', 
              #               'Teaching Format Preference(s) 2', 'Open to Accepting Both Choices? 1', 
              #               'Other Class Schedule Info 2', 'Tutor Type Preference 2', 'Preferred Tutor Slot 2',
              #               'AM Tutoring Availability 2', 'PM Tutoring Availability 2', 'Tutor Level Preference(s) 2',
              #               'Number of New Students 2', 'Open to Accepting Both Choices? 2', 
              #               'Available Before Specific Date? 2', 'Other Tutoring Schedule Info 2' ),
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
    datatable(unm_students(), #[, c('first_name', 'last_name', 'gender', 'native_lang', 'timestamp')],
              
              #editable = list(target = "row"),
              rownames = FALSE,
              colnames = c( "ID", "Timestamp", "Email","Tutoring Selection","English Level",
                           "Last Name","First Name","Phone Number","Address","City / State / Zip",
                           "Birthday", "Age", "Gender","Home Country","Native Language(s)",
                           "Ethnicity","Race","Employment Status (Student)","Monthly Income (Student)",
                           "Number of Dependents","Employment Status (Spouse)","Monthly Income (Spouse)",
                           "Employment Affected by Covid?","Highest Education","Request Same Tutor(s)?",
                           "Requested Tutor Name(s)","Time Slot 1","Time Slot 2","Time Slot 3",
                           "Time Slot 4","Time Slot 5","Time Slot 6","Time Slot 7","Time Slot 8",
                           "Time Slot 9","Time Slot 10","How You Heard About WEC","Role", "Status"),
              
              selection = 'single',
              options = list()
    )
  })  # %>% formatStyle()
  
  
  
 
  #================
  # IMPORT ALL OEs HERE
  source("./observe_events.R", local = TRUE)
  

}
