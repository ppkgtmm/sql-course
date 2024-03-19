# sql course

Repo created to store work from Udacity's SQL for data analysis MOOC which focuses on querying data to answer given business questions. Database setup process for this course has made more automated and reusable with written setup scripts

## set up

1. install [PostgreSQL](https://www.postgresql.org/download/)

2. go to `db-setup` folder

```sh
cd db-setup
```

3. grant permission to `setup.sh`

```sh
chmod +x setup.sh
```

4. run `setup.sh` to prepare database

```sh
./setup.sh
```

5. exit `db-setup` folder

```sh
cd ../
```

6. repeat step `2-5` for `sf-db-setup` folder

## database diagram

<img src="https://github.com/ppkgtmm/usql/raw/main/assets/parch-n-posey-er-diagram.png"/>

## notes

- Query performance tuning
  - Test query on subset of data by selecting a subset (LIMIT) with subquery in from clause
  - Reduce table sizes before joining them e.g. aggregate large tables before joining
  - Look at the cost in query plan, the higher the more time query will take, as a guide for optimization
