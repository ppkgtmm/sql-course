SELECT COUNT(*) FROM accounts;

SELECT COUNT(*) FROM orders;

SELECT COUNT(*) FROM region;

SELECT COUNT(*) FROM sales_reps;

SELECT COUNT(*) FROM web_events;

SELECT SUM(poster_qty) poster_qty_sum FROM orders;

SELECT SUM(standard_qty) standard_qty_sum FROM orders;

SELECT SUM(total_amt_usd) total_amt_usd_sum FROM orders;

SELECT id, standard_amt_usd + gloss_amt_usd total_standard_gloss FROM orders;

SELECT SUM(standard_amt_usd) / SUM(standard_qty) standard_amt_per_qty FROM orders;

SELECT MIN(occurred_at) earliest_order_at FROM orders;

SELECT occurred_at FROM orders ORDER BY occurred_at LIMIT 1;

SELECT MAX(occurred_at) latest_event_at FROM web_events;

SELECT occurred_at FROM web_events ORDER BY occurred_at DESC LIMIT 1;

SELECT AVG(standard_amt_usd) avg_standard_amt, 
AVG(gloss_amt_usd) avg_gloss_amt, 
AVG(poster_amt_usd) avg_poster_amt, 
AVG(standard_qty) avg_standard_qty,
AVG(gloss_qty) avg_gloss_qty,
AVG(poster_qty) avg_poster_qty
FROM orders;

SELECT a."name", o.occurred_at
FROM orders o JOIN accounts a ON o.account_id = a.id
ORDER BY o.occurred_at
LIMIT 1;

SELECT a."name", SUM(o.total_amt_usd) total_sales_usd
FROM orders o JOIN accounts a ON o.account_id = a.id
GROUP BY a."name";

SELECT w.occurred_at, w.channel, a."name"
FROM web_events w JOIN accounts a ON w.account_id = a.id
ORDER BY w.occurred_at DESC
LIMIT 1;

SELECT channel, COUNT(*)
FROM web_events
GROUP BY channel;

SELECT a.primary_poc
FROM web_events w JOIN accounts a ON w.account_id = a.id
ORDER BY w.occurred_at
LIMIT 1;

SELECT a.name, MIN(o.total_amt_usd) min_total
FROM orders o JOIN accounts a ON o.account_id = a.id
GROUP BY a.name
ORDER BY min_total;

SELECT r."name" region, COUNT(s.id) reps
FROM sales_reps s JOIN region r ON s.region_id = r.id
GROUP BY region
ORDER BY reps;

SELECT a."name", AVG(o.standard_qty) avg_standard_qty, AVG(o.gloss_qty) avg_gloss_qty, AVG(o.poster_qty) avg_poster_qty
FROM orders o JOIN accounts a ON o.account_id = a.id
GROUP BY a."name";

SELECT a."name", AVG(o.standard_amt_usd) avg_standard, AVG(o.gloss_amt_usd) avg_gloss, AVG(o.poster_amt_usd) avg_poster
FROM orders o JOIN accounts a ON o.account_id = a.id
GROUP BY a."name";

SELECT s."name" sale_rep, w.channel, COUNT(*) count
FROM web_events w JOIN accounts a ON w.account_id = a.id
JOIN sales_reps s ON a.sales_rep_id = s.id
GROUP BY sale_rep, w.channel
ORDER BY count DESC;

SELECT r."name" region, w.channel, COUNT(*) count
FROM web_events w JOIN accounts a ON w.account_id = a.id
JOIN sales_reps s ON a.sales_rep_id = s.id
JOIN region r ON s.region_id = r.id
GROUP BY region, w.channel
ORDER BY count DESC;

SELECT DISTINCT a.id account_id, a."name" account, r.id region_id, r."name" region
FROM accounts a JOIN sales_reps s ON a.sales_rep_id = s.id
JOIN region r ON s.region_id = r.id
ORDER BY a.id, region;

SELECT s.id rep_id, s."name" rep, COUNT(*) num_accounts
FROM accounts a JOIN sales_reps s ON a.sales_rep_id = s.id
GROUP BY rep_id, rep
ORDER BY num_accounts DESC;

WITH rep_acc_gt_5 AS (
 	SELECT s.id, s."name" , COUNT(*)
	FROM accounts a JOIN sales_reps s ON a.sales_rep_id = s.id
	GROUP BY 1, 2
	HAVING COUNT(*) > 5
)
SELECT COUNT(*) FROM rep_acc_gt_5;

WITH acc_order_gt_20 AS (
	SELECT a.id, a."name", COUNT(*)
	FROM orders o JOIN accounts a ON o.account_id = a.id
	GROUP BY 1, 2
	HAVING COUNT(*) > 20
)
SELECT COUNT(*) FROM acc_order_gt_20;

SELECT a.id, a."name", COUNT(*)
FROM orders o JOIN accounts a ON o.account_id = a.id
GROUP BY 1, 2
ORDER BY 3 DESC
LIMIT 1;

WITH acc_spending_gt_30k AS (
	SELECT a.id, a."name", SUM(o.total_amt_usd)
	FROM orders o JOIN accounts a ON o.account_id = a.id
	GROUP BY 1, 2
	HAVING SUM(o.total_amt_usd) > 30000
)
SELECT COUNT(*) FROM acc_spending_gt_30k;


