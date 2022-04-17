psql -U postgres -f create-db.sql

psql crime -f ddl.sql

psql crime -c "\copy sf_crime_data from ./results.csv delimiter ',' csv header;"
