DROP TABLE IF EXISTS sf_crime_data;

CREATE TABLE sf_crime_data (
	incidnt_num varchar,
    category varchar,
    descript varchar,
    day_of_week varchar(10),
    date timestamp,
    time varchar(5),
    pd_district varchar,
    resolution varchar,
    address varchar,
    lon float,
    lat float,
    location varchar,
    id integer
);