WITH acc_spending_lt_1k AS (
	SELECT a.id, a."name", SUM(o.total_amt_usd)
	FROM orders o JOIN accounts a ON o.account_id = a.id
	GROUP BY 1, 2
	HAVING SUM(o.total_amt_usd) < 1000
)
SELECT COUNT(*) FROM acc_spending_lt_1k;

WITH acc_spending AS (
	SELECT a.id, a."name", SUM(o.total_amt_usd) total_spending
	FROM orders o JOIN accounts a ON o.account_id = a.id
	GROUP BY 1, 2
)

SELECT * FROM acc_spending ORDER BY total_spending DESC LIMIT 1;

SELECT * FROM acc_spending ORDER BY total_spending LIMIT 1;

SELECT a.id, a."name", COUNT(*)
FROM web_events w JOIN accounts a ON w.account_id = a.id
WHERE w.channel = 'facebook'
GROUP BY 1, 2
HAVING COUNT(*) > 6
ORDER BY 3;

SELECT a.id, a."name", COUNT(*)
FROM web_events w JOIN accounts a ON w.account_id = a.id
WHERE w.channel = 'facebook'
GROUP BY 1, 2
ORDER BY 3 DESC
LIMIT 1;

SELECT channel, COUNT(*) usage_count, COUNT(DISTINCT account_id) user_count
FROM web_events
GROUP BY 1
ORDER BY 2 DESC, 3 DESC
LIMIT 1;

SELECT EXTRACT(YEAR FROM occurred_at) "year", SUM(total_amt_usd) total_sales
FROM orders
GROUP BY 1
ORDER BY 2 DESC;

SELECT EXTRACT(MONTH FROM occurred_at) "month", EXTRACT(YEAR FROM occurred_at) "year", SUM(total_amt_usd) total_sales
FROM orders
WHERE EXTRACT(YEAR FROM occurred_at) IN (2013, 2017)
GROUP BY 2, 1;

SELECT EXTRACT(MONTH FROM occurred_at) "month", SUM(total_amt_usd) total_sales
FROM orders
WHERE EXTRACT(YEAR FROM occurred_at) NOT IN (2013, 2017)
GROUP BY 1
ORDER BY 2 DESC;

SELECT EXTRACT(YEAR FROM occurred_at) "year", COUNT(*) total_sales
FROM orders
GROUP BY 1
ORDER BY 2 DESC;

SELECT EXTRACT(MONTH FROM occurred_at) "month", COUNT(*) total_sales
FROM orders
WHERE EXTRACT(YEAR FROM occurred_at) NOT IN (2013, 2017)
GROUP BY 1
ORDER BY 2 DESC;

SELECT EXTRACT(MONTH FROM o.occurred_at) "month", EXTRACT(YEAR FROM o.occurred_at) "year", SUM(gloss_amt_usd) gloss_sales
FROM orders o JOIN accounts a ON o.account_id = a.id
WHERE a."name" = 'Walmart'
GROUP BY 1, 2
ORDER BY 3 DESC
LIMIT 1;

SELECT account_id, total_amt_usd,
CASE
	WHEN total_amt_usd >= 3000 THEN 'Large'
	ELSE 'Small'
END order_level
FROM orders

SELECT CASE
WHEN total >= 2000 THEN 'At Least 2000'
WHEN total BETWEEN 1000 AND 2000 THEN 'Between 1000 and 2000'
ELSE 'Less than 1000'
END category, COUNT(*)
FROM orders
GROUP BY 1;

SELECT a.id, a."name", SUM(o.total_amt_usd) total_sales, 
CASE
	WHEN SUM(o.total_amt_usd) > 200000 THEN 'top'
	WHEN SUM(o.total_amt_usd) >= 100000 THEN 'middle'
	ELSE 'low'
END "level"
FROM orders o JOIN accounts a ON o.account_id = a.id
GROUP BY 1, 2
ORDER BY 3 DESC;

SELECT a.id, a."name", SUM(o.total_amt_usd) total_sales, 
CASE
	WHEN SUM(o.total_amt_usd) > 200000 THEN 'top'
	WHEN SUM(o.total_amt_usd) >= 100000 THEN 'middle'
	ELSE 'low'
END "level"
FROM orders o JOIN accounts a ON o.account_id = a.id
WHERE EXTRACT(YEAR FROM o.occurred_at) IN (2016, 2017)
GROUP BY 1, 2
ORDER BY 3 DESC;

SELECT s.id, s."name", COUNT(*) total_orders, 
CASE
	WHEN COUNT(*) > 200 THEN 'top'
	ELSE 'not'
END top_or_not
FROM orders o JOIN accounts a ON o.account_id = a.id
JOIN sales_reps s ON a.sales_rep_id = s.id
GROUP BY 1, 2
ORDER BY 3 DESC;

SELECT s.id, s."name", COUNT(*) total_orders, SUM(o.total_amt_usd) total_sales,
CASE
	WHEN COUNT(*) > 200 OR SUM(o.total_amt_usd) > 750000 THEN 'top'
	WHEN COUNT(*) > 150 OR SUM(o.total_amt_usd) > 500000 THEN 'middle'
	ELSE 'low'
END
FROM orders o JOIN accounts a ON o.account_id = a.id
JOIN sales_reps s ON a.sales_rep_id = s.id
GROUP BY 1, 2
ORDER BY 4 DESC;
