/*
New vs Returning Visitors — Conversion Comparison
------------------------------------------------------------

Purpose:
Evaluate whether returning visitors are more likely to make a purchase than first-time visitors.  
Understanding this helps assess marketing effectiveness, customer loyalty, and opportunities 
to improve retention strategies.
*/

WITH sessions_classified AS (
    SELECT ws.website_session_id,
           ws.is_repeat_session,
           CASE WHEN o.order_id IS NOT NULL THEN 1 ELSE 0 END AS placed_order
      FROM website_sessions ws
           LEFT JOIN
           orders o ON ws.website_session_id = o.website_session_id
)
SELECT CASE WHEN is_repeat_session = 1 THEN 'Returning Visitor' ELSE 'New Visitor' END AS visitor_type,
       COUNT(DISTINCT website_session_id) AS session_count,
       SUM(placed_order) AS order_count,
       ROUND(100.0 * SUM(placed_order) / COUNT(DISTINCT website_session_id), 2) AS conversion_rate_pct
  FROM sessions_classified
 GROUP BY visitor_type
 ORDER BY conversion_rate_pct DESC;

-- Interpretation:
-- This query compares conversion rates between new and returning visitors. 
-- Typically, returning visitors show a higher conversion rate — indicating stronger purchase intent or brand trust.  
-- This insight can guide marketing and retention strategies, such as retargeting campaigns or loyalty programs aimed at maximizing repeat customer value.
