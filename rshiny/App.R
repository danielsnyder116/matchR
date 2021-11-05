#---------------------
#       APP.R
#---------------------

load_package <- function(package) {
  
  #If package not installed, INSTALL FROM CRAN
  #Then attach package
  if (!require(package, character.only = TRUE)) {
    
    install.packages(package, repos = "http://cran.us.r-project.org", quiet = TRUE)
    library(package, character.only = TRUE, quietly = TRUE, warn.conflicts = FALSE)
  }
  
  #Otherwise attach package
  else {
    library(package, character.only = TRUE, quietly = TRUE, warn.conflicts = FALSE)
  }
}

packages <- c("shiny", "shinyjs", "shinydashboard", "shinyFeedback",
              "shinycssloaders", "DT", "dplyr", "readr", "lubridate", 
              "RSQLite", "dtplyr", "glue")

sapply(packages, load_package)

options(shiny.fullstacktrace = TRUE)
options(shiny.port = 1993)


setwd("/Users/Daniel/Desktop/WEC/Shiny/volman/rshiny")


source("R/global.R")
source("R/core_functions.R")
source("UI.R")
source("Server.R")

app <- shinyApp(ui=ui, server=server)
runApp(launch.browser = TRUE)



