-- Question 1 🛠️ Achieving 1NF (First Normal Form)
-- In this query, we split the Products column into individual rows.
-- We assume that the table ProductDetail is named 'product_details'.

-- Transform the ProductDetail table into 1NF by ensuring each row represents a single product for an order.
SELECT 
    OrderID,
    CustomerName,
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(Products, ',', n.n), ',', -1)) AS Product
FROM 
    product_details
-- Use a number table or generate series to split the Products column into individual products.
-- This assumes the table contains a 'Products' column with comma-separated values.
JOIN 
    (SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4) n 
ON 
    CHAR_LENGTH(Products) - CHAR_LENGTH(REPLACE(Products, ',', '')) >= n.n - 1
ORDER BY 
    OrderID, n.n;

-- Question 2 🧩 Achieving 2NF (Second Normal Form)
-- To remove partial dependency, we split the OrderDetails table into two tables.
-- The first table (orders) contains OrderID and CustomerName, which depends on the whole primary key.
-- The second table (order_items) contains the OrderID, Product, and Quantity, which depends on the whole primary key as well.

-- First, create a table for the orders, which stores unique OrderID and CustomerName.
CREATE TABLE orders AS
SELECT DISTINCT 
    OrderID,
    CustomerName
FROM 
    order_details;

-- Now, create a table for order items, which stores OrderID, Product, and Quantity.
CREATE TABLE order_items AS
SELECT 
    OrderID,
    Product,
    Quantity
FROM 
    order_details;

-- After the tables are created, ensure data integrity by inserting data into both tables.
-- Insert data into orders table (OrderID, CustomerName)
INSERT INTO orders (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName FROM order_details;

-- Insert data into order_items table (OrderID, Product, Quantity)
INSERT INTO order_items (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity FROM order_details;
