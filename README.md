# Brazilian E-Commerce Analytics

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

<p align="center">
  <img width="234" height="187" alt="image" src="https://github.com/user-attachments/assets/12855cae-7dc8-40c8-bd7a-e8fb50a16623" />
</p>

* **Insight:** São Paulo (SP) heavily dominates the market. 
* **Action:** Optimize local fulfillment centers in SP to reduce freight costs while launching targeted marketing in tier-2 states like RJ and MG to capture new growth.

---

### 2. Product Portfolio Optimization (Advanced Analytics)
* **Question:** What are the core product categories, and what "Hero Products" should we always keep in stock?
* **SQL Techniques:** `CTEs`, Window Function `ROW_NUMBER() OVER(PARTITION BY...)`.

<p align="center">
  <img width="338" height="104" alt="image" src="https://github.com/user-attachments/assets/59d6f9a7-fd06-4e9b-b6b1-59e75885063c" />
  <br><em>The Core Categories</em>
</p>

<p align="center">
  <img width="576" height="276" alt="image" src="https://github.com/user-attachments/assets/7340cb76-b409-45ee-a921-61ec37b16d7f" />
  <br><em>The "Hero Products" per Category</em>
</p>
  
* **Insight:** Extracted the Top 3 best-selling SKUs within the top 5 high-demand categories (e.g., bed_bath_table, health_beauty). 
* **Action:** Apply the 80/20 rule to maintain safety stock for these specific SKUs, preventing stockouts for highest-converting items.

---

### 3. Intraday Sales Pacing (Twin Sales Tracking)
* **Question:** How can we track intraday sales performance to ensure we hit today's target compared to the exact same day last year (Twin Day)?
* **SQL Techniques:** `CTEs`, `EXTRACT()`, Window Function `SUM() OVER()`, and Data Pivoting using `MAX(CASE WHEN...)`.

<p align="center">
  <img width="391" height="411" alt="image" src="https://github.com/user-attachments/assets/cb9ae81b-747b-4016-900f-5d740e9b3418" />
  <br><em>Compared with Twin Sales from last year</em>
</p>

* **Insight:** Instead of waiting until the end of the day to see if targets were met (a lagging indicator), the `Revenue_Gap` metric acts as an early warning system, revealing exactly at which hour the sales momentum starts to dip compared to historical baselines.
* **Action:** Built a cumulative hourly tracking model. By shifting the historical date by exactly 52 weeks (-364 days) to align the day of the week, this query pivots the data to compare 'Today's Revenue' and 'Twin Day Revenue' side-by-side. The Commercial team and the Operation team can use this to monitor pacing hour-by-hour.
