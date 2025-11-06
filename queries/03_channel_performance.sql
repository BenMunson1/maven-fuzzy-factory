/*
Best Performing Marketing Channels
------------------------------------------------------

Purpose:
Determine which marketing channels drive the most valuable traffic, including sessions, orders, conversion efficiency, and revenue impact.
*/

WITH channel_performance AS (
     SELECT 
          CASE WHEN ws.utm_source = 'NULL' THEN 'Direct / Organic' ELSE ws.utm_source END AS channel,
          COUNT(DISTINCT ws.website_session_id) AS session_count,
          COUNT(DISTINCT o.order_id) AS order_count,
          AVG(o.price_usd) AS avg_order_value,
          SUM(o.price_usd) AS total_revenue
      FROM 
          website_sessions ws
      LEFT JOIN
          orders o ON ws.website_session_id = o.website_session_id
      GROUP BY 
          channel
)
SELECT  
    channel, 
    session_count, 
    order_count, 
    ROUND((order_count * 1.0 / session_count) * 100, 2) AS conversion_rate,
    ROUND(avg_order_value, 2) AS avg_order_value,
    ROUND((total_revenue * 1.0 / session_count), 2) AS revenue_per_session
FROM 
    channel_performance
ORDER BY 
    session_count DESC;
