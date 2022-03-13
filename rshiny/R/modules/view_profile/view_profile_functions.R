#------------------------
#   viewProfile Functions
#------------------------
# Functions only used within scope of the viewProfileServer module


get_profile <- function(){
  print("VP-F-01: Getting profile data")
  
  if (rv$role == "Volunteer") {
    data <- load_data(VOL_TUTOR_TABLE) %>% filter(id == rv$id)
  }
  
  else {
    data <- load_data(STUD_FORM_TABLE) %>% filter(id == rv$id)
  }
  return (data)
}


get_rec_matches <- function() {
  print("VP-F-02: Getting potential matches for the individual")
  
  #Filter to rows associated with volunter id and then show students (using their id)
  if (rv$role == "Volunteer") {
    data <- load_data("rec_matches") %>% filter(vol_id == rv$id) %>% rename(id = student_id)
  }
  
  #Filter to rows associated with student id and then show volunteers (using their id)
  else {
    data <- load_data("rec_matches") %>% filter(student_id == rv$id) %>% rename(id = vol_id)
  }
  
  return(data)
}



#get_current_semester <- function() {}
#get_previous_semester <- function() {}
#get_all_history <- function() {}



