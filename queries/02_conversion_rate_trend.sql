/*
Session-to-Order Conversion Rate Trend
------------------------------------------------------------

Purpose:
Determine how effectively website sessions convert into customer orders over time, 
and analyze how the conversion rate has trended.
*/

WITH scte AS (
    SELECT strftime('%Y-%m', created_at) AS year_month,
           COUNT(website_session_id) AS session_count
      FROM website_sessions
     GROUP BY year_month
),
octe AS (
    SELECT strftime('%Y-%m', created_at) AS year_month,
           COUNT(order_id) AS order_count
      FROM orders
     GROUP BY year_month
)
SELECT scte.year_month,
       scte.session_count,
       COALESCE(octe.order_count, 0) AS order_count,
       ROUND((COALESCE(octe.order_count, 0) * 1.0 / scte.session_count) * 100, 2) AS conversion_rate
  FROM scte
       LEFT JOIN
       octe ON scte.year_month = octe.year_month
 ORDER BY scte.year_month;
