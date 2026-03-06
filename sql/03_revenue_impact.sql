# Overall Revenue Loss from Failed Transactions

SELECT
  ROUND(SUM(amount), 2) AS total_amount,
  ROUND(SUM(CASE WHEN status = 'failed' THEN amount ELSE 0 END), 2) AS failed_amount,
  ROUND(
    100 * SUM(CASE WHEN status = 'failed' THEN amount ELSE 0 END) / SUM(amount),
    2
  ) AS failed_amount_share_pct
FROM transactions;

# Revenue Loss by Payment Processing Stage

SELECT
  stage_failed,
  ROUND(SUM(amount), 2) AS failed_amount,
  ROUND(
    100 * SUM(amount) / SUM(SUM(amount)) OVER(),
    2
  ) AS share_of_failed_amount_pct
FROM transactions
WHERE status = 'failed'
GROUP BY stage_failed
ORDER BY failed_amount DESC;

# Revenue Loss by Payment Processor

SELECT
  processor,
  ROUND(SUM(amount), 2) AS total_amount,
  ROUND(SUM(CASE WHEN status = 'failed' THEN amount ELSE 0 END), 2) AS failed_amount,
  ROUND(
    100 * SUM(CASE WHEN status = 'failed' THEN amount ELSE 0 END) / SUM(amount),
    2
  ) AS failed_amount_rate_pct
FROM transactions
GROUP BY processor
ORDER BY failed_amount DESC;

# Top Merchants by Failed Revenue

SELECT
  merchant_id,
  merchant_segment,
  ROUND(SUM(amount), 2) AS total_amount,
  ROUND(SUM(CASE WHEN status = 'failed' THEN amount ELSE 0 END), 2) AS failed_amount,
  ROUND(
    100 * SUM(CASE WHEN status = 'failed' THEN amount ELSE 0 END) / SUM(amount),
    2
  ) AS failed_amount_rate_pct
FROM transactions
GROUP BY merchant_id, merchant_segment
HAVING failed_amount > 0
ORDER BY failed_amount DESC
LIMIT 15;

# Distribution of Failed Revenue Across Merchants

WITH merchant_failed AS (
  SELECT
    merchant_id,
    SUM(CASE WHEN status = 'failed' THEN amount ELSE 0 END) AS failed_amount
  FROM transactions
  GROUP BY merchant_id
),
ranked AS (
  SELECT
    merchant_id,
    failed_amount,
    ROW_NUMBER() OVER (ORDER BY failed_amount DESC) AS rn
  FROM merchant_failed
)
SELECT
  ROUND(SUM(CASE WHEN rn <= 5 THEN failed_amount ELSE 0 END), 2) AS top_5_failed_amount,
  ROUND(SUM(CASE WHEN rn <= 10 THEN failed_amount ELSE 0 END), 2) AS top_10_failed_amount,
  ROUND(SUM(failed_amount), 2) AS total_failed_amount,
  ROUND(
    100 * SUM(CASE WHEN rn <= 5 THEN failed_amount ELSE 0 END) / SUM(failed_amount),
    2
  ) AS top_5_share_pct,
  ROUND(
    100 * SUM(CASE WHEN rn <= 10 THEN failed_amount ELSE 0 END) / SUM(failed_amount),
    2
  ) AS top_10_share_pct
FROM ranked;
