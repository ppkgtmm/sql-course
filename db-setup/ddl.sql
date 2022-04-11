DROP TABLE IF EXISTS web_events;

CREATE TABLE web_events (
	id integer,
	account_id integer,
	occurred_at timestamp,
	channel bpchar
);

DROP TABLE IF EXISTS sales_reps;

CREATE TABLE sales_reps (
	id integer,
	name bpchar,
	region_id integer
);

DROP TABLE IF EXISTS region;

CREATE TABLE region (
	id integer,
	name bpchar
);

DROP TABLE IF EXISTS orders;

CREATE TABLE orders (
	id integer,
	account_id integer,
	occurred_at timestamp,
	standard_qty integer,
	gloss_qty integer,
	poster_qty integer,
	total integer,
	standard_amt_usd numeric(10,2),
	gloss_amt_usd numeric(10,2),
	poster_amt_usd numeric(10,2),
	total_amt_usd numeric(10,2)
);

DROP TABLE IF EXISTS accounts;

CREATE TABLE accounts (
	id integer,
	name bpchar,
	website bpchar,
	lat numeric(11,8),
	long numeric(11,8),
	primary_poc bpchar,
	sales_rep_id integer
);
