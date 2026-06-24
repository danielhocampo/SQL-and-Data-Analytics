# Enterprise Data Architecture & Analytics Portfolio 
 
Welcome to my portfolio! I am a data professional specializing in data pipeline optimization, governance, and enterprise analytics. The technical frameworks I build, such as automated data quality profiling, historical dimension tracking, and financial automation, are highly scalable and industry-agnostic. My core focus is bridging the gap between complex technical architecture and actionable business intelligence.

**JP:** 私のポートフォリオへようこそ！私はデータパイプラインの最適化、データ品質管理、そしてエンタープライズ分析を専門とするデータプロフェッショナルです。私が構築する技術的フレームワーク（データ品質の自動チェック、履歴データの管理、財務レポートの自動化など）は、高い拡張性を持ち、あらゆる業界に応用可能です。複雑な技術アーキテクチャと、ビジネスで実際に使えるデータの架け橋となることに注力しています。

---

## 📁 Project 1: Automated Data Quality Profiler / データ品質の自動チェック
**File:** `data_quality_profiler.sql`

**Business Context (ビジネス背景)**
In omnichannel retail, raw transactional data is rarely perfectly clean. If dirty data reaches the reporting layer, it leads to inaccurate financial reporting and poor inventory decisions.

**JP:** 小売業のローデータ（アプリや店舗のデータ）には、エラーが入っていることが多いです。間違ったデータがダッシュボードに入ると、売上や在庫の計算が合わなくなってしまいます。

**Technical Implementation (技術的アプローチ)**
Designed an automated QA pipeline running in the staging layer of a Data Warehouse. The script uses Window Functions to execute completeness, uniqueness, and business logic checks before data passes to production dashboards.

**JP:** データウェアハウス（PostgreSQL / BigQuery）で自動チェック機能を作りました。SQLのWindow関数を使って、データの重複、空白（Null）、またはビジネスルールの間違いをBIツールに送る前に見つけます。

**Data Transformation Showcase**

*Input (Raw Staging Data with Errors):*
| transaction_id | customer_id | item_price | transaction_timestamp |
| :--- | :--- | :--- | :--- |
| T-001 | C-101 | 50.00 | 2026-06-01 10:00:00 |
| T-002 | NULL | 25.00 | 2026-06-01 11:30:00 | *(Missing ID)*
| T-003 | C-102 | -10.00| 2026-06-02 09:15:00 | *(Negative Price)*
| T-001 | C-101 | 50.00 | 2026-06-01 10:00:00 | *(Duplicate)*

*Output (Automated QA Report):*
| total_transactions | null_customer_ids | duplicate_records | negative_price_errors | overall_data_health_status |
| :--- | :--- | :--- | :--- | :--- |
| 4 | 1 | 1 | 1 | **FAIL: Immediate Action Required** |

---

## 📁 Project 2: Omnichannel Loyalty Tracking (SCD Type 2) / 顧客ランクの履歴管理
**File:** `shiseido_loyalty_scd2.sql`

**Business Context (ビジネス背景)**
Marketing teams need to know exactly *which* loyalty tier a customer was in at the time of a specific purchase. Overwriting a customer's old tier with their new tier destroys historical conversion metrics.

**JP:** マーケティングチームは、顧客が商品を買った時の「会員ランク」を正確に知る必要があります。古いデータを新しいデータで上書きしてしまうと、過去の履歴が消えてしまいます。

**Technical Implementation (技術的アプローチ)**
Built a robust pipeline to process raw mobile app webhook data. Utilized `ROW_NUMBER()` to remove duplicate API triggers, and engineered Slowly Changing Dimensions (SCD Type 2) using the `LEAD()` function to maintain a perfect historical record.

**JP:** モバイルアプリのデータ処理パイプラインを作りました。`ROW_NUMBER()`を使ってAPIの重複エラーを消しました。そして、`LEAD()`を使って「SCD Type 2」を作り、顧客のランクがいつ変わったかを正確に記録できるようにしました。

**Data Transformation Showcase**

*Input (Raw Messy App Data with Duplicates):*
| customer_id | loyalty_tier | change_timestamp |
| :--- | :--- | :--- |
| C-888 | Silver | 2026-05-01 10:00:00 |
| C-888 | Silver | 2026-05-01 10:00:00 | *(API Duplicate Trigger)*
| C-888 | Gold | 2026-06-15 14:30:00 |

*Output (Clean SCD Type 2 History):*
| customer_id | loyalty_tier | valid_from | valid_to | is_active_tier |
| :--- | :--- | :--- | :--- | :--- |
| C-888 | Silver | 2026-05-01 10:00:00 | 2026-06-15 14:29:59 | FALSE |
| C-888 | Gold | 2026-06-15 14:30:00 | 9999-12-31 23:59:59 | TRUE |

---

## 📁 Project 3: Automated MoM Financial Reporting / 月次売上成長率（MoM）の自動レポート
**File:** `mom_financial_growth.sql`

**Business Context (ビジネス背景)**
Merchandising and Finance teams require automated tracking of monthly sales performance. Manual Excel calculations are prone to human error and are not scalable.

**JP:** マーチャンダイジングチームと財務チームは、毎月の売上の変化をチェックする必要があります。Excelの手作業はミスが起きやすく、時間もかかります。

**Technical Implementation (技術的アプローチ)**
Utilized the `LAG()` window function to calculate Month-over-Month (MoM) revenue growth directly within the Data Warehouse. This eliminates the need for expensive self-joins and ensures BI dashboards have pre-calculated metrics.

**JP:** データウェアハウスの中で `LAG()` 関数を使って、前月比（MoM）の売上成長率を計算しました。これにより、BIツール（Tableau / Power BI）に自動で正しいデータが送られます。

**Data Transformation Showcase**

*Input (Aggregated Monthly Sales):*
| sales_month | total_revenue |
| :--- | :--- |
| 2026-04-01 | $100,000 |
| 2026-05-01 | $150,000 |
| 2026-06-01 | $120,000 |

*Output (Automated MoM Growth Metrics):*
| sales_month | total_revenue | prev_month_revenue | mom_growth_percentage |
| :--- | :--- | :--- | :--- |
| 2026-06-01 | $120,000 | $150,000 | -20.00% |
| 2026-05-01 | $150,000 | $100,000 | +50.00% |
| 2026-04-01 | $100,000 | NULL | 0.00% |

---
*Technical Stack: PostgreSQL, Google BigQuery, Advanced SQL, Data Modeling*
