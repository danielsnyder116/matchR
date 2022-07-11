#---------------------
#      SERVER.R
#---------------------

server <- function(id, input, output) {
  
  #Getting all modularized scripts
  scripts <- list.files(path="./server", recursive=TRUE)
  
  #Sourcing each script dynamically
  for (script in scripts) {
    
    source(glue("./server/{script}"), local=TRUE)
  }

 
  #================
  # IMPORT ALL OEs HERE
  source("./observe_events.R", local = TRUE)
  

}
