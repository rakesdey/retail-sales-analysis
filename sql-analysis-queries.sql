SELECT COUNT(*) FROM customers;
SELECT COUNT(*) FROM products;
SELECT COUNT(*) FROM orders;

-- FK integrity check
SELECT COUNT(*) FROM orders o 
LEFT JOIN customers c ON o.customer_id = c.customer_id 
WHERE c.customer_id IS NULL;
-- eta 0 ashar kotha, na hole orphan orders ache




SELECT 
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(sales)::numeric, 2) AS total_sales,
    ROUND(SUM(profit)::numeric, 2) AS total_profit,
    ROUND((SUM(profit) / SUM(sales) * 100)::numeric, 2) AS overall_margin_pct
FROM orders;


-- Top 10 profitable products
SELECT p.product_name, p.category, p.sub_category,
       ROUND(SUM(o.profit)::numeric, 2) AS total_profit,
       ROUND(SUM(o.sales)::numeric, 2) AS total_sales
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY p.product_name, p.category, p.sub_category
ORDER BY total_profit DESC
LIMIT 10;


-- Bottom 10 (biggest losses)
SELECT p.product_name, p.category, p.sub_category,
       ROUND(SUM(o.profit)::numeric, 2) AS total_profit,
       ROUND(SUM(o.sales)::numeric, 2) AS total_sales
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY p.product_name, p.category, p.sub_category
ORDER BY total_profit ASC
LIMIT 10;




WITH monthly_sales AS (
    SELECT 
        DATE_TRUNC('month', order_date) AS month,
        ROUND(SUM(sales)::numeric, 2) AS monthly_sales
    FROM orders
    GROUP BY DATE_TRUNC('month', order_date)
)
SELECT 
    month,
    monthly_sales,
    LAG(monthly_sales) OVER (ORDER BY month) AS prev_month_sales,
    ROUND(
        ((monthly_sales - LAG(monthly_sales) OVER (ORDER BY month)) 
        / LAG(monthly_sales) OVER (ORDER BY month) * 100)::numeric, 2
    ) AS mom_growth_pct
FROM monthly_sales
ORDER BY month;




SELECT c.segment,
       COUNT(DISTINCT o.order_id) AS num_orders,
       ROUND(SUM(o.sales)::numeric, 2) AS total_sales,
       ROUND(SUM(o.profit)::numeric, 2) AS total_profit,
       ROUND((SUM(o.profit) / SUM(o.sales) * 100)::numeric, 2) AS margin_pct
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.segment
ORDER BY total_profit DESC;




SELECT 
    CASE 
        WHEN discount = 0 THEN '0%'
        WHEN discount <= 0.10 THEN '1-10%'
        WHEN discount <= 0.20 THEN '11-20%'
        WHEN discount <= 0.30 THEN '21-30%'
        ELSE '30%+'
    END AS discount_bucket,
    COUNT(*) AS num_orders,
    ROUND(AVG(profit_margin_pct)::numeric, 2) AS avg_margin_pct,
    ROUND(SUM(profit)::numeric, 2) AS total_profit
FROM orders
GROUP BY discount_bucket
ORDER BY discount_bucket;




SELECT 
    region,
    ROUND(SUM(profit)::numeric, 2) AS total_profit,
    RANK() OVER (ORDER BY SUM(profit) DESC) AS profit_rank,
    DENSE_RANK() OVER (ORDER BY SUM(profit) DESC) AS profit_dense_rank
FROM orders
GROUP BY region;