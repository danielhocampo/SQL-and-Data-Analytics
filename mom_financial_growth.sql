/*
===============================================================================
Financial Analytics: Month-over-Month (MoM) Revenue Growth
===============================================================================
Author: Daniel Ocampo
Date: 2026-06-19
Database: PostgreSQL / Google BigQuery
Description: 
This script calculates total monthly revenue and computes the Month-over-Month 
(MoM) growth percentage. It utilizes the LAG() window function to compare 
current row revenue against the previous month's revenue without self-joining.

Business Context: 
Merchandising and Finance teams require automated tracking of monthly sales 
performance to evaluate the success of marketing campaigns and seasonal inventory 
drops. This pipeline replaces manual Excel calculations with automated SQL logic.
===============================================================================
*/

WITH Monthly_Revenue AS (
    -- 1. Aggregate daily transactional data into monthly buckets
    SELECT 
        DATE_TRUNC('month', transaction_date) AS sales_month,
        SUM(sales_amount) AS total_revenue
    FROM 
        fct_sales
    WHERE 
        status = 'Completed'
    GROUP BY 
        DATE_TRUNC('month', transaction_date)
),

MoM_Calculation AS (
    -- 2. Use LAG() to fetch the previous month's revenue for comparison
    SELECT 
        sales_month,
        total_revenue,
        LAG(total_revenue) OVER(ORDER BY sales_month ASC) AS prev_month_revenue
    FROM 
        Monthly_Revenue
)

-- 3. Calculate the Growth Percentage safely (handling divide-by-zero)
SELECT 
    sales_month,
    total_revenue,
    prev_month_revenue,
    CASE 
        WHEN prev_month_revenue IS NULL THEN 0 -- First month has no previous data
        WHEN prev_month_revenue = 0 THEN NULL  -- Prevent division by zero
        ELSE ROUND(((total_revenue - prev_month_revenue) / prev_month_revenue) * 100, 2)
    END AS mom_growth_percentage
FROM 
    MoM_Calculation
ORDER BY 
    sales_month DESC;
