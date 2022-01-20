#------------------------
#   viewProfile Functions
#------------------------
# Functions only used within scope of the viewProfileServer module


get_indiv_form_data <- function(id_input, role_input){
  
  if (role_input == "Volunteer ") {
    data <- load_data(VOL_FORM_TABLE) %>% filter(id == as.integer(id_input))
  }
  
  else {
    data <- load_data(STUD_FORM_TABLE) %>% filter(id == as.integer(id_input))
    
  }
  
  return (data)
}




