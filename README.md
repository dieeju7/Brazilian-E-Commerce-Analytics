# Brazilian-E-Commerce-Analytics
This project simulates the role of a Data Analyst at Olist, a Brazilian e-commerce platform. Using a real-world dataset of ~100k orders, the objective is to build a robust data pipeline, handle dirty data, and extract actionable business strategies to optimize logistics and boost sales.

---

## The "Behind the Scenes"
Unlike standard tutorial projects, this repository tackles real-world database issues:
* **Data Cleansing on-the-fly:** Used User Variables (`@`) and `NULLIF` during `LOAD DATA INFILE` to seamlessly handle `Incorrect integer value` errors caused by empty strings in numeric columns.
* **Invisible Character Handling:** Resolved logical mismatches in `WHERE` clauses by stripping hidden Windows CRLF (`\r`) characters using `REPLACE()`.
* **Performance Tuning:** Encountered `Error 2013 (Lost connection)` due to massive Full Table Scans during complex multi-joins. Solved by implementing **Foreign Key Indexing**, reducing query execution time from timeout to mere seconds.

---

## Key Business Problems Solved

### 1. Market Penetration Analysis (Descriptive Analytics)
* **Question:** Which regions drive the highest revenue?
* **SQL Techniques:** `JOIN`, `GROUP BY`, Aggregations.
* **Insight:** São Paulo (SP) heavily dominates the market. 
* **Action:** Optimize local fulfillment centers in SP to reduce freight costs while launching targeted marketing in tier-2 states like RJ and MG to capture new growth.

### 2. Product Portfolio Optimization (Advanced Analytics)
* **Question:** What are the core product categories, and what "Hero Products" should we always keep in stock?
* **SQL Techniques:** `CTEs`, Window Function `ROW_NUMBER() OVER(PARTITION BY...)`.
* **Insight:** Extracted the Top 3 best-selling SKUs within the top 5 high-demand categories (e.g., bed_bath_table, health_beauty). 
* **Action:** Apply the 80/20 rule to maintain safety stock for these specific SKUs, preventing stockouts for highest-converting items.

### 3. Intraday Sales Pacing & Automated OP Alerts (Prescriptive Analytics)
* **Question:** How can we ensure we hit today's sales target, and how do we proactively fix it if we are falling behind?
* **SQL Techniques:** `CTEs`, `EXTRACT()`, Window Function `SUM() OVER()`, Data Pivoting, and `CASE WHEN` rule engines.
* **Action:** Built a cumulative hourly tracker comparing 'Today's Revenue' against the 'Twin Day'. If the current revenue falls more than 10% behind the Twin Day after 10 AM, the query generates an `ALERT` status for the Operation Team.
