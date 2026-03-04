.open fittrackpro.db
.mode column

-- 2.1 
INSERT INTO payments(member_id, amount, payment_method, payment_type)   -- No payment_date included as the schema fills CURRENT_TIMESTAMP by default
VALUES (11, 50.00, 'Credit Card', 'Monthly membership fee');    

-- 2.2 
SELECT strftime('%Y-%m', payment_date) AS month,    -- strftime converts full date into yyyy-mm format
    SUM(amount) AS total_revenue
FROM payments
WHERE payment_type = 'Monthly membership fee'
    AND payment_date BETWEEN '2024-11-01' AND '2025-02-28'
GROUP BY strftime('%Y-%m', payment_date)
ORDER BY month;


-- 2.3 
SELECT payment_id, amount, payment_date, payment_method
FROM payments
WHERE payment_type = 'Day pass';
