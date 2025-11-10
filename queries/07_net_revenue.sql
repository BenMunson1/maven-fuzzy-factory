/*
Returns + Net Revenue Analysis
------------------------------------------------------------

Purpose:
Measure how refunds impact total revenue and overall profitability.  
Understanding refund rates and net revenue helps evaluate product quality, 
customer satisfaction, and the business’s true earnings performance.
*/

WITH revenue_and_refunds AS (
    SELECT strftime('%Y-%m', oi.created_at) AS year_month,
           SUM(oi.price_usd) AS gross_revenue,
           SUM(COALESCE(oir.refund_amount_usd, 0) ) AS refund_amount
      FROM order_items oi
           LEFT JOIN
           order_item_refunds oir ON oi.order_item_id = oir.order_item_id
     GROUP BY year_month
)
SELECT year_month,
       ROUND(gross_revenue, 2) AS gross_revenue_usd,
       ROUND(refund_amount, 2) AS refund_amount_usd,
       ROUND((refund_amount * 100.0) / gross_revenue, 2) AS refund_rate_pct,
       ROUND(gross_revenue - refund_amount, 2) AS net_revenue_usd,
       ROUND(((gross_revenue - refund_amount) / gross_revenue) * 100.0, 2) AS net_margin_pct
  FROM revenue_and_refunds
 ORDER BY year_month;


-- Interpretation:
-- This query tracks monthly gross revenue, refund totals, and resulting net revenue.  
-- Refund rate percentage shows what portion of revenue is lost to returns, while net margin percentage indicates the actual kept revenue after refunds. 
-- Consistent or rising refund rates could signal product quality issues or misaligned customer expectations.
