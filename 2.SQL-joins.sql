SELECT * FROM orders JOIN accounts ON orders.account_id = accounts.id;

SELECT o.standard_qty, o.gloss_qty, o.poster_qty, a.website, a.primary_poc FROM orders o JOIN accounts a ON o.account_id = a.id;

SELECT a.primary_poc, w.occurred_at, w.channel, a.name FROM web_events w JOIN accounts a ON w.account_id = a.id WHERE a.name = 'Walmart';

SELECT r."name" region_name, s."name" sale_rep_name, a."name"  account_name 
FROM sales_reps s JOIN region r ON s.region_id = r.id 
JOIN accounts a ON s.id = a.sales_rep_id 
ORDER BY LOWER(a."name");

SELECT r.name region_name, a."name" account_name, (o.total_amt_usd / (o.total + 0.01)) unit_price
FROM orders o JOIN accounts a ON o.account_id = a.id
JOIN sales_reps s On a.sales_rep_id = s.id
JOIN region r ON s.region_id = r.id;

SELECT r."name" region, s."name" sale_rep, a."name" account
FROM sales_reps s LEFT JOIN region r ON s.region_id = r.id
LEFT JOIN accounts a ON a.sales_rep_id = s.id 
WHERE r."name" = 'Midwest'
ORDER BY LOWER(a."name");

SELECT r."name" region, s."name" sale_rep, a."name" account
FROM sales_reps s LEFT JOIN region r ON s.region_id = r.id
LEFT JOIN accounts a ON a.sales_rep_id = s.id
WHERE s."name" LIKE 'S% _%' AND r."name" = 'Midwest'
ORDER BY a."name";

SELECT r."name" region, s."name" sale_rep, a."name" account
FROM sales_reps s LEFT JOIN region r ON s.region_id = r.id
LEFT JOIN accounts a ON a.sales_rep_id = s.id
WHERE s."name" LIKE '_% K%' AND r."name" = 'Midwest'
ORDER BY a."name";

SELECT r."name" region, a."name" account, o.total_amt_usd / (o.total + 0.01) unit_price
FROM orders o LEFT JOIN accounts a ON o.account_id = a.id
LEFT JOIN sales_reps s ON a.sales_rep_id = s.id
LEFT JOIN region r ON s.region_id = r.id
WHERE o.standard_qty > 100;

SELECT r."name" region, a."name" account, o.total_amt_usd / (o.total + 0.01) unit_price
FROM orders o LEFT JOIN accounts a ON o.account_id = a.id
LEFT JOIN sales_reps s ON a.sales_rep_id = s.id
LEFT JOIN region r ON s.region_id = r.id
WHERE o.standard_qty > 100 AND o.poster_qty > 50
ORDER BY unit_price;

SELECT r."name" region, a."name" account, o.total_amt_usd / (o.total + 0.01) unit_price
FROM orders o LEFT JOIN accounts a ON o.account_id = a.id
LEFT JOIN sales_reps s ON a.sales_rep_id = s.id
LEFT JOIN region r ON s.region_id = r.id
WHERE o.standard_qty > 100 AND o.poster_qty > 50
ORDER BY unit_price DESC;

SELECT DISTINCT a."name", w.channel
FROM web_events w JOIN accounts a ON w.account_id = a.id AND a.id = 1001;

SELECT o.occurred_at, a."name" account, o.total, o.total_amt_usd
FROM orders o LEFT JOIN accounts a ON o.account_id = a.id
WHERE o.occurred_at BETWEEN '2015-01-01T00:00:00Z' AND '2015-12-31T23:59:59Z'
ORDER BY o.occurred_at DESC;

