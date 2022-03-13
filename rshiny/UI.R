#---------------------
#       UI.R
#---------------------


header <- dashboardHeader(
  
            #Sidebar title
            #title = "Mt. WEC",
            #icon('mountain'),
          
            title = "WEC",
            
            # div(tags$img(src = "wec_title_wide.png"), style = 'background-color: white;
            #            padding: 0px 0px 10px 0px; margin: 0px;'), 
            
            titleWidth = 170,
           
            #CUSTOM HEADER TITLE
            #There is no non-hacky way of doing this - have to tweak dropdown menu html
            tags$li(class = "dropdown", div(id='center-title', icon('people-arrows', style='padding-right: 4px;'), 'MatchR')),

            dropdownMenuCustom(type = "messages", icon = icon('user'), badgeStatus = NULL),
            dropdownMenuCustom(type = "notifications", icon = icon('cog'), badgeStatus = NULL)

)



sidebar <- dashboardSidebar(width = "170px",
  
  #Dynamic sidebar menu coming from Server.R
  sidebarMenuOutput("sidebar_menu")
  
)
  
  

body <- dashboardBody(
  
  #Calls to enable shinyjs and shinyFeedback functionality
  useShinyjs(),
  useShinyFeedback(),
  
  #Adding CSS styling
  tags$head(tags$link(rel = "stylesheet", type = 'text/css', href = 'matchR_styles.css')),
  
  #Adding favicon / icon at top of webpage
  tags$head(tags$link(rel = "shortcut-icon", href = 'favicon.ico')),
  
  #----------------
  #----------------
  
  #shinyjs::hidden(
  
  tabItems(
    
    #HOME
    tabItem(
      tabName = 'sidebar_home',
      h4("Welcome to WEC's MatchR"),
      br(),
      
      tabsetPanel(id = 'setpanel_home',
      
        tabPanel(
          title = 'Overview',
          value = 'home_overview_tab',
          br(),
          
          fluidRow(
            valueBoxOutput(outputId = "over_num_unmatched_studs", width = 2) %>% withSpinner(),
            #valueBoxOutput(outputId = "over_num_matched_studs", width = 2) %>% withSpinner(),
            valueBoxOutput(outputId = "over_num_unmatched_vols", width = 2) %>% withSpinner(),
            #valueBoxOutput(outputId = "over_num_matched_vols", width = 2) %>% withSpinner(),
            #valueBoxOutput(outputId = "over_total_matches", width = 2) %>% withSpinner()
          )
          
         #br()
          
          #MORE TO COME HERE! :D 
        ),
        
        tabPanel(
          title = 'User Guide',
          value = 'home_user_guide_tab'
        ),
        
        
        tabPanel(
          title = 'Report a Bug',
          value = 'home_bug_tab'
        )
      ) #tabsetPanel
    ),
    
   

  #---------------------------------------------------------------------------------------


    #MATCHING
    #----------
    tabItem(
      tabName = 'sidebar_matching',
      h4("Matching"),
      
      tabsetPanel(id = 'setpanel_matching',
        
        
        #UNMATCHED STUDENTS
        tabPanel(
          title = 'Unmatched Students',
          value = 'unmatched_stud_tab', 
          br(),
          
          fluidRow(
            valueBoxOutput(outputId = "num_unmatched_studs", width = 2) %>% withSpinner()
          ),
          
          fluidRow(
            disabled(actionButton(class = 'standard-btn', inputId = "view_stud_button", label = "View Profile", icon=icon("folder-open", style='padding-right: 4px;'))),
            disabled(actionButton(class = 'standard-btn', inputId = "initial_manual_match_stud_button", label = "Manual Match", 
                                  icon = icon("exchange-alt", style='padding-right: 4px;')))
          ),

          br(), 
          
          div(DT::dataTableOutput(outputId = "unmatched_stud_table"), style="overflow-x:scroll; white-space:nowrap; padding:0px 20px 20px 20px;"), 
        ),
        
        #UNMATCHED VOLUNTEERS
        tabPanel(
          title = 'Unmatched Volunteers',
          value = 'unmatched_vol_tab', 
          br(),
          
          fluidRow(
            valueBoxOutput(outputId = "num_unmatched_vols", width = 2) %>% withSpinner()
          ),
          
          fluidRow(
            disabled(actionButton(class = 'standard-btn', inputId = "view_vol_button", label = "View Profile", icon=icon("folder-open", style='padding-right: 4px;'))),
            disabled(actionButton(class = 'standard-btn', inputId = "initial_manual_match_vol_button", label = "Manual Match", 
                                  icon = icon("exchange-alt", style='padding-right: 4px;')))
          ),

          br(),
          
          div(DT::dataTableOutput(outputId = "unmatched_vols_table"), style="overflow-x:scroll;white-space:nowrap; padding:0px 20px 20px 20px;")
        ),
                  
        #OVERVIEW / MATCHES
        tabPanel(
          title = 'Matches',
          value = 'matches_tab', 
          br(),
          
          
          fluidRow(
            #valueBoxOutput(outputId = "num_matched_studs", width = 2) %>% withSpinner(),
            #valueBoxOutput(outputId = "num_matched_vols", width = 2) %>% withSpinner(),
            #valueBoxOutput(outputId = "total_matches", width = 2) %>% withSpinner()
          ),
          
          disabled(actionButton(class = 'standard-btn', inputId = "initial_unmatch_button", label = "Unmatch",
                                icon = icon("unlink", style='padding-right:4px;'))),
          
          br(), br(),
          
          div(DT::dataTableOutput(outputId = "matches_table"), style="overflow-x:scroll;white-space:nowrap; padding:0px 20px 20px 20px;")
        ),
        
        
      
      ) #tabsetPanel
    ), #tabItem
    

  # #---------------------------------------------------------------------------------------
  # 
  #   #ANALYSIS
  #   #----------
  #   tabItem(
  #     tabName = 'sidebar_analysis',
  #     h3("Analysis")
  #   ), #tabItem
  # 
  # #---------------------------------------------------------------------------------------
  # 
  #   #REPORTS
  #   #----------
  #   tabItem(
  #     tabName = "sidebar_reports",
  #     h3('Reports')
  #   
  #   ), #tabItem
  # 
  # #---------------------------------------------------------------------------------------

    #SETTINGS
    tabItem(
      tabName = 'sidebar_settings'
    )


  #----------------
  #----------------

  ) #tabItems
  
  #) #shinyjs::hidden
) #dashboardBody



ui <- dashboardPage(header = header,
                    sidebar = sidebar,
                    body = body)