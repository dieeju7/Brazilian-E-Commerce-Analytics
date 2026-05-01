SELECT 
    c.customer_state AS State,
    COUNT(DISTINCT o.order_id) AS Total_Orders,
    ROUND(SUM(oi.price), 2) AS Total_Revenue
FROM orders_dataset o
JOIN customers_dataset c 
    ON o.customer_id = c.customer_id
JOIN order_items_dataset oi 
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state
ORDER BY Total_Revenue DESC
LIMIT 10;


--- THE FOCUS
SELECT 
    t.product_category_name_english AS Category_Name,
    COUNT(oi.order_item_id) AS Total_Items_Sold,
    ROUND(SUM(oi.price), 2) AS Total_Revenue
FROM order_items_dataset oi
JOIN orders_dataset o 
    ON oi.order_id = o.order_id
JOIN products_dataset p 
    ON oi.product_id = p.product_id
JOIN category_translation t 
    ON p.product_category_name = t.product_category_name
WHERE o.order_status = 'delivered'
GROUP BY t.product_category_name_english
ORDER BY Total_Items_Sold DESC
LIMIT 5;



--- THE HERO PRODUCT
WITH ProductSales AS (
    -- Step A: Calculate the total sales quantity of each product code
    SELECT 
        t.product_category_name_english AS Category,
        oi.product_id,
        COUNT(oi.order_item_id) AS Quantity_Sold,
        ROUND(SUM(oi.price), 2) AS Revenue
    FROM order_items_dataset oi
    JOIN orders_dataset o ON oi.order_id = o.order_id
    JOIN products_dataset p ON oi.product_id = p.product_id
    JOIN category_translation t ON p.product_category_name = t.product_category_name
    WHERE o.order_status = 'delivered'
    GROUP BY t.product_category_name_english, oi.product_id
),
RankedProducts AS (
    -- Step B: Rate the product (1, 2, 3...) by sales quantity IN EACH CATEGORY
    SELECT 
        Category,
        product_id,
        Quantity_Sold,
        Revenue,
        ROW_NUMBER() OVER(PARTITION BY Category ORDER BY Quantity_Sold DESC) as Sales_Rank
    FROM ProductSales
)
-- Step C: Only get the Top 3 best-selling products from the 5 hottest categories
SELECT * FROM RankedProducts
WHERE Sales_Rank <= 3 
  AND Category IN ('bed_bath_table', 'health_beauty', 'sports_leisure', 'furniture_decor', 'computers_accessories')
ORDER BY Category, Sales_Rank;



-- CTE 1: Define the target date (Today) and its exact counterpart from last year (Twin Day - exactly 52 weeks ago)
WITH TwinDates AS (
    SELECT 
        '2018-05-15' AS target_date,
        DATE_ADD('2018-05-15', INTERVAL -364 DAY) AS twin_date
),

-- CTE 2: Calculate total revenue per hour for both the target date and the twin date
HourlySales AS (
    SELECT 
        DATE(o.order_purchase_timestamp) AS sale_date,
        EXTRACT(HOUR FROM o.order_purchase_timestamp) AS sale_hour,
        ROUND(SUM(oi.price), 2) AS revenue
    FROM orders_dataset o
    JOIN order_items_dataset oi ON o.order_id = oi.order_id
    WHERE DATE(o.order_purchase_timestamp) IN (SELECT target_date FROM TwinDates UNION SELECT twin_date FROM TwinDates)
      AND o.order_status = 'delivered'
    GROUP BY sale_date, sale_hour
),

-- CTE 3: Calculate the running total (cumulative revenue) from hour 0 to the current hour
CumulativeSales AS (
    SELECT 
        sale_date,
        sale_hour,
        SUM(revenue) OVER(PARTITION BY sale_date ORDER BY sale_hour) AS cumulative_revenue
    FROM HourlySales
)

-- FINAL STEP: Pivot the data to display 'Twin Day' and 'Today' revenues side-by-side for direct comparison
SELECT 
    sale_hour AS Hour_of_Day,
    
    -- Extract cumulative revenue for the Twin Day (Last Year)
    ROUND(MAX(CASE WHEN sale_date = (SELECT twin_date FROM TwinDates) THEN cumulative_revenue ELSE 0 END), 2) AS Twin_Day_Revenue,
    
    -- Extract cumulative revenue for Today
    ROUND(MAX(CASE WHEN sale_date = (SELECT target_date FROM TwinDates) THEN cumulative_revenue ELSE 0 END), 2) AS Today_Revenue,
    
    -- Calculate the performance gap (Positive = Ahead of target, Negative = Behind target)
    ROUND(
        MAX(CASE WHEN sale_date = (SELECT target_date FROM TwinDates) THEN cumulative_revenue ELSE 0 END) - 
        MAX(CASE WHEN sale_date = (SELECT twin_date FROM TwinDates) THEN cumulative_revenue ELSE 0 END)
    , 2) AS Revenue_Gap

FROM CumulativeSales
GROUP BY sale_hour
ORDER BY sale_hour;