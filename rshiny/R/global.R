#---------------------
#       GLOBAL.R
#---------------------

DB_PATH <- glue("/Users/Daniel/Desktop/WEC/Shiny/database/active/matchr.db")
DB_NAME <- strsplit(DB_PATH, split = "active/")[[1]][2]


#withSpinner color global setting
options(spinner.color = "#74bee9")


