SELECT RIGHT(website, 3) "type", COUNT(*) 
FROM accounts
GROUP BY 1
ORDER by 2 DESC;

SELECT LEFT("name", 1) first_letter, COUNT(*)
FROM accounts
GROUP BY 1
ORDER BY 2 DESC;

WITH letter_or_num AS (
	SELECT 
		CASE
			WHEN LOWER(LEFT("name", 1)) BETWEEN 'a' AND 'z' THEN 'letter'
			ELSE 'number'
		END name_start_with,
		COUNT(*)
	FROM accounts
	GROUP BY 1
)

SELECT name_start_with, "count" / (SELECT SUM("count") FROM letter_or_num) proportion
FROM letter_or_num
ORDER BY 2 DESC;

WITH is_vowel AS (
	SELECT
		CASE
			WHEN LOWER(LEFT("name", 1)) IN ('a', 'e', 'i', 'o', 'u') THEN 'vowel'
			ELSE 'other'
		END start_with,
		COUNT(*)
	FROM accounts
	GROUP BY 1
)

SELECT start_with, 100 * "count" / (SELECT SUM("count") FROM is_vowel) percent
FROM is_vowel
ORDER BY 2 DESC;

WITH poc_name AS (
	SELECT
	CASE
		WHEN primary_poc IS NULL THEN NULL
		ELSE LEFT(primary_poc, STRPOS(primary_poc, ' ') - 1)
	END first_name,
	CASE
		WHEN primary_poc IS NULL THEN NULL
		ELSE RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' '))
	END last_name,
	primary_poc,
	"name"
	FROM accounts
)

SELECT first_name, last_name FROM poc_name;

SELECT
CASE
	WHEN "name" IS NULL THEN NULL
	ELSE LEFT("name", STRPOS("name", ' ') - 1)
END first_name,
CASE
	WHEN "name" IS NULL THEN NULL
	ELSE RIGHT("name", LENGTH("name") - STRPOS("name", ' '))
END last_name,
"name"
FROM sales_reps;

SELECT first_name, last_name, "name", CONCAT(first_name, '.', last_name, '@', "name", '.com') email
FROM poc_name;

SELECT first_name, last_name, "name", CONCAT(first_name, '.', last_name, '@', REPLACE("name", ' ', ''), '.com') email
FROM poc_name;

SELECT first_name, last_name, "name", (
	LOWER(LEFT(first_name, 1)) || LOWER(RIGHT(first_name, 1)) || LOWER(LEFT(last_name, 1)) || 
	LOWER(RIGHT(last_name, 1)) || LENGTH(first_name) || LENGTH(last_name) || UPPER(REPLACE("name", ' ', ''))
) pw
FROM poc_name;

SELECT *
FROM sf_crime_data
LIMIT 10;

SELECT "date", CONCAT(SUBSTRING("date", 7, 4), '-' , SUBSTRING("date", 1, 2), '-', SUBSTRING("date", 4, 2))::DATE cleaned_date
FROM  sf_crime_data;

WITH acc_order_null AS (
	SELECT COUNT(o.id)
	FROM accounts a LEFT JOIN orders o ON a.id = o.account_id
),
acc_order_filled AS (
	SELECT a.*, COALESCE(o.id, a.id) order_id, COALESCE(o.account_id, a.id) account_id, COALESCE(o.standard_qty, 0) standard_qty,
	COALESCE(o.gloss_qty, 0) gloss_qty, COALESCE(o.poster_qty, 0 ) poster_qty, COALESCE(o.total, 0) total,
	COALESCE(o.standard_amt_usd, 0) standard_amt_usd, COALESCE(o.gloss_amt_usd, 0) gloss_amt_usd, COALESCE(o.poster_amt_usd, 0) poster_amt_usd,
	COALESCE(o.total_amt_usd, 0) total_amt_usd
	FROM accounts a LEFT JOIN orders o ON a.id = o.account_id
)

SELECT (SELECT * FROM acc_order_null) with_null, (SELECT COUNT(order_id) FROM acc_order_filled) filled_null;
