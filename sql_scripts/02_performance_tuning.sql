-- Add Index to the orders_dataset table
ALTER TABLE orders_dataset ADD INDEX idx_order (order_id);

-- Add Index to order_items_dataset table
ALTER TABLE order_items_dataset ADD INDEX idx_item_order (order_id);
ALTER TABLE order_items_dataset ADD INDEX idx_item_product (product_id);

-- Add Index to products_dataset table
ALTER TABLE products_dataset ADD INDEX idx_prod_id (product_id);
ALTER TABLE products_dataset ADD INDEX idx_prod_category (product_category_name);

-- Add Index to category_translation table
ALTER TABLE category_translation ADD INDEX idx_trans_category (product_category_name);