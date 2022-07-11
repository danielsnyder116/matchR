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