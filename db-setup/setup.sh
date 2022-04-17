psql -U postgres -f create-db.sql

psql parch -f ddl.sql

psql parch -f insert.sql