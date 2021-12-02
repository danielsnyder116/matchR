#---------------------
#       GLOBAL.R
#---------------------

DB_PATH <- glue("/Users/Daniel/Desktop/WEC/Shiny/database/active/volman_db_2021-11-04.db")
DB_NAME <- strsplit(DB_PATH, split = "active/")[[1]][2]

USER <- reactiveVal(NULL)


#df <- read.csv("./../../data/initial_users.csv")


users <- tibble(user = c("dsnyder", "cgriffiths", "yabrego"),
                password = c("123", "123", "123"),
                name = c("Danny Snyder", "Chris Griffiths", "Yaritza Abrego")
                )



