auth vs capture vs settlement

SELECT
  stage_failed,
  COUNT(*) AS failed_tx,
  ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER(), 2) AS share_of_failed_pct
FROM transactions
WHERE status = 'failed'
GROUP BY stage_failed
ORDER BY failed_tx DESC;

PROCESSOR PERFORMANCE

SELECT
  processor,
  COUNT(*) AS total_tx,
  SUM(CASE WHEN status='failed' THEN 1 ELSE 0 END) AS failed_tx,
  ROUND(100.0 * SUM(CASE WHEN status='failed' THEN 1 ELSE 0 END) / COUNT(*), 2) AS fail_rate_pct
FROM transactions
GROUP BY processor
ORDER BY fail_rate_pct DESC;

PAYMENT METHOD RISK

SELECT
  payment_method,
  COUNT(*) AS total_tx,
  SUM(CASE WHEN status='failed' THEN 1 ELSE 0 END) AS failed_tx,
  ROUND(100.0 * SUM(CASE WHEN status='failed' THEN 1 ELSE 0 END) / COUNT(*), 2) AS fail_rate_pct
FROM transactions
GROUP BY payment_method
ORDER BY fail_rate_pct DESC;

FAILURE REASONS

SELECT
  failure_reason,
  COUNT(*) AS failed_tx
FROM transactions
WHERE status='failed'
GROUP BY failure_reason
ORDER BY failed_tx DESC;
