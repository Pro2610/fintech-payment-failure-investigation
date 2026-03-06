Overall Revenue Loss from Failed Transactions

SELECT
  ROUND(SUM(amount), 2) AS total_amount,
  ROUND(SUM(CASE WHEN status = 'failed' THEN amount ELSE 0 END), 2) AS failed_amount,
  ROUND(
    100 * SUM(CASE WHEN status = 'failed' THEN amount ELSE 0 END) / SUM(amount),
    2
  ) AS failed_amount_share_pct
FROM transactions;
