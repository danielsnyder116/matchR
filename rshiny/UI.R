#---------------------
#       UI.R
#---------------------


header <- dashboardHeader(title = "Volman",

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
  tags$head(tags$link(rel = "stylesheet", type = 'text/css', href = 'volman_styles.css')),
  
  #----------------
  #----------------
  
  tabItems(
    
    #VOLUNTEERS
    #----------

    #No content for just clicking on sidebar_volunteers
    
    #CURRENT SEMESTER
    tabItem(
      tabName = 'sidebar_vol_current_sem',
      h3('Current Semester'),
      
      tabsetPanel(id = 'setpanel_vol_current_sem',
                  
        #OVERVIEW          
        tabPanel(
          title = 'Overview',
          value='vol_overview_tab',
          br(),
          
          valueBoxOutput(outputId = "total_vol_box"),
          DTOutput(outputId = "all_vol_table")
        ),
        
        #IN-PERSON TEACHERS
        tabPanel(
          title = 'In-Person Teachers',
          value='vol_in-person_tab',
          br(),
          p("Data Table of Volunteers")
        ),
        
        #ONLINE TEACHERS
        tabPanel(
          title = 'Online Teachers',
          value='vol_online_tab',
          br(), br(),
          p("Data Table of Volunteers")
        ),
        
        
        #TUTORS
        tabPanel(
          title = 'Tutors',
          value='vol_tutors_tab',
          br(), br(),
          p("Data Table of Volunteers")
        ),
        
        
        #CLUB LEADERS
        tabPanel(
          title = 'Club Leaders',
          value='vol_club_leaders_tab',
          br(), br(),
          p("Data Table of Volunteers")
        ),
        
        #OTHER
        tabPanel(
          title = 'Other',
          value='vol_other_tabs',
          br(), br(),
          p("Data Table of Volunteers")
        )
        
      ) #tabsetPanel
    ), #tabItem
    
    #HISTORICAL
    tabItem(
      tabName = 'sidebar_vol_historical',
      h3('Historical'),
      
      tabsetPanel(id = 'setpanel_vol_historical',
        
        #OVERVIEW          
        tabPanel(
          title = 'Overview',
          value='vol_overview_tab',
          br(),
          
          # valueBoxOutput(outputId = "total_vol_box"),
          # DTOutput(outputId = "all_vol_table")
        )
       
                  
      ) #tabsetPanel
    ), #tabItem
    
    
    
    #INTAKE
    tabItem(
      tabName = 'sidebar_vol_intake',
      h3('INTAKE'),
      
      tabsetPanel(id = 'setpanel_vol_intake',
                  
                  #OVERVIEW          
                  tabPanel(
                    title = 'Overview',
                    value='vol_overview_tab',
                    br(),
                    
                    # valueBoxOutput(outputId = "total_vol_box"),
                    # DTOutput(outputId = "all_vol_table")
                  )
                  
                  
      ) #tabsetPanel
    ), #tabItem
    
    
    #SURVEYS
    tabItem(
      tabName = 'sidebar_vol_surveys',
      h3('Surveys'),
      
      tabsetPanel(id = 'setpanel_vol_surveys',
                  
                  #OVERVIEW          
                  tabPanel(
                    title = 'Overview',
                    value='vol_overview_tab',
                    br(),
                    
                    # valueBoxOutput(outputId = "total_vol_box"),
                    # DTOutput(outputId = "all_vol_table")
                  )
                  
                  
      ) #tabsetPanel
    ), #tabItem
    
#---------------------------------------------------------------------------------------
    
    #STUDENTS
    #----------
    
    #CURRENT SEMESTER
    tabItem(
      tabName = 'sidebar_stud_current_sem',
      h3('Current Semester'),
      
      tabsetPanel(id = 'setpanel_stud_current_sem',
        
        #OVERVIEW          
        tabPanel(
          title = 'Overview',
          value='stud_overview_tab',
          br()#,
          
          # valueBoxOutput(outputId = "total_stud_box"),
          # DTOutput(outputId = "all_stud_table")
        ),
        
        #IN-PERSON STUDENT
        tabPanel(
          title = 'In-Person Students',
          value='stud_in-person_tab',
          br(),
          p("Data Table")
        ),
        
        #ONLINE CLASS STUDENTS
        tabPanel(
          title = 'Online Students',
          value='stud_online_tab',
          br(), br(),
          p("Data Table")
        ),
        
        
        #TUTORS
        tabPanel(
          title = 'Tutors',
          value='stud_tutors_tab',
          br(), br(),
          p("Data Table")
        )
                  
      ) #tabsetPanel
    ), #tabItem

    
    #HISTORICAL
    tabItem(
      tabName = 'sidebar_vol_historical',
      h3('Historical'),
      
      tabsetPanel(id = 'setpanel_vol_historical',
                  
        #OVERVIEW          
        tabPanel(
          title = 'Overview',
          value='vol_overview_tab',
          br(),
          
          # valueBoxOutput(outputId = "total_vol_box"),
          # DTOutput(outputId = "all_vol_table")
        )
          
      ) #tabsetPanel
    ), #tabItem
    
    
    
    #INTAKE
    tabItem(
      tabName = 'sidebar_vol_intake',
      h3('INTAKE'),
      
      tabsetPanel(id = 'setpanel_vol_intake',
                  
                  #OVERVIEW          
                  tabPanel(
                    title = 'Overview',
                    value='vol_overview_tab',
                    br(),
                    
                    # valueBoxOutput(outputId = "total_vol_box"),
                    # DTOutput(outputId = "all_vol_table")
                  )
                  
                  
      ) #tabsetPanel
    ), #tabItem
    
    
    #SURVEYS
    tabItem(
      tabName = 'sidebar_vol_surveys',
      h3('Surveys'),
      
      tabsetPanel(id = 'setpanel_vol_surveys',
                  
                  #OVERVIEW          
                  tabPanel(
                    title = 'Overview',
                    value='vol_overview_tab',
                    br(),
                    
                    # valueBoxOutput(outputId = "total_vol_box"),
                    # DTOutput(outputId = "all_vol_table")
                  )
                  
                  
      ) #tabsetPanel
    ), #tabItem

#---------------------------------------------------------------------------------------


    #MATCHING
    #----------
    tabItem(
      tabName = 'sidebar_matching',
      h3("Matching"),
      br()
    
    ), #tabItem
    
    
    tabItem(
      tabName = 'setpanel_matching',
      h3('Match?')
      
    ), 

#---------------------------------------------------------------------------------------


    #ANALYSIS
    #----------
    tabItem(
      tabName = 'sidebar_analysis',
      h3("Analysis"),
      
      tabsetPanel(
        tabPanel("WEE"),
        tabPanel('Blah')
      )

    ), #tabItem

    #REPORTS
    #----------
    tabItem(
      tabName = "sidebar_reports",
      h3('Reports')
    
    ), #tabItem

#---------------------------------------------------------------------------------------

    
    #SETTINGS
    #----------
    tabItem(
      tabName = 'sidebar_settings',
      h3("Profile"),
      br()
    ) #tabItem



  #----------------
  #----------------

  ) #tabItems
) #dashboardBody



ui <- dashboardPage(header = header,
                    sidebar = sidebar,
                    body = body)