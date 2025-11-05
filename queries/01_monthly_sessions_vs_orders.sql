/*
Trend in Website Sessions and Order Volume
------------------------------------------------------

Purpose:
Analyze the month-over-month trend in total website sessions and total orders
to understand overall growth patterns and user engagement over time.
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
       COALESCE(octe.order_count, 0) AS order_count
  FROM scte
       LEFT JOIN
       octe ON scte.year_month = octe.year_month
 ORDER BY scte.year_month;
