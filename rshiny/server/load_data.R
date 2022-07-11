#------------------
#      DATA
#------------------

VOL_FORM_TABLE <<- "volunteers"
VOL_TUTOR_TABLE <<- "vol_tutors"
VOL_HIST_TABLE <<- "vols_historical"

STUD_FORM_TABLE <<- "students"
#STUD_HIST_TABLE <<- "stud_historical"
MATCH_TABLE <<- "matches"


#Data will be updated when specific changes are recorded
# - New match made
# - Match unmatched/undone
# - New student(s) / volunteer(s) data added
# - Student(s) / volunteer(s) status changes (drops out / inactive or 
#when student makes payment and is eligible to be matched or 
#when new volunteer has had call/interview with Yaritza/Kendall and is "cleared"
# - When student/volunteer slots are all filled (student has all tutors and volunteer has all tutees)

db_data <- eventReactive(match_trigger(), {
  
  print("S-ER-1: Updating data tables")
  
  #Loading data and saving in list to access later
  #Want to ensure that all data updates at the same time
  db_data <- list( VOL_FORM = reactive({ load_data(VOL_FORM_TABLE) }),
                   VOL_TUTOR = reactive({ load_data(VOL_TUTOR_TABLE) }),
                   #VOL_HIST = reactive({ load_data(VOL_HIST_TABLE) }),
                   
                   STUD_FORM = reactive({ load_data(STUD_FORM_TABLE) }),
                   #STUD_TUTEE = reactive({ load_data(STUD_TUTEE_TABLE) })#,
                   #STUD_HIST = reactive({ load_data(STUD_HIST_TABLE) })
                   
                   MATCHES = reactive({ load_data(MATCH_TABLE) })
  )
})