-- SELECT * FROM orders;

-- SELECT id, account_id, occurred_at FROM orders;

-- SELECT occurred_at, account_id, channel FROM web_events LIMIT 15;

-- SELECT id, occurred_at, total_amt_usd FROM orders ORDER BY occurred_at LIMIT 10;

-- SELECT id, account_id, total_amt_usd FROM orders ORDER BY total_amt_usd DESC LIMIT 5;

-- SELECT id, account_id, total_amt_usd FROM orders ORDER BY total_amt_usd LIMIT 20;

-- SELECT id, account_id, total_amt_usd FROM orders ORDER BY account_id, total_amt_usd DESC;

-- SELECT id, account_id, total_amt_usd FROM orders ORDER BY total_amt_usd DESC, account_id;
