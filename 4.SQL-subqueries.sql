SELECT channel, date_trunc('day', occurred_at) event_date, COUNT(*) event_count
FROM web_events
GROUP BY 1, 2
ORDER BY 3 DESC;

SELECT channel, AVG(event_count) avg_event_per_day
FROM (
	SELECT channel, date_trunc('day', occurred_at) event_date, COUNT(*) event_count
	FROM web_events
	GROUP BY 1, 2
) sub
GROUP BY 1
ORDER BY 2 DESC;

SELECT AVG(standard_qty) standard, AVG(gloss_qty) gloss, AVG(poster_qty) poster, SUM(total_amt_usd) total_sales
FROM orders
WHERE date_trunc('month', occurred_at) = (
	SELECT date_trunc('month', MIN(occurred_at))
	FROM orders
);

WITH order_full AS (
	SELECT s.id rep_id, s."name" rep_name, r.id region_id, r."name" region_name, SUM(o.total_amt_usd) total_amt_usd
	FROM orders o JOIN accounts a ON o.account_id = a.id
	JOIN sales_reps s on a.sales_rep_id = s.id
	JOIN region r ON s.region_id = r.id
	GROUP BY 1, 2, 3, 4
)

SELECT rg."name", 
(
	SELECT rep_name
	FROM order_full of
	WHERE of.region_id = rg.id
	ORDER BY total_amt_usd DESC
	LIMIT 1
),
(
	SELECT MAX(total_amt_usd) total_sales
	FROM order_full of
	WHERE of.region_id = rg.id
)
FROM region rg;


WITH region_rep_sales AS (
	SELECT s.id rep_id, s."name" rep_name, r.id region_id, r."name" region_name, SUM(o.total_amt_usd) total_sales
	FROM orders o JOIN accounts a ON o.account_id = a.id
	JOIN sales_reps s on a.sales_rep_id = s.id
	JOIN region r ON s.region_id = r.id
	GROUP BY 1, 2, 3, 4
)

SELECT rrs.region_name, rrs.rep_name, rrs.total_sales
FROM region_rep_sales rrs JOIN (
	SELECT region_name, MAX(total_sales) max_sales
	FROM region_rep_sales
	GROUP BY 1
) sub ON rrs.region_name = sub.region_name AND rrs.total_sales = sub.max_sales;

WITH region_sales AS (	
	SELECT r."name" region, o.total_amt_usd 
	FROM orders o JOIN accounts a ON o.account_id = a.id
	JOIN sales_reps s ON a.sales_rep_id = s.id
	JOIN region r ON s.region_id = r.id
)

SELECT region, SUM(total_amt_usd), COUNT(*)
FROM region_sales
GROUP BY 1
HAVING SUM(total_amt_usd) = (
	SELECT MAX(sub.total_sales)
	FROM (
		SELECT region, SUM(total_amt_usd) total_sales
		FROM region_sales
		GROUP BY 1
	) sub
);

WITH max_std AS (
	SELECT o.account_id, SUM(o.standard_qty) standard
	FROM orders o
	GROUP by 1
	ORDER by 2 DESC
	LIMIT 1
), target_total AS (
	SELECT SUM(o.total) total_purchases
	FROM orders o
	WHERE o.account_id = (SELECT account_id FROM max_std)
)

SELECT COUNT(*)
FROM (
	SELECT o.account_id, SUM(o.total) total
	FROM orders o
	GROUP BY 1
	HAVING SUM(o.total) > (SELECT total_purchases FROM target_total)
) sub;

WITH acc_usd AS (
	SELECT o.account_id, SUM(o.total_amt_usd) total_usd
	FROM orders o
	GROUP BY 1
), acc_highest_usd AS (
	SELECT o.account_id, SUM(o.total_amt_usd) max_usd
	FROM orders o
	GROUP BY 1
	HAVING SUM(o.total_amt_usd) = (
		SELECT MAX(total_usd)
		FROM acc_usd
	)
)
SELECT a.id, a."name", w.channel, COUNT(*)
FROM web_events w JOIN acc_highest_usd acc ON w.account_id = acc.account_id 
JOIN accounts a ON w.account_id = a.id
GROUP BY 1, 2, 3
ORDER by 4 DESC;

WITH top_10_acc AS (
	SELECT o.account_id, SUM(total_amt_usd) total_amt_spent
	FROM orders o
	GROUP by 1
	ORDER by 2 DESC
	LIMIT 10
)
SELECT AVG(total_amt_spent) avg_amt_lifetime
FROM top_10_acc;

WITH avg_all AS (
	SELECT AVG(total_amt_usd)
	FROM orders
), avg_by_company AS (
	SELECT account_id, AVG(total_amt_usd) avg_amt_usd
	FROM orders
	GROUP BY 1
	HAVING AVG(total_amt_usd) > (SELECT * FROM avg_all)
)

SELECT AVG(avg_amt_usd)
FROM avg_by_company;
