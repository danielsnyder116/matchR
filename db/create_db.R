#---------------------
#   CREATE DB
#---------------------

source("./db/db_functions.R")

create_db()


#Adding users table by saving pre-made csv
df_users <- read.csv("../data/initial_users.csv")
update_table(db, "user", df_users, overwrite = TRUE)

