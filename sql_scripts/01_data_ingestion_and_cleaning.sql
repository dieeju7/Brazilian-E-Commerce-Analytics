CREATE DATABASE olist_ecommerce;
USE olist_ecommerce;

SHOW VARIABLES LIKE 'secure_file_priv';

CREATE TABLE orders_dataset (
    order_id VARCHAR(50),
    customer_id VARCHAR(50),
    order_status VARCHAR(20),

    order_purchase_timestamp VARCHAR(50), 
    order_approved_at VARCHAR(50),
    order_delivered_carrier_date VARCHAR(50),
    order_delivered_customer_date VARCHAR(50),
    order_estimated_delivery_date VARCHAR(50)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_orders_dataset.csv'
INTO TABLE orders_dataset 
FIELDS TERMINATED BY ','  
ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS;

SELECT * FROM orders_dataset LIMIT 10;


CREATE TABLE customers_dataset (
    customer_id VARCHAR(50),
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix VARCHAR(10),
    customer_city VARCHAR(50),
    customer_state VARCHAR(5)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_customers_dataset.csv'
INTO TABLE customers_dataset 
FIELDS TERMINATED BY ','  
ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS;



CREATE TABLE order_items_dataset (
    order_id VARCHAR(50),
    order_item_id INT,
    product_id VARCHAR(50),
    seller_id VARCHAR(50),
    shipping_limit_date VARCHAR(50),
    price DECIMAL(10,2),
    freight_value DECIMAL(10,2)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_order_items_dataset.csv'
INTO TABLE order_items_dataset 
FIELDS TERMINATED BY ','  
ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS;


CREATE TABLE products_dataset (
    product_id VARCHAR(50),
    product_category_name VARCHAR(50),
    product_name_lenght INT,
    product_description_lenght INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_products_dataset.csv'
INTO TABLE products_dataset 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS

(product_id, product_category_name, @v_name_len, @v_desc_len, @v_photos, @v_weight, @v_length, @v_height, @v_width)

SET
    product_name_lenght = NULLIF(@v_name_len, ''),
    product_description_lenght = NULLIF(@v_desc_len, ''),
    product_photos_qty = NULLIF(@v_photos, ''),
    product_weight_g = NULLIF(@v_weight, ''),
    product_length_cm = NULLIF(@v_length, ''),
    product_height_cm = NULLIF(@v_height, ''),
    product_width_cm = NULLIF(@v_width, '');
    
    
    
CREATE TABLE category_translation (
    product_category_name VARCHAR(50),
    product_category_name_english VARCHAR(50)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/product_category_name_translation.csv'
INTO TABLE category_translation 
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

-- Temporarily disable protection mode
SET SQL_SAFE_UPDATES = 0;

-- Run the command to clean up the invisible character (\r)
UPDATE category_translation 
SET product_category_name_english = REPLACE(product_category_name_english, '\r', '');

--  Re-enable protection mode for security
SET SQL_SAFE_UPDATES = 1;