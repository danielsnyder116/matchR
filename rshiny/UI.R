#---------------------
#       UI.R
#---------------------


header <- dashboardHeader(
  
            #Sidebar title
            #title = "Mt. WEC",
            #icon('mountain'),
          
            title = div(tags$img(src = "wec_title_wide.png"), style = 'background-color: white;
                       padding: 0px 0px 10px 0px; margin: 0px;'), 
                    
           
            #CUSTOM HEADER TITLE
            #There is no non-hacky way of doing this - have to tweak dropdown menu html
            tags$li(class = "dropdown", div(id='center-title', icon('people-arrows'), 'MatchR')),

            dropdownMenuCustom(type = "messages", icon = icon('user'), badgeStatus = NULL),
            dropdownMenuCustom(type = "notifications", icon = icon('cog'), badgeStatus = NULL)

)



sidebar <- dashboardSidebar(
  
  #Dynmic sidebar menu coming from Server.R
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
          br()
        ),
        
        tabPanel(
          title = 'User Guide',
          value = 'home_user_guide_tab'
        ),
        
        tabPanel(
          title = 'Troubleshooting',
          value = 'home_troubleshooting_tab'
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
      h3("Matching"),
      br(),
      
      tabsetPanel(id = 'setpanel_matching',
        
        #OVERVIEW / MATCHES
        tabPanel(
          title = 'Matches',
          value = 'matches_tab', 
        ),
        
        #UNMATCHED
        tabPanel(
          title = 'Unmatched',
          value = 'unmatched_tab', 
        )
      
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
) #dashboardBody



ui <- dashboardPage(header = header,
                    sidebar = sidebar,
                    body = body)