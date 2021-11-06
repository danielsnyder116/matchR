#----------------------
#   EXTRA UI STYLING
#----------------------


dropdownMenuCustom <- function (..., type = c("messages", "notifications", "tasks"), 
                                badgeStatus = "primary", icon = NULL, headerText = NULL, 
                                .list = NULL) {
  type <- match.arg(type)
  
  if (!is.null(badgeStatus)) 
    shinydashboard:::validateStatus(badgeStatus)
  
  items <- c(list(...), .list)
  lapply(items, shinydashboard:::tagAssert, type = "li")
  
  dropdownClass <- paste0("dropdown ", type, "-menu")
  
  if (is.null(icon)) {
    icon <- switch(type, messages = shiny::icon("envelope"), 
                   notifications = shiny::icon("warning"), tasks = shiny::icon("tasks"))
  }
  
  numItems <- length(items)
  
  if (is.null(badgeStatus)) {
    badge <- NULL
  }
  else {
    badge <- span(class = paste0("label label-", badgeStatus), 
                  numItems)
  }
  
  if (is.null(headerText)) {
    headerText <- paste("You have", numItems, type)
  }
  
  tags$li(class = dropdownClass, a(href = "#", class = "dropdown-toggle", `data-toggle` = "dropdown", icon, badge),
          tags$ul(class = "dropdown-menu", tags$li(class = "header", headerText), tags$li(tags$ul(class = "menu", items)))
  )
}





valueBoxCustom <- function (value, subtitle = NULL, icon = NULL, color = "aqua", width = 4, href = NULL) {
  
  shinydashboard:::validateColor(color)
  
  if (!is.null(icon)) shinydashboard:::tagAssert(icon, type = "i")
  
  boxContent <- div(class = paste0("small-box bg-", color), 
                    div(class = "inner", h3(value), p(subtitle)), if (!is.null(icon)) 
                      div(class = "icon-large", icon))
  
  if (!is.null(href)) 
    boxContent <- a(href = href, boxContent)
  
  div(class = if (!is.null(width)) paste0("col-sm-", width), boxContent)
}
  
