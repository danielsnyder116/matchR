#------------------------
#   viewProfile Functions
#------------------------
# Functions only used within scope of the viewProfileServer module


get_profile <- function(id_input, role_input){
  
  if (role_input == "Volunteer") {
    data <- load_data(VOL_TUTOR_TABLE) %>% filter(id == as.integer(id_input))
  }
  
  else {
    data <- load_data(STUD_FORM_TABLE) %>% filter(id == as.integer(id_input))
  }
  return (data)
}


#get_rec_matches <- function() {}
#get_current_semester <- function() {}
#get_previous_semester <- function() {}
#get_all_history <- function() {}



