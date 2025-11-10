/*
Product Performance & Launch Impact
------------------------------------------------------------

Purpose:
Analyze which products are driving revenue each month and how the product mix evolves over time. 
This helps identify top-performing products, shifts in customer demand, 
and the impact of new product launches on overall sales distribution.
*/

WITH monthly_revenue AS (
    SELECT strftime('%Y-%m', o.created_at) AS year_month,
           p.product_name,
           ROUND(SUM(oi.price_usd), 2) AS total_revenue
      FROM order_items oi
           JOIN
           orders o ON oi.order_id = o.order_id
           JOIN
           products p ON oi.product_id = p.product_id
     GROUP BY year_month,
              p.product_name
)
SELECT year_month,
       product_name,
       total_revenue,
       ROUND(100.0 * total_revenue / SUM(total_revenue) OVER (PARTITION BY year_month), 2) AS revenue_share_pct
  FROM monthly_revenue
 ORDER BY year_month,
          total_revenue DESC;
