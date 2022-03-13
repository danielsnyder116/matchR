#------------------------
#   viewProfile Functions
#------------------------
# Functions only used within scope of the viewProfileServer module


get_profile <- function(role_input){
  print("VP-F-01: Getting profile data")
  
  if (role_input == "Volunteer") {
    data <- load_data(VOL_TUTOR_TABLE) %>% filter(id == as.integer(values$id))
  }
  
  else {
    data <- load_data(STUD_FORM_TABLE) %>% filter(id == as.integer(values$id))
  }
  return (data)
}


get_rec_matches <- function(role_input) {
  print("VP-F-02: Getting potential matches for the individual")
  
  if (role_input == "Volunteer") {
    
    data <- load_data("potential_matches") %>% filter(volunteer_id == as.integer(values$id))
  }
  
  else {
    data <- load_data("potential_matches") %>% filter(student_id == as.integer(values$id))
  }
  
  return(data)
}



#get_current_semester <- function() {}
#get_previous_semester <- function() {}
#get_all_history <- function() {}



