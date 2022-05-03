#---------------------
#       APP.R
#---------------------

#Be sure to comment out any call of install.packages() when using shinyapps.io
#For whatever reason that causes errors
load_package <- function(package) {

  #If package not installed, INSTALL FROM CRAN #Then attach package
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
              "stringr", "RSQLite", "dtplyr", "glue", "shinyWidgets",
              "dashboardthemes")

#"rsconnect", "shinyauthr"
sapply(packages, load_package)

# #SETUP FOR SHINYAPPS.IO
# #----------------------
# library(shiny)
# library(shinyjs)
# library(shinydashboard)
# library(DT)
# library(readr)
# library(RSQLite)
# library(glue)
# library(rsconnect)

options(shiny.fullstacktrace = TRUE)
#options(shiny.port = 1993)

setwd("/Users/Daniel/Desktop/WEC/Shiny/matchR/rshiny")

source("R/global.R")
source("R/core_functions.R")
source("R/custom_ui_styling.R")

source("../db/db_functions.R")

#Modules
source("./R/modules/view_profile/viewProfileServer.R")
source("./R/modules/view_profile/viewProfileUI.R")


source("Server.R")
source("UI.R")

app <- shinyApp(ui=ui, server=server)

runApp(launch.browser = TRUE)

