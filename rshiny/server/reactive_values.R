#REACTIVE VALUES
#------------------------------------------
# #List of active tabs in unmatched section
active_tabs <<- c()
USER <<- reactiveVal(Sys.info()[['user']])
rv <<- reactiveValues(id = "", name = "", role = "", status = "", match_ids = "") #Instantiate reactive values to maintain active individual 
match_trigger <<- reactiveVal(0) #reactive value used to trigger updates to data when match/unmatch made
