/*
Revenue Per Order and Per Session Trends
------------------------------------------------------

Purpose:
Determine how both average order value (AOV) and revenue per session have evolved over time to understand if customers are spending more per purchase and if the website is monetizing visits more effectively.
*/

WITH orders_by_month AS (
    SELECT strftime('%Y-%m', created_at) AS year_month,
           SUM(price_usd) AS total_revenue,
           SUM(price_usd - cogs_usd) AS total_gross_margin,
           COUNT(order_id) AS num_orders,
           AVG(price_usd) AS avg_order_value,
           AVG(price_usd - cogs_usd) AS avg_gross_margin_per_order
      FROM orders
     GROUP BY year_month
),
sessions_by_month AS (
    SELECT strftime('%Y-%m', created_at) AS year_month,
           COUNT(website_session_id) AS num_sessions
      FROM website_sessions
     GROUP BY year_month
)
SELECT sbm.year_month,
       obm.num_orders,
       sbm.num_sessions,
       ROUND(obm.total_revenue, 2) AS total_revenue,
       ROUND(obm.avg_order_value, 2) AS avg_order_value,
       ROUND((obm.total_revenue * 1.0 / sbm.num_sessions), 2) AS revenue_per_session,
       ROUND(obm.total_gross_margin, 2) AS total_gross_margin,
       ROUND(obm.avg_gross_margin_per_order, 2) AS avg_gross_margin_per_order,
       ROUND((obm.total_gross_margin * 1.0 / sbm.num_sessions), 2) AS gross_margin_per_session
  FROM sessions_by_month sbm
       LEFT JOIN
       orders_by_month obm ON sbm.year_month = obm.year_month
 ORDER BY sbm.year_month;
