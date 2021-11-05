#---------------------
#       GLOBAL.R
#---------------------

DB_PATH <<- glue("/Users/Daniel/Desktop/WEC/Shiny/database/active/volman_db_{Sys.Date()}.db")
DB_NAME <<- strsplit(DB_PATH, split = "active/")[[1]][2]

USER <<- reactiveVal(NULL)


