#---------------------
#       UI.R
#---------------------


header <- dashboardHeader(

            #Sidebar title
            #title = "Mt. WEC",
            #icon('mountain'),
          
            title = "matchR",
            
            # div(tags$img(src = "wec_title_wide.png"), style = 'background-color: white;
            #            padding: 0px 0px 10px 0px; margin: 0px;'), 
            
            titleWidth = 170,
           
            #CUSTOM HEADER TITLE
            #There is no non-hacky way of doing this - have to tweak dropdown menu html
            tags$li(class = "dropdown", div(id='center-title', icon('people-arrows', style='padding-right: 4px; font-size:28px;'), 'matchR'))
            #,

            # dropdownMenuCustom(type = "messages", icon = icon('user'), badgeStatus = NULL),
            # dropdownMenuCustom(type = "notifications", icon = icon('cog'), badgeStatus = NULL)

)



sidebar <- dashboardSidebar(width = "170px",
  
  #Dynamic sidebar menu coming from Server.R
  sidebarMenuOutput("sidebar_menu")
  
)
  
  

body <- dashboardBody(
  
  #custom theme
  default_theme,
  
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
      h4("Welcome to matchR"),
      br(),
      
      tabsetPanel(id = 'setpanel_home',
      
        tabPanel(
          title = 'Summary',
          value = 'home_summary_tab',
          br(),
          
          fluidRow(
            valueBoxOutput(outputId = "summ_num_unmatched_studs", width = 2) %>% withSpinner(),
            valueBoxOutput(outputId = "summ_num_matched_studs", width = 2) %>% withSpinner(),
            valueBoxOutput(outputId = "summ_num_unmatched_vols", width = 2) %>% withSpinner(),
            valueBoxOutput(outputId = "summ_num_matched_vols", width = 2) %>% withSpinner(),
           
          ),
          
          fluidRow(
            
            valueBoxOutput(outputId = "summ_num_unfilled_studs", width = 2) %>% withSpinner(),
            valueBoxOutput(outputId = "summ_num_filled_studs", width = 2) %>% withSpinner(),
            valueBoxOutput(outputId = "summ_num_unfilled_vols", width = 2) %>% withSpinner(),
            valueBoxOutput(outputId = "summ_num_filled_vols", width = 2) %>% withSpinner(),
          ),
          
          br(), br(), br(),
          br(), br(), br(),
          br(), br(), br(),
          br(), br(), br(),
          br(), br(), br(),
          br(), br(), br(),
          br(), br(), br()
          
         #br()
          
          #MORE TO COME HERE! :D 
        ),
        
        tabPanel(
          title = 'Overview',
          value = 'home_overview_tab'
        ),
        
        tabPanel(
          title = 'User Guide',
          value = 'home_user_guide_tab'
        )#,
        
        
        # tabPanel(
        #   title = 'Report a Bug',
        #   value = 'home_bug_tab'
        # )
      ) #tabsetPanel
    ),
    
   

  #---------------------------------------------------------------------------------------


    #MATCHING
    #----------
    tabItem(
      tabName = 'sidebar_matching',
      h4(span("Matching", style="padding-right:1150px"),  actionButton(inputId = "overall_refresh_button", label = "Refresh",
                                       icon = icon("sync-alt", style='padding-right:4px;')), 
                         
         style='display:block;'
      ),

      tabsetPanel(id = 'setpanel_matching',
                  
       
        #UNMATCHED STUDENTS
        tabPanel(
          title = 'Unmatched Students',
          value = 'unmatched_stud_tab', 
          br(),
          
          fluidRow(
                   valueBoxOutput(outputId = "num_unmatched_studs", width = 2) %>% withSpinner(),
                   valueBoxOutput(outputId = "num_unfilled_studs", width = 2) %>% withSpinner()
           
          ),
          
          fluidRow(
            column(4, 
                    disabled(actionButton(class = 'standard-btn', inputId = "view_stud_button", label = "View Profile", icon=icon("folder-open", style='padding-right: 4px;'))),
                    disabled(actionButton(class = 'standard-btn', inputId = "initial_manual_match_stud_button", label = "Manual Match", 
                                          icon = icon("exchange-alt", style='padding-right: 4px;'))),
                   
                  h5("Select a student row to enable buttons for further action.")
            ) #column
          ), #fluidRow

          br(), 
          
          div(DT::dataTableOutput(outputId = "unmatched_stud_table"), style="overflow-x:scroll; white-space:nowrap;"), 
        ),
        
        #UNMATCHED VOLUNTEERS
        tabPanel(
          title = 'Unmatched Volunteers',
          value = 'unmatched_vol_tab', 
          br(),
          
          fluidRow(
            valueBoxOutput(outputId = "num_unmatched_vols", width = 2) %>% withSpinner(),
            valueBoxOutput(outputId = "num_unfilled_vols", width = 2) %>% withSpinner()
          ),
          
          fluidRow(
            column(4,
                   disabled(actionButton(class = 'standard-btn', inputId = "view_vol_button", label = "View Profile", icon=icon("folder-open", style='padding-right: 4px;'))),
                   disabled(actionButton(class = 'standard-btn', inputId = "initial_manual_match_vol_button", label = "Manual Match", 
                                         icon = icon("exchange-alt", style='padding-right: 4px;'))),
                   h5("Select a volunteer row to enable buttons for further action.")
            )
           
          ),

          br(),
          
          div(DT::dataTableOutput(outputId = "unmatched_vols_table"), style="overflow-x:scroll;white-space:nowrap;")
        ),
                  
        #OVERVIEW / MATCHES
        tabPanel(
          title = 'Matches',
          value = 'matches_tab', 
          br(),
          
          tabsetPanel(id = 'setpanel_match_types',
                      
            #NEW MATCHES
            tabPanel(
              title = "New Matches",
              value = "new_matches_tab",
              br(),
              
              fluidRow(
                #valueBoxOutput(outputId = "num_matched_studs", width = 2) %>% withSpinner(),
                #valueBoxOutput(outputId = "num_matched_vols", width = 2) %>% withSpinner(),
                #valueBoxOutput(outputId = "total_matches", width = 2) %>% withSpinner()
              ),
              
              disabled(actionButton(class = 'standard-btn', inputId = "initial_unmatch_button", label = "Unmatch",
                                    icon = icon("unlink", style='padding-right:4px;'))),
              
              h5("Click on a match row to enable button and take actions."),
              br(),
              
              div(DT::dataTableOutput(outputId = "new_matches_table"), style="overflow-x:scroll;white-space:nowrap;")

            ),
            
            #RE/CONTINUED MATCHES
            tabPanel(
              title = "Re-Matches",
              value = "rematches_tab",
              br(),
              
              disabled(actionButton(class = 'standard-btn', inputId = "initial_rematch_button", 
                                    label = "Rematch", icon = icon("people-arrows", style='padding-right:4px;'))),
              
              h5("Click on a match row to enable button and take actions."),
              
              br(),
              
              div(DT::dataTableOutput(outputId = "re_matches_table"), style="overflow-x:scroll;white-space:nowrap;")
            )
          ) #tabsetPanel

        ), #tabPanel Matches
        
        
        #MATCHED STUDENTS
        tabPanel(
          title = "Matched Students",
          value = "matched_stud_tab",
          br(),
          
          fluidRow(
            valueBoxOutput(outputId = "num_matched_studs", width = 2) %>% withSpinner()
          ),
          
          disabled(actionButton(class = 'standard-btn', inputId = "view_stud_match_button", 
                                label = "View Profile", icon=icon("folder-open", style='padding-right: 4px;'))),
          
          h5("Click on a match row to enable button and take actions."),
          
          br(),
          
          div(DT::dataTableOutput(outputId = "matched_studs_table"), style="overflow-x:scroll;white-space:nowrap;")
        ),
        
        
        #MATCHED VOLUNTEERS
        tabPanel(
          title = "Matched Volunteers",
          value = "matched_vol_tab",
          br(),
          
          fluidRow(
            valueBoxOutput(outputId = "num_matched_vols", width = 2) %>% withSpinner()
          ),
          
          disabled(actionButton(class = 'standard-btn', inputId = "view_vol_match_button", 
                                label = "View Profile", icon=icon("folder-open", style='padding-right: 4px;'))),
          
          h5("Click on a match row to enable button and take actions."),
          
          br(),
          
          div(DT::dataTableOutput(outputId = "matched_vols_table"), style="overflow-x:scroll;white-space:nowrap;")
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
  
  #) #shinyjs::hidden
) #dashboardBody



ui <- dashboardPage(header = header,
                    sidebar = sidebar,
                    body = body)