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
  
  #Adding CSS styling
  tags$head(tags$link(rel = "stylesheet", type = 'text/css', href = 'volman_styles.css')),
  
  tabItems(
    
    #VOLUNTEERS
    #----------
    tabItem(
      tabName = 'sidebar_volunteers',
      h3("Volunteers"),
      br(),
      
      #FIRST LEVEL OF TABS
      tabsetPanel(id = 'setpanel_vol_current_sem_tabs',
                  
        #OVERVIEW          
        tabPanel(
          title = 'Overview',
          value='vol_overview_tab',
          br(),
          
          valueBoxOutput(outputId = "total_vol_box") #,
         
          #DTOutput(outputId = "all_vol_table")
        ),
          
        #IN-PERSON TEACHERS
        tabPanel(
          title = 'In-Person Teachers',
          value='vol_in-person_tabs',
          br(),
          p("Data Table of Volunteers")
        ),
        
        #ONLINE TEACHERS
        tabPanel(
          title = 'Online Teachers',
          value='vol_online_tabs',
          br(),
          p("Data Table of Volunteers")
        ),
        
        
        #TUTORS
        tabPanel(
          title = 'Tutors',
          value='vol_tutors_tabs',
          br(),
          p("Data Table of Volunteers")
        ),
        
        
        #CLUB LEADERS
        tabPanel(
          title = 'Club Leaders',
          value='vol_club_leaders_tabs',
          br(),
          p("Data Table of Volunteers")
        ),
        
        #OTHER
        tabPanel(
          title = 'Other',
          value='vol_other_tabs',
          br(),
          p("Data Table of Volunteers")
        )
        
        
        
      ) #tabsetPanel 1st
  
      # tabsetPanel(id = 'vol_current_sem_tabs',
      #             
      #    
      #             
      #     tabPanel(
      #       title = 'Overview',
      #       value = 'vol_overview_tab',
      #       br(),
      #       actionButton(inputId = 'blah', label = 'BLAH')
      #     ),
      # 
      #     tabPanel(
      #       title = 'In-Person',
      #       value = 'vol_inperson_tab',
      #       br()
      #     ),
      # 
      #     tabPanel(
      #       title = 'Online',
      #       value = 'vol_online_tab',
      #       br()
      #     )
      # 
      # ) #tabsetPanel
    ), #tabItem
    
    #VOLUNTEERS
    #----------
    tabItem(
      tabName = 'sidebar_students',
      h3("Students"),
      
      tabsetPanel(id = 'stud_current_sem_tabs',
                  
                  
                  
                  tabPanel(
                    title = 'Overview',
                    value = 'stud_overview_tab',
                    br(),
                    actionButton(inputId = 'sblah', label = 'BLAH')
                  ),
                  
                  tabPanel(
                    title = 'In-Person',
                    value = 'stud_inperson_tab',
                    br()
                  ),
                  
                  tabPanel(
                    title = 'Online',
                    value = 'stud_online_tab',
                    br()
                  )
                  
      ) #tabsetPanel
    ), #tabItem

    #MATCHING
    #----------
    tabItem(
      tabName = 'sidebar_matching',
      h3("Matching"),
      br(),
      
      #FIRST LEVEL OF TABS
      tabsetPanel(id = 'setpanel_matching',
                  
        
        tabPanel(
          title = 'Unmatched',
          value='unmatched_tabs',
       
          #SECOND LEVEL OF TABS
          tabsetPanel(
            
            tabPanel(
              title = 'One',
              value = 'oney_tab',
              br()
            ),
            
            tabPanel(
              title = 'Two',
              value = 'twoy_tab',
              br()
            )
              
          ) #tabsetPanel 2nd
        ), #tabPanel 1st
        
        tabPanel(
          title = 'Matched',
          value='matched_tabs',
          
          #SECOND LEVEL OF TABS
          tabsetPanel(
            
            tabPanel(
              title = 'Three',
              value = 'threey_tab',
              br()
            ),
            
            tabPanel(
              title = 'Four',
              value = 'foury_tab'
            )
            
          ) #tabsetPanel 2nd
        ) #tabPanel 1st
        
        
        
        
      ) #tabsetPanel 1st
    ), #tabItem

    #ANALYSIS
    #----------
    tabItem(
      tabName = 'sidebar_analysis',
      h3("Analysis"),

      tabsetPanel(id='help',

        tabPanel(
          title = 'First Tab',
          value = 'help_1'
          
          
  
        )#,
  
        # tabPanel(
        #   title = 'Second Tab',
        #   value = 'second_tab',
        #   br()
        # )
      )


    ), #tabItem

    #REPORTS
    #----------
    tabItem(
      tabName = 'sidebar_reports',
      h3("Reports"),
      
      tabsetPanel(id="test_tab",

          tabItem(
            tabName = "asdf",
            h3("Blah"),
            
            tabPanel(
              title = 'First Tab',
              value = 'tesst_tab',
              h3("blah"),
              
              br(),
              actionButton(inputId='blah', label = "Click")
            
          )
          )
        ),
      

                 
                    
                  #   tabsetPanel(id='tesdfst_tab',
                  #               
                  #               tabPanel(
                  #                 title = 'Second Tab',
                  #                 value = 'second_tab',
                  #                 br()
                  #               )
                  #               
                  #   )
                  # 
                  # )

    ), #tabItem
    
    #SETTINGS
    #----------
    tabItem(
      tabName = 'sidebar_settings',
      h3("Profile"),
      br(),
      
      #FIRST LEVEL OF TABS
      tabsetPanel(id = 'setpanel_asfd',
                  
                  #PROFILE          
                  tabPanel(
                    title = 'Overview',
                    value='vol_ofsad',
                    br()
                  ),
                  
                
                  #OTHER
                  tabPanel(
                    title = 'Other',
                    value='other_tabs',
                    br(),
                    p("Data Table of Volunteers")
                  )
      ) #tabsetPanel 1st
    ) #tabItem

  ) #tabItems
  
) #dashboardBody



ui <- dashboardPage(header = header,
                    sidebar = sidebar,
                    body = body)