-- Total transactions
SELECT COUNT(*) AS total_transactions
FROM transactions;

-- Overall success vs failed
SELECT
    status,
    COUNT(*) AS transactions,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER(), 2) AS percent
FROM transactions
GROUP BY status;

-- Transactions by payment method
SELECT
    payment_method,
    COUNT(*) AS total
FROM transactions
GROUP BY payment_method
ORDER BY total DESC;

-- Fail rate by payment method
SELECT
    payment_method,
    COUNT(*) AS total,
    SUM(CASE WHEN status='failed' THEN 1 ELSE 0 END) AS failed,
    ROUND(
        100.0 * SUM(CASE WHEN status='failed' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS fail_rate_pct
FROM transactions
GROUP BY payment_method
ORDER BY fail_rate_pct DESC;
