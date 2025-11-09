/*
Trend in Website Sessions and Order Volume
------------------------------------------------------

Purpose:
Analyze the month-over-month trend in total website sessions and total orders
to understand overall growth patterns and user engagement over time.
*/

SELECT strftime('%Y-%m', ws.created_at) AS year_month,
       COUNT(ws.website_session_id) AS session_count,
       COUNT(o.order_id) AS order_count
  FROM website_sessions ws
       LEFT JOIN
       orders o ON ws.website_session_id = o.website_session_id
 GROUP BY year_month;
