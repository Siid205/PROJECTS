
SELECT * FROM customer_profiles;
SELECT * FROM sales_transaction;
SELECT * FROM product_inventory;

                      -- CHECK FOR NULL VALUES --
			---------------------------------------------

-- SELECT 
--     COUNT(*) AS total_customers,
--     COUNT(ï»¿CustomerID) AS customer_id_count,
--     COUNT(age) AS age_count,
--     COUNT(gender) AS gender_count,
--     COUNT(location) AS location_count
-- FROM customer_profiles;



-- SELECT 
--     COUNT(*) AS total_rows,
--     COUNT(ï»¿TransactionID) AS transaction_id_count,
--     COUNT(CustomerID) AS customer_id_count,
--     COUNT(ProductID) AS product_id_count,
--     COUNT(QuantityPurchased) AS quantity_count,
--     COUNT(Price) AS price_count
-- FROM sales_transaction;


      
-- SELECT 
--     COUNT(*) AS total_products,
--     COUNT(ï»¿ProductID) AS product_id_count,
-- 	COUNT(ProductName) AS product_name_count,
--     COUNT(Category) AS category_count,
--     COUNT(StockLevel) AS stock_count,
--     COUNT(Price) AS price_count
-- FROM product_inventory;




                     --  CHECKING DUPLICATE TRANSACTIONS --
---------------------------------------------------------------------------------

-- SELECT ï»¿TransactionID, COUNT(*) 
-- FROM sales_transaction 
-- GROUP BY ï»¿TransactionID 
-- HAVING COUNT(*) > 1;


                     --  DELETE DUPLICATE TRANSACTIONS --
-------------------------------------------------------------------------

-- CREATE TEMPORARY TABLE temp_table AS SELECT DISTINCT * FROM sales_transaction;

-- TRUNCATE TABLE sales_transaction;

-- INSERT INTO sales_transaction SELECT * FROM temp_table;




                         -- CHECKING INVALID AGE --
-------------------------------------------------------------------------------------------

-- SELECT *
-- FROM customer_profiles
-- WHERE age < 10 OR age > 100;



					     -- UPDATING INVALID AGE --
--------------------------------------------------------------------------------

-- SET @avg_age = (SELECT ROUND(AVG(age)) FROM customer_profiles WHERE age BETWEEN 18 AND 70);

-- UPDATE customer_profiles
-- SET age = @avg_age
-- WHERE `ï»¿CustomerID` = 668;




                      -- OVERALL SALES --
	---------------------------------------------------------

-- SELECT 
--     COUNT(DISTINCT ï»¿TransactionID) AS total_transactions,
--     COUNT(DISTINCT CustomerID) AS total_customers,
--     COUNT(DISTINCT ProductID) AS total_products,
--     SUM(QuantityPurchased * price) AS total_revenue
-- FROM sales_transaction;



                         -- CATEGORY-WISE SALES --
	----------------------------------------------------------------------------

-- SELECT p.Category, SUM(s.QuantityPurchased * s.Price) AS category_revenue 
-- FROM sales_transaction s 
-- JOIN product_inventory p
-- ON s.ProductID = p.ï»¿ProductID
-- GROUP BY p.category ORDER BY category_revenue DESC;




               -- IDENTIFY HIGH AND LOW SALES PRODUCTS --
---------------------------------------------------------------------------------


-- TOP 10 PRODUCT WITH HIGH REVENUE --

-- SELECT s.ProductID, p.ProductName, p.Category, p.StockLevel, SUM(s.QuantityPurchased) AS total_quantity_sold, 
-- ROUND(SUM(s.QuantityPurchased * s.Price)) AS total_revenue
-- FROM sales_transaction s 
-- JOIN product_inventory p
-- ON s.ProductID = p.ï»¿ProductID
-- GROUP BY s.ProductID, p.ProductName, p.Category,  p.StockLevel
-- ORDER BY total_revenue DESC
-- LIMIT 10;



-- BOTTOM PRODUCT BY UNITS SOLD --

-- SELECT s.ProductID, p.ProductName, p.Category, p.StockLevel, SUM(s.QuantityPurchased) AS total_quantity_sold, 
-- ROUND(SUM(s.QuantityPurchased * s.Price)) AS total_revenue
-- FROM sales_transaction s 
-- JOIN product_inventory p
-- ON s.ProductID = p.ï»¿ProductID
-- GROUP BY s.ProductID, p.ProductName, p.Category,  p.StockLevel
-- HAVING total_quantity_sold < 40 
-- ORDER BY total_quantity_sold DESC;



