#---------------------
#      SERVER.R
#---------------------


server <- function(id, input, output) {

  
  #REACTIVE VALUES
  #------------------------------------------
  # #List of active tabs in unmatched section
  active_tabs <<- c()
  USER <<- reactiveVal(Sys.info()[['user']])
  rv <<- reactiveValues(id = "", name = "", role = "", status = "", match_ids = "") #Instantiate reactive values to maintain active individual 
  match_trigger <<- reactiveVal(0) #reactive value used to trigger updates to data when match/unmatch made
  
  
  # #Initial Popup for LOGIN
  # showModal(
  #   modalDialog(title = "Login!", footer = NULL,
  # 
  #     textInput(inputId = "user_name", label = "User Name"),
  #     textInput(inputId = "user_password", label = "Password"),
  # 
  #     actionButton(class="standard-btn", inputId = "login_button", label = "Login"),
  #     actionButton(class="standard-btn", inputId = "cancel_login_button", label = "Cancel")
  #   )
  # )

  
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
  
  #-------------------------------------------------------------------------------------------------------------------------
  
  #------------------
  #      DATA
  #------------------
  
  VOL_FORM_TABLE <<- "volunteers"
  VOL_TUTOR_TABLE <<- "vol_tutors"
  VOL_HIST_TABLE <<- "vols_historical"
  
  STUD_FORM_TABLE <<- "students"
  #STUD_HIST_TABLE <<- "stud_historical"
  MATCH_TABLE <<- "matches"
 
 
  
  
  #Data will be updated when specific changes are recorded
  # - New match made
  # - Match unmatched/undone
  # - New student(s) / volunteer(s) data added
  # - Student(s) / volunteer(s) status changes (drops out / inactive or 
      #when student makes payment and is eligible to be matched or 
      #when new volunteer has had call/interview with Yaritza/Kendall and is "cleared"
  # - When student/volunteer slots are all filled (student has all tutors and volunteer has all tutees)
  
  db_data <- eventReactive(match_trigger(), {
              
              print("S-ER-1: Updating data tables")
    
              #Loading data and saving in list to access later
              #Want to ensure that all data updates at the same time
              db_data <- list( VOL_FORM = reactive({ load_data(VOL_FORM_TABLE) }),
                               VOL_TUTOR = reactive({ load_data(VOL_TUTOR_TABLE) }),
                               #VOL_HIST = reactive({ load_data(VOL_HIST_TABLE) }),
                               
                               STUD_FORM = reactive({ load_data(STUD_FORM_TABLE) }),
                               #STUD_TUTEE = reactive({ load_data(STUD_TUTEE_TABLE) })#,
                               #STUD_HIST = reactive({ load_data(STUD_HIST_TABLE) })
                               
                               MATCHES = reactive({ load_data(MATCH_TABLE) })
                             )
  })
  
  
  unmatched_vol_names <- reactive({ db_data()$VOL_TUTOR() %>% 
                                          filter(status == "Unmatched" & !str_detect(first_name, "^$|\\s+")) %>% 
                                          arrange(first_name, last_name) %>%
                                          mutate(full_name = paste(first_name, last_name)) %>% 
                                          select(full_name)
  })
  
  unmatched_stud_names <- reactive({ db_data()$STUD_FORM() %>% 
                                          filter(status == "Unmatched" & !str_detect(first_name, "^$|\\s+")) %>% 
                                          arrange(first_name, last_name) %>%
                                          mutate(full_name = paste(first_name, last_name)) %>% 
                                          select(full_name)
  })
  
  

  #-------------------------------------------------------------------------------------------------------------------------

  
  
  #=============
  #  SUMMARY
  #=============
  
  #Inputs & Calculated Reactives
  #-----------------------------
  #vol_hist <- reactive({ db_data()$VOL_HIST() })
  kpi_current_sem_total_vol <- reactive({  kpi_total_vol <- "100" })
  
  
  
  #Outputs
  #------------------
  
  #Total Number of Volunteers for CURRENT SEMESTER
  output$total_vol_box <- renderValueBox({
    valueBox(kpi_current_sem_total_vol(), subtitle = "Total Volunteers (Current Semester)", color = "green", icon = icon("users"))
  })
  
  #Compared to last semester
  #Compared to last year
  
  #Pulled from matching section, just made outputId unique
  #--------------------------------------------------------
  
  #UNMATCHED STUDENTS
  output$summ_num_unmatched_studs <- renderValueBox({ 
    valueBox(value = num_unmatched_studs(), subtitle = "Students to Match", 
             color = "orange", icon = icon("user-times"))  
  })
  
  #MATCHED STUDENTS
  output$summ_num_matched_studs <- renderValueBox({ 
    valueBox(value = num_matched_studs(), subtitle = "Matched Students", 
             color = "green", icon = icon("user-check"))  
  })
  
  
  #UNMATCHED STUDENT SLOTS TO FILL
  output$summ_num_unfilled_studs <- renderValueBox({ 
    valueBox(value = num_unfilled_stud_slots(), subtitle = "Student Slots to Fill", 
             color = "orange", icon = icon("th-list"))  
  })
  
  #FILLED STUDENT SLOTS
  output$summ_num_filled_studs <- renderValueBox({ 
    valueBox(value = num_filled_stud_slots(), subtitle = "Filled Student Slots", 
             color = "green", icon = icon("th-list"))  
  })
  
  
  
  #UNMATCHED VOLUNTEERS
  output$summ_num_unmatched_vols <- renderValueBox({ 
    valueBox(num_unmatched_vols(), subtitle = "Volunteers to Match", 
             color = "orange", icon = icon("user-times"))
  })
  
  #MATCHED VOLUNTEERS
  output$summ_num_matched_vols <- renderValueBox({ 
    valueBox(num_matched_vols(), subtitle = "Matched Volunteers", 
             color = "green", icon = icon("user-check"))
  })
  
  
  
  #VOLUNTEER SLOTS UNFILLED
  output$summ_num_unfilled_vols <- renderValueBox({ 
    valueBox(num_unfilled_vol_slots(), subtitle = "Volunteers Slots to Fill", 
             color = "orange", icon = icon("th-list"))
  })
  
  #FILLED VOL SLOTS
  output$summ_num_filled_vols <- renderValueBox({
    valueBox(num_filled_vol_slots(), subtitle = "Filled Volunteer Slots", 
             color = "green", icon = icon("th-list"))
  })
  
  
  
  
  

 
  #-------------------------------------------------------------------------------------------------------------------------
  
  #====================
  # UNMATCHED STUDENTS
  #====================
  
  unm_students <- reactive({ db_data()$STUD_FORM() %>% filter(status == "Unmatched" & num_slots_needed != 0) })
  
  num_unmatched_studs <- reactive({ nrow(unm_students()) })
  num_unfilled_stud_slots <- reactive({ unm_students() %>% summarize(n = sum(num_slots_needed)) %>% pull(n) })
  
  #NUM UNMATCHED STUDENTS
  output$num_unmatched_studs <- renderValueBox({ 
    valueBox(value = num_unmatched_studs(), subtitle = "Students to Match", 
             color = "orange", icon = icon("user-times"))  
  })
  
  #NUM UNMATCHED STUDENT SLOTS TO FILL
  output$num_unfilled_studs <- renderValueBox({ 
    valueBox(value = num_unfilled_stud_slots(), subtitle = "Student Slots to Fill", 
             color = "orange", icon = icon("th-list"))  
  })
  
  #stud_hist <- reactive({ db_data()$STUD_HIST })
  
  #Outputs
  #------------------
  output$unmatched_stud_table <- DT::renderDT({
    DT::datatable(unm_students()[, c('first_name', 'last_name', 'num_slots_needed', 'timestamp', 'native_lang', 
                                     'want_same_tutor', 'tutor_name', 'made_payment')],
                  
                  class = 'cell-border stripe',
                  #editable = list(target = "row", disable = list(columns = c(2, 3))),
                  filter = "top",
                  extensions = "Buttons",
                  
                  rownames = FALSE,
                  colnames = c("First Name", "Last Name", "Number Slots to Fill", "Date Registered", "Native Language", 
                               "Need New Tutor?", 'Reserved Tutor(s)', "Paid?"),
                  
                  selection = 'single',
                  options = list(
                    columnDefs = list(list(className = 'dt-left', targets = '_all')),
                    dom = "Btip",
                    buttons = list("copy", 
                                   list(extend = "collection", 
                                        buttons = list(
                                          list(extend = "csv", title = glue("unmatched_tutee_students_{str_replace_all(as.character(now()), ' |:', '_')}")),
                                          list(extend = "excel", title = glue("unmatched_tutee_students_{str_replace_all(as.character(now()), ' |:', '_')}")),
                                          list(extend = "pdf", title = glue("unmatched_tutee_students_{str_replace_all(as.character(now()), ' |:', '_')}"))
                                        ),
                                        text = "Download")
                    )
                  )
    )
  })  # %>% formatStyle()
  
  
  
  
  #-------------------------------------------------------------------------------------------------------------------------
  
  #========================
  #  UNMATCHED VOLUNTEERS 
  #========================
  
  unm_volunteers <- reactive({ db_data()$VOL_TUTOR() %>% filter(status == "Unmatched" & num_slots_needed != 0) })
  
  num_unmatched_vols <- reactive ({ nrow(unm_volunteers()) })
  num_unfilled_vol_slots <- reactive({  unm_volunteers() %>% summarize(n = sum(num_slots_needed)) %>% pull(n) })

  #NUM VOLUNTEERS UNMATCHED
  output$num_unmatched_vols <- renderValueBox({ 
    valueBox(num_unmatched_vols(), subtitle = "Volunteers to Match", 
             color = "orange", icon = icon("user-times"))
  })
  
  #NUM VOLUNTEER SLOTS UNFILLED
  output$num_unfilled_vols <- renderValueBox({ 
    valueBox(num_unfilled_vol_slots(), subtitle = "Volunteers Slots to Fill", 
             color = "orange", icon = icon("th-list"))
  })
  

  
  #TODO: Identify key cols to show in unmatched table
  #Number of days since signed up
  #New or returning volunteer
  output$unmatched_vols_table <- DT::renderDT({
    DT::datatable(unm_volunteers()[, c('first_name', 'last_name', 'num_slots_needed', 'timestamp','returning_indicator',
                                       'reserved_student_names', 'want_additional_student_indicator')],
              
              #editable = list(target = "row", disable = list(columns = c(2, 3))),
              class = 'cell-border stripe', 
              filter = "top",
              selection =  'single',
              extensions = 'Buttons',
              
              rownames = FALSE,
              colnames = c( 'First Name', 'Last Name', 'Number Slots to Fill', 'Date Registered', 'Returning?',
                            'Reserved Students', 'Want Additional New Student?'),
              
              options = list(
                
                columnDefs = list(list(className = 'dt-left', targets = '_all')),
                dom = "Btip",
                buttons = list("copy", 
                            list(extend = "collection", 
                              buttons = list(
                                          list(extend = "csv", title = glue("unmatched_tutor_volunteers_{str_replace_all(as.character(now()), ' |:', '_')}")),
                                          list(extend = "excel", title = glue("unmatched_tutor_volunteers_{str_replace_all(as.character(now()), ' |:', '_')}")),
                                          list(extend = "pdf", title = glue("unmatched_tutor_volunteers_{str_replace_all(as.character(now()), ' |:', '_')}"))
                                          ),
                    text = "Download")
                )
              )
    )
  })
  
  

  #-------------------------------------------------------------------------------------------------------------------------
  
  #======================
  # MATCHES (CONFIRMED)
  #======================
  
  
  new_matches <- reactive({ db_data()$MATCHES() %>% filter(match_type == "New") })
  re_matches <- reactive({ db_data()$MATCHES() %>% filter(match_type == "Re") })
  
  
  output$new_matches_table <- DT::renderDT({
    DT::datatable(new_matches(), #[, c('first_name', 'last_name', 'gender', 'native_lang', 'timestamp',
                                     #'want_same_tutor')],
                  
                  class = 'cell-border stripe',
                  #editable = list(target = "row", disable = list(columns = )),
                  filter = "top",
                  extensions = "Buttons",
                  
                  rownames = FALSE,
                  #colnames = c("First Name", "Last Name", "Gender", "Native Language", "Date Registered", "Need New Tutor?"),
                  
                  selection = 'single',
                  options = list(
                    columnDefs = list(list(className = 'dt-left', targets = '_all')),
                    dom = "Btip",
                    buttons = list("copy", 
                                   list(extend = "collection", 
                                        buttons = list(
                                          list(extend = "csv", title = glue("tutoring_new_matches_{str_replace_all(as.character(now()), ' |:', '_')}")),
                                          list(extend = "excel", title = glue("tutoring_new_matches_{str_replace_all(as.character(now()), ' |:', '_')}")),
                                          list(extend = "pdf", title = glue("tutoring_new_matches_{str_replace_all(as.character(now()), ' |:', '_')}"))
                                        ),
                                        text = "Download")
                    )
                  )
    )
  })  # %>% formatStyle()
  
  
  output$re_matches_table <- DT::renderDT({
    DT::datatable(re_matches(), #[, c('first_name', 'last_name', 'gender', 'native_lang', 'timestamp',
                  #'want_same_tutor')],
                  
                  class = 'cell-border stripe',
                  #editable = list(target = "row", disable = list(columns = )),
                  filter = "top",
                  selection = 'single',
                  extensions = "Buttons",
                  
                  rownames = FALSE,
                  #colnames = c("First Name", "Last Name", "Gender", "Native Language", "Date Registered", "Need New Tutor?"),
                  
                  options = list(
                    columnDefs = list(list(className = 'dt-left', targets = '_all')),
                    dom = "Btip",
                    buttons = list("copy", 
                                   list(extend = "collection", 
                                        buttons = list(
                                          list(extend = "csv", title = glue("tutoring_rematches_{str_replace_all(as.character(now()), ' |:', '_')}")),
                                          list(extend = "excel", title = glue("tutoring_rematches_{str_replace_all(as.character(now()), ' |:', '_')}")),
                                          list(extend = "pdf", title = glue("tutoring_rematches_{str_replace_all(as.character(now()), ' |:', '_')}"))
                                        ),
                                        text = "Download")
                    )
                  )
  )
  })  # %>% formatStyle()
  
  #-------------------------------------------------------------------------------------------------------------------------
  
  #====================
  #  MATCHED STUDENTS
  #====================
  
  matched_studs <- reactive({ db_data()$STUD_FORM() %>% filter(num_slots_needed == 0) })
  num_matched_studs <- reactive({ nrow(matched_studs()) })
  
  #NUM MATCHED STUDENTS
  output$num_matched_studs <- renderValueBox({ 
    valueBox(value = num_matched_studs(), subtitle = "Matched Students", 
             color = "green", icon = icon("user-check"))  
  })
  
  
  filled_studs <- reactive({ db_data()$STUD_FORM() %>% filter(num_slots_needed == 1) })
  num_filled_stud_slots <- reactive({ nrow(filled_studs()) })
  
  
  #FILLED STUDENT SLOTS
  output$num_filled_studs <- renderValueBox({ 
    valueBox(value = num_filled_stud_slots(), subtitle = "Filled Student Slots", 
             color = "green", icon = icon("th-list"))  
  })
  
  
  
  
  #stud_hist <- reactive({ db_data()$STUD_HIST })
  
  #Outputs
  #------------------
  output$matched_studs_table <- DT::renderDT({
    DT::datatable(matched_studs()[, c('first_name', 'last_name')],
                  
                  class = 'cell-border stripe',
                  #editable = list(target = "row", disable = list(columns = c(2, 3))),
                  filter = "top",
                  extensions = "Buttons",
                  
                  rownames = FALSE,
                  colnames = c("First Name", "Last Name"),
                  
                  selection = 'single',
                  options = list(
                    columnDefs = list(list(className = 'dt-left', targets = '_all')),
                    dom = "Btip",
                    buttons = list("copy", 
                                   list(extend = "collection", 
                                        buttons = list(
                                          list(extend = "csv", title = glue("matched_tutee_students_{str_replace_all(as.character(now()), ' |:', '_')}")),
                                          list(extend = "excel", title = glue("matched_tutee_students_{str_replace_all(as.character(now()), ' |:', '_')}")),
                                          list(extend = "pdf", title = glue("matched_tutee_students_{str_replace_all(as.character(now()), ' |:', '_')}"))
                                        ),
                                        text = "Download")
                    )
                  )
    )
  })  # %>% formatStyle()
  
  
  
  #-------------------------------------------------------------------------------------------------------------------------
  
  #========================
  #  MATCHED VOLUNTEERS 
  #========================
  
  matched_vols <- reactive({ db_data()$VOL_TUTOR() %>% filter(num_slots_needed == 0) })
  num_matched_vols <- reactive ({ nrow(matched_vols()) })
  
  #NUM MATCHED VOLUNTEERS
  output$num_matched_vols <- renderValueBox({ 
    valueBox(num_matched_vols(), subtitle = "Matched Volunteers", 
             color = "green", icon = icon("user-check"))
  })
  
  
  filled_vols <- reactive({ db_data()$VOL_TUTOR() %>% filter(num_slots_needed == 1) })
  num_filled_vol_slots <- reactive({ nrow(filled_vols()) })
  
  
  #NUM MATCHED VOL SLOTS
  output$num_filled_vols <- renderValueBox({
    valueBox(num_filled_vol_slots(), subtitle = "Filled Volunteer Slots", 
             color = "green", icon = icon("th-list"))
  })
  
  
  
  #TODO: Identify key cols to show in unmatched table
  #Number of days since signed up
  #New or returning volunteer
  output$matched_vols_table <- DT::renderDT({
    DT::datatable(matched_vols()[, c('first_name', 'last_name', 'returning_indicator')],
                  
                  #editable = list(target = "row", disable = list(columns = c(2, 3))),
                  class = 'cell-border stripe', 
                  filter = "top",
                  selection =  'single',
                  extensions = "Buttons",
                  
                  rownames = FALSE,
                  colnames = c( 'First Name', 'Last Name', 'Returning?'),
                  options = list(
                    
                    columnDefs = list(list(className = 'dt-left', targets = '_all')),
                    dom = "Btip",
                    buttons = list("copy", 
                                   list(extend = "collection", 
                                        buttons = list(
                                          list(extend = "csv", title = glue("matched_tutor_volunteers_{str_replace_all(as.character(now()), ' |:', '_')}")),
                                          list(extend = "excel", title = glue("matched_tutor_volunteers_{str_replace_all(as.character(now()), ' |:', '_')}")),
                                          list(extend = "pdf", title = glue("matched_tutor_volunteers_{str_replace_all(as.character(now()), ' |:', '_')}"))
                                        ),
                                        text = "Download")
                    )
                  )
    )
  })
  
  
  #-------------------------------------------------------------------------------------------------------------------------
  
 
  #================
  # IMPORT ALL OEs HERE
  source("./observe_events.R", local = TRUE)
  

}
