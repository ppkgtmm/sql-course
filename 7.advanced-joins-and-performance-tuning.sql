SELECT *
FROM sales_reps s FULL JOIN accounts a ON a.sales_rep_id = s.id
WHERE s.id IS NOT NULL AND a.sales_rep_id IS NOT NULL;

SELECT *
FROM sales_reps s FULL JOIN accounts a ON a.sales_rep_id = s.id
WHERE s.id IS NULL OR a.sales_rep_id IS NULL;

SELECT a."name" account, a.primary_poc, s."name" rep
FROM accounts a LEFT JOIN sales_reps s ON a.sales_rep_id = s.id AND a.primary_poc < s."name";

SELECT w1.id w1_id,
       w1.account_id w1_account_id,
       w1.occurred_at w1_occurred_at,
       w1.channel w1_channel,
       w2.id w2_id,
       w2.account_id w2_account_id,
       w2.occurred_at w2_occurred_at,
       w2.channel w2_channel
FROM web_events w1 LEFT JOIN web_events w2
ON w1.account_id = w2.account_id
AND w2.occurred_at > w1.occurred_at
AND w2.occurred_at <= w1.occurred_at + INTERVAL '1 day'
ORDER BY 2, 7;

WITH double_accounts AS ( 
	SELECT *
	FROM accounts
	UNION ALL
	SELECT *
	FROM accounts
)

SELECT * FROM double_accounts;

SELECT *
FROM accounts
WHERE "name" = 'Walmart'
UNION ALL
SELECT *
FROM accounts
WHERE "name" = 'Disney';

SELECT "name", COUNT(*)
FROM double_accounts
GROUP BY 1
ORDER BY 2 DESC;

EXPLAIN
SELECT account_id, channel FROM web_events WHERE occurred_at > '2015-06-06'
ORDER BY occurred_at
LIMIT 10;

SELECT DATE_TRUNC('day', o.occurred_at) "date",
COUNT(DISTINCT a.sales_rep_id) rep_count,
COUNT(DISTINCT o.id) order_count,
COUNT(DISTINCT w.id) event_count
FROM orders o JOIN accounts a ON o.account_id = a.id
JOIN web_events w ON DATE_TRUNC('day', o.occurred_at) = DATE_TRUNC('day', w.occurred_at)
GROUP BY 1
ORDER BY 1 DESC;

WITH date_order_rep AS (
	SELECT DATE_TRUNC('day', o.occurred_at) "date", 
	COUNT(o.id) order_count,
	COUNT(DISTINCT a.sales_rep_id) rep_count
	FROM orders o JOIN accounts a ON o.account_id = a.id
	GROUP BY 1
), date_events AS (
	SELECT DATE_TRUNC('day', w.occurred_at) "date", COUNT(*) event_count
	FROM web_events w
	GROUP BY 1
)

SELECT * 
FROM date_order_rep dor JOIN date_events de ON dor."date" = de."date"
ORDER BY dor."date" DESC;
