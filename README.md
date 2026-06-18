# Enterprise Data Quality Profiler 

##  Business Context
In omnichannel retail environments, raw transactional data ingested from mobile apps, physical point-of-sale (POS) systems, and e-commerce platforms is rarely perfectly clean. If dirty data (duplicates, missing customer IDs, system glitches resulting in negative prices) reaches the reporting layer, it leads to inaccurate financial reporting and poor inventory decisions.

## The Objective
This project acts as an automated **Data Quality (QA) Pipeline**. Designed to run in the staging layer of a Data Warehouse (PostgreSQL / BigQuery), it profiles incoming raw data and flags anomalies **before** the data is passed to production dashboards (e.g. Power BI / Tableau / Google Looker Studio).

## Technical Implementation
The `data_quality_profiler.sql` script utilizes advanced SQL techniques to execute three main checks:
1. **Completeness**: Flags missing critical identifiers (Customer IDs, Store IDs).
2. **Uniqueness**: Utilizes Window Functions (e.g. `ROW_NUMBER() OVER PARTITION BY`) to detect and isolate duplicate transaction hashes caused by API retry errors.
3. **Business Logic**: Validates data against real-world retail rules (e.g., catching negative transaction amounts or impossible future timestamps).

## Impact
By implementing this automated check, Data Engineering and Business Analytics teams can immediately identify source-system errors, shifting from a reactive data-cleaning approach to a proactive data governance architecture.