-- PRODUCT WITH HIGH DEMAND WITH LOW STOCKS -- 

-- SELECT s.ProductID, p.ProductName, p.Category, p.StockLevel, SUM(s.QuantityPurchased) AS total_quantity_sold, 
-- ROUND(SUM(s.QuantityPurchased * s.Price)) AS total_revenue
-- FROM sales_transaction s 
-- JOIN product_inventory p
-- ON s.ProductID = p.ï»¿ProductID
-- GROUP BY s.ProductID, p.ProductName, p.Category,  p.StockLevel
-- HAVING total_quantity_sold > p.StockLevel 
-- ORDER BY total_quantity_sold DESC;



-- PRODUCT WITH LOW DEMAND WITH HIGH STOCKS -- 

-- SELECT s.ProductID, p.ProductName, p.Category, p.StockLevel, SUM(s.QuantityPurchased) AS total_quantity_sold, 
-- ROUND(SUM(s.QuantityPurchased * s.Price)) AS total_revenue
-- FROM sales_transaction s 
-- JOIN product_inventory p
-- ON s.ProductID = p.ï»¿ProductID
-- GROUP BY s.ProductID, p.ProductName, p.Category,  p.StockLevel
-- HAVING total_quantity_sold < 50 
-- ORDER BY p.StockLevel DESC;



                       -- CUSTOMER SEGMENTATION --
---------------------------------------------------------------------------------    

-- SELECT c.ï»¿CustomerID,COALESCE(SUM(s.QuantityPurchased), 0) AS Total_quantity,
-- CASE
-- 	WHEN COALESCE(SUM(s.QuantityPurchased), 0) = 0 THEN 'No Order'
-- 	WHEN COALESCE(SUM(s.QuantityPurchased), 0) BETWEEN 1 AND 10 THEN 'Low Value'
-- 	WHEN COALESCE(SUM(s.QuantityPurchased), 0) BETWEEN 11 AND 30 THEN 'Mid Value'
-- 	ELSE 'High Value'
-- END AS customer_segment
-- FROM customer_profiles c
-- LEFT JOIN sales_transaction s
-- ON c.ï»¿CustomerID = s.CustomerID
-- GROUP BY c.ï»¿CustomerID
-- ORDER BY Total_quantity;



            -- Count customers in each segment --
------------------------------------------------------------------
    
-- SELECT customer_segment, COUNT(*) AS customer_count
-- FROM (SELECT c.ï»¿CustomerID,
-- CASE
-- 	WHEN COALESCE(SUM(s.QuantityPurchased), 0) = 0 THEN 'No Orders'
-- 	WHEN SUM(s.QuantityPurchased) BETWEEN 1 AND 10 THEN 'Low'
-- 	WHEN SUM(s.QuantityPurchased) BETWEEN 11 AND 30 THEN 'Mid'
-- 	ELSE 'High Value'
-- END AS customer_segment
-- FROM customer_profiles c
-- LEFT JOIN sales_transaction s
-- ON c.ï»¿CustomerID = s.CustomerID
-- GROUP BY c.ï»¿CustomerID
-- )sub GROUP BY customer_segment;



            -- IDENTIFY REPEAT CUSTOMER --
---------------------------------------------------------

-- SELECT CustomerID, COUNT(DISTINCT ï»¿TransactionID) AS total_orders
-- FROM sales_transaction
-- GROUP BY CustomerID
-- HAVING COUNT(DISTINCT ï»¿TransactionID) > 1;



		       -- CLASSIFY CUSTOMER PURCHASING BEHAVIOUR --
---------------------------------------------------------------------------

-- SELECT CustomerID, COUNT(ï»¿TransactionID) AS Total_orders,
-- CASE 
-- 	WHEN COUNT(ï»¿TransactionID) = 1 THEN 'One-Time Buyer'
--     WHEN COUNT(ï»¿TransactionID) BETWEEN 2 AND 10 THEN 'Repeat-Buyer'
--     ELSE 'Loyal Customer'
-- END AS Purchase_Behaviour
-- FROM sales_transaction
-- GROUP BY CustomerID;
































































