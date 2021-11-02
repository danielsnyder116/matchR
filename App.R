#---------------------
#       APP.R
#---------------------

load_package <- function(package_name) {
  
  if (!require(package_name, character.only = TRUE)) {
    install.packages(package_name)
    
    library(package_name)
  }
  
  else {
    library(package_name)
  }
  
}

packages <- c("shiny", "shinyjs", "dplyr", "shinydashboard", "shinyFeedback")

sapply(load_package, packages)


setwd("/Users/Daniel/Desktop/WEC/Shiny/volman/")






source("R/global.R")
source("UI.R")
source("Server.R")

app <- shinyApp(ui=ui, server=server)
runApp(app, launch.browser = TRUE)





