library(RPostgres)
library(DBI)
# Put the credentials in this script
# Never push credentials to git!! --> use .gitignore on .credentials.R
source("credentials.R")
# Function to send queries to Postgres
source("psql_queries.R")

# Create a new schema in Postgres on docker
psql_manipulate(cred = cred_psql_docker, 
                query_string = "CREATE SCHEMA intg1;")

# Create a table in the new schema 
psql_manipulate(cred = cred_psql_docker, 
                query_string = 
                  "create table intg1.students (
	Students_id serial primary key,
	Students_name varchar(255),
	department_code varchar(255),
  start_date timestamp,
  is_active Boolean);")

# insert rows using psql_manipulate()
psql_manipulate(
  cred = cred_psql_docker, 
  query_string = "
    INSERT INTO intg1.students
      (students_id, students_name, department_code, start_date, is_active)
    VALUES
      (DEFAULT, 'Dino', 81735, '2024-12-01 08:00:00', TRUE),
      (DEFAULT, 'Alex', 81737, '2024-12-02 09:30:00', FALSE);
  "
)


# insert rows using psql_append_df()
# create a df table 
df_students <- data.frame(
  students_name   = c("Alice", "Bob"),
  department_code = c(81738, 81739),
  start_date      = c("2024-12-01 08:00:00", "2024-12-01 08:00:00"),
  is_active       = c(TRUE, TRUE)
)
# Append it to your PostgreSQL table using
students <- psql_append_df(
  cred = cred_psql_docker,
  schema_name = "intg1",
  tab_name = "students",
  df = df_students
)

# Fetching rows into R
psql_select(cred = cred_psql_docker, 
            query_string = "select * from intg1.students;")

