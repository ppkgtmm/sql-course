SELECT standard_amt_usd, SUM(standard_amt_usd) OVER(ORDER BY occurred_at) running_total
FROM orders;

SELECT standard_amt_usd, DATE_TRUNC('year', occurred_at) truncated_date,
SUM(standard_amt_usd) OVER(PARTITION BY DATE_TRUNC('year', occurred_at) ORDER BY occurred_at) running_total
FROM orders;

SELECT id, account_id, total, RANK() OVER(PARTITION BY account_id ORDER BY total DESC) total_rank
FROM orders;

SELECT id,
       account_id,
       standard_qty,
       DATE_TRUNC('month', occurred_at) AS month,
       DENSE_RANK() OVER (PARTITION BY account_id) AS dense_rank,
       SUM(standard_qty) OVER (PARTITION BY account_id) AS sum_std_qty,
       COUNT(standard_qty) OVER (PARTITION BY account_id) AS count_std_qty,
       AVG(standard_qty) OVER (PARTITION BY account_id) AS avg_std_qty,
       MIN(standard_qty) OVER (PARTITION BY account_id) AS min_std_qty,
       MAX(standard_qty) OVER (PARTITION BY account_id) AS max_std_qty
FROM orders;


SELECT id,
       account_id,
       DATE_TRUNC('year',occurred_at) AS year,
       DENSE_RANK() OVER account_year_window AS dense_rank,
       total_amt_usd,
       SUM(total_amt_usd) OVER account_year_window AS sum_total_amt_usd,
       COUNT(total_amt_usd) OVER account_year_window AS count_total_amt_usd,
       AVG(total_amt_usd) OVER account_year_window AS avg_total_amt_usd,
       MIN(total_amt_usd) OVER account_year_window AS min_total_amt_usd,
       MAX(total_amt_usd) OVER account_year_window AS max_total_amt_usd
FROM orders
WINDOW account_year_window AS (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at));

SELECT occurred_at, total_amt_usd, LEAD(total_amt_usd) OVER order_time_window "lead", LEAD(total_amt_usd) OVER order_time_window - total_amt_usd lead_difference
FROM (
	SELECT occurred_at, SUM(total_amt_usd) "total_amt_usd"
	FROM orders
	GROUP by 1
) sub
WINDOW order_time_window AS (ORDER BY occurred_at);

SELECT account_id, occurred_at, standard_qty, NTILE(4) OVER(PARTITION BY account_id ORDER BY standard_qty) standard_quartile
FROM orders;

SELECT account_id, occurred_at, gloss_qty, NTILE(2) OVER(PARTITION by account_id ORDER BY gloss_qty) gloss_half
FROM orders;

SELECT account_id, occurred_at, total_amt_usd, NTILE(100) OVER(PARTITION BY account_id ORDER BY total_amt_usd) total_percentile
FROM orders;
