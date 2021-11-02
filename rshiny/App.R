#---------------------
#       APP.R
#---------------------

load_package <- function(package) {
  
  if (!require(package, character.only = TRUE)) {
    
    install.packages(package, repos = "http://cran.us.r-project.org", quiet = TRUE)
    library(package, character.only = TRUE, quietly = TRUE, warn.conflicts = FALSE)
  }
  
  else {
    library(package, character.only = TRUE, quietly = TRUE, warn.conflicts = FALSE)
  }
}

packages <- c("shiny", "shinyjs", "dplyr", "shinydashboard", "shinyFeedback",
              "shinycssloaders", "DT", "lubridate", "RSQLite", "dtplyr", "glue")

sapply(packages, load_package)

options(shiny.fullstacktrace = TRUE)
options(shiny.port = 1993)


setwd("/Users/Daniel/Desktop/WEC/Shiny/volman/")






source("R/global.R")
source("UI.R")
source("Server.R")

app <- shinyApp(ui=ui, server=server)
runApp(launch.browser = TRUE)



