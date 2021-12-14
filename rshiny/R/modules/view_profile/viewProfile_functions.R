#------------------------
#   viewProfile Functions
#------------------------
# Functions only used within scope of the viewProfileServer module


get_indiv_data <- function(id_input){
  
  data <- load_data("volunteers") %>% filter(id == as.integer(id_input))
  
  return (data)
}

