#------------------------
#   viewProfile Functions
#------------------------
# Functions only used within scope of the viewProfileServer module


get_indiv_data <- function(id_input){
  
  data <- volunteers %>% filter(id == id_input)
  
  return (data)
}
