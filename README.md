# Enterprise Data Architecture & Analytics Portfolio 

Welcome to my portfolio! I am a Data Analyst & Business Systems Analyst bridging the gap between retail merchandising strategy and enterprise data architecture. My work focuses on data governance, pipeline optimization, and delivering clean, actionable datasets for business intelligence.

**JP:** 私のポートフォリオへようこそ！私は、小売業のマーチャンダイジング戦略とデータアーキテクチャの架け橋となるデータアナリスト / BSAです。データ品質の管理、パイプラインの最適化、そしてBIツール向けのクリーンなデータセットの提供に注力しています。

---

## 📁 Project 1: Automated Data Quality Profiler / データ品質の自動チェック
**File:** `data_quality_profiler.sql`

**Business Context (ビジネス背景)**
**EN:** In omnichannel retail, raw transactional data is rarely perfectly clean. If dirty data reaches the reporting layer, it leads to inaccurate financial reporting and poor inventory decisions.
**JP:** 小売業のローデータ（アプリや店舗のデータ）には、エラーが入っていることが多いです。間違ったデータがダッシュボードに入ると、売上や在庫の計算が合わなくなってしまいます。

**Technical Implementation (技術的アプローチ)**
**EN:** Designed an automated QA pipeline running in the staging layer of a Data Warehouse. The script uses Window Functions to execute completeness, uniqueness, and business logic checks before data passes to production dashboards.
**JP:** データウェアハウス（PostgreSQL / BigQuery）で自動チェック機能を作りました。SQLのWindow関数を使って、データの重複、空白（Null）、またはビジネスルールの間違いをBIツールに送る前に見つけます。

---

## 📁 Project 2: Omnichannel Loyalty Tracking (SCD Type 2) / 顧客ランクの履歴管理
**File:** `shiseido_loyalty_scd2.sql`

**Business Context (ビジネス背景)**
**EN:** Marketing teams need to know exactly *which* loyalty tier a customer was in at the time of a specific purchase. Overwriting a customer's old tier with their new tier destroys historical conversion metrics. 
**JP:** マーケティングチームは、顧客が商品を買った時の「会員ランク」を正確に知る必要があります。古いデータを新しいデータで上書きしてしまうと、過去の履歴が消えてしまいます。

**Technical Implementation (技術的アプローチ)**
**EN:** Built a robust pipeline to process raw mobile app webhook data. Utilized `ROW_NUMBER()` to remove duplicate API triggers, and engineered Slowly Changing Dimensions (SCD Type 2) using the `LEAD()` function to maintain a perfect historical record.
**JP:** モバイルアプリのデータ処理パイプラインを作りました。`ROW_NUMBER()`を使ってAPIの重複エラーを消しました。そして、`LEAD()`を使って「SCD Type 2」を作り、顧客のランクがいつ変わったかを正確に記録できるようにしました。

---

## 📁 Project 3: Automated MoM Financial Reporting / 月次売上成長率（MoM）の自動レポート
**File:** `mom_financial_growth.sql`

**Business Context (ビジネス背景)**
**EN:** Merchandising and Finance teams require automated tracking of monthly sales performance. Manual Excel calculations are prone to human error and are not scalable.
**JP:** マーチャンダイジングチームと財務チームは、毎月の売上の変化をチェックする必要があります。Excelの手作業はミスが起きやすく、時間もかかります。

**Technical Implementation (技術的アプローチ)**
**EN:** Utilized the `LAG()` window function to calculate Month-over-Month (MoM) revenue growth directly within the Data Warehouse. This eliminates the need for expensive self-joins and ensures BI dashboards have pre-calculated metrics.
**JP:** データウェアハウスの中で `LAG()` 関数を使って、前月比（MoM）の売上成長率を計算しました。これにより、BIツール（Tableau / Power BI）に自動で正しいデータが送られます。

---
*Technical Stack: PostgreSQL, Google BigQuery, Advanced SQL, Data Modeling*
