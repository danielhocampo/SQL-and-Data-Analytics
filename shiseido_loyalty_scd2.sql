/*
===============================================================================
Customer Loyalty Tier Tracking: Deduplication & SCD Type 2 Architecture
===============================================================================
Author: Daniel Ocampo
Date Version: 2026-06-19
Database: Google BigQuery / PostgreSQL
Description: 
This script processes raw, messy customer loyalty data from a retail mobile app. 
It first removes duplicate webhook triggers, then constructs a Slowly Changing 
Dimension (SCD) Type 2 table to historically track customer loyalty tier 
upgrades/downgrades over time.

Business Context (e.g., Shiseido Omnichannel):
Marketing teams need to know exactly WHICH loyalty tier a customer was in at the 
time of a specific purchase. Overwriting their old tier destroys historical 
conversion metrics. This pipeline ensures we maintain a perfect historical record.
===============================================================================
*/

WITH Deduplicated_App_Data AS (
    -- 1. Deduplication using Window Functions
    -- Mobile app APIs often misfire and send the same event payload twice.
    -- We use ROW_NUMBER() to isolate the first instance of each status change.
    SELECT 
        customer_id,
        loyalty_tier,
        change_timestamp,
        source_system
    FROM (
        SELECT 
            customer_id,
            loyalty_tier,
            change_timestamp,
            source_system,
            ROW_NUMBER() OVER(
                PARTITION BY customer_id, loyalty_tier, CAST(change_timestamp AS DATE) 
                ORDER BY change_timestamp ASC
            ) as event_rank
        FROM 
            stg_mobile_app_loyalty_events
    ) raw_events
    WHERE event_rank = 1
),

SCD2_Date_Calculations AS (
    -- 2. Building the SCD Type 2 Logic
    -- Using LEAD() to calculate the exact millisecond a loyalty tier expired
    -- by looking at the start date of their NEXT tier.
    SELECT 
        customer_id,
        loyalty_tier,
        change_timestamp AS valid_from,
        LEAD(change_timestamp) OVER(
            PARTITION BY customer_id 
            ORDER BY change_timestamp ASC
        ) AS next_tier_timestamp
    FROM 
        Deduplicated_App_Data
)

-- 3. Final Production Table Output
-- Formatting the valid_to dates for active vs. historical records
SELECT 
    customer_id,
    loyalty_tier,
    valid_from,
    -- If next_tier_timestamp is NULL, it means this is their current, active tier.
    -- We assign a far-future proxy date (9999-12-31) to indicate it is currently active.
    COALESCE(
        next_tier_timestamp - INTERVAL '1 second', 
        CAST('9999-12-31 23:59:59' AS TIMESTAMP)
    ) AS valid_to,
    CASE 
        WHEN next_tier_timestamp IS NULL THEN TRUE 
        ELSE FALSE 
    END AS is_active_tier
FROM 
    SCD2_Date_Calculations
ORDER BY 
    customer_id, 
    valid_from ASC;
