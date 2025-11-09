/*
Session-to-Order Conversion Rate Trend
------------------------------------------------------------

Purpose:
Determine how effectively website sessions convert into customer orders over time, 
and analyze how the conversion rate has trended.
*/

WITH monthly_activity AS (
    SELECT strftime('%Y-%m', ws.created_at) AS year_month,
           COUNT(ws.website_session_id) AS session_count,
           COUNT(o.order_id) AS order_count
      FROM website_sessions ws
           LEFT JOIN
           orders o ON ws.website_session_id = o.website_session_id
     GROUP BY year_month
)
SELECT year_month,
       session_count,
       COALESCE(order_count, 0) AS order_count,
       ROUND((COALESCE(order_count, 0) * 1.0 / session_count) * 100, 2) AS conversion_rate,
       ROUND(AVG((COALESCE(order_count, 0) * 1.0 / session_count) * 100) OVER (ORDER BY year_month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 2) AS rolling_3mo_avg
  FROM monthly_activity
 ORDER BY year_month;
