
-- TASK 4: SQL for Data Analysis
-- Dataset: E-Commerce (Customers + Orders) 

rename table customer to  Customers; 

-- 1. View first few records from both tables
SELECT * FROM customers LIMIT 5;
SELECT * FROM Orders LIMIT 5;

-- 2. Show total sales, total profit, and average discount
SELECT 
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND(AVG(Discount), 2) AS avg_discount
FROM Orders;

-- 3. Find top 5 customers by total sales
SELECT o.Customer_ID, c.Customer_Name, SUM(o.Sales) AS total_sales
FROM Orders o
JOIN Customers c
ON o.Customer_ID = c.Customer_ID
GROUP BY o.Customer_ID, c.Customer_Name
ORDER BY total_sales DESC
LIMIT 5;


-- 4. Find total profit per region
SELECT c.Region, ROUND(SUM(o.Profit), 2) AS total_profit
FROM Orders o
JOIN Customers c
ON o.Customer_ID = c.Customer_ID
GROUP BY c.Region
ORDER BY total_profit DESC;

-- 5. Find average sales and profit by product category
SELECT Category, 
       ROUND(AVG(Sales), 2) AS avg_sales, 
       ROUND(AVG(Profit), 2) AS avg_profit
FROM Orders
GROUP BY Category
ORDER BY avg_profit DESC;

-- 6. INNER JOIN: Show orders with customer details
SELECT o.Order_ID, o.Order_Date, c.Customer_Name, c.Region, o.Sales, o.Profit
FROM Orders o
INNER JOIN Customers c
ON o.Customer_ID = c.Customer_ID
ORDER BY o.Sales DESC
LIMIT 10;

-- 7. LEFT JOIN: Show all customers and their order info (including customers who haven't ordered)
SELECT c.Customer_Name, o.Order_ID, o.Sales
FROM Customers c
LEFT JOIN Orders o
ON c.Customer_ID = o.Customer_ID
ORDER BY c.Customer_Name;

-- 8. RIGHT JOIN: Show all orders even if customer details are missing 
SELECT o.Order_ID, o.Sales, c.Customer_Name
FROM Orders o
RIGHT JOIN Customers c
ON o.Customer_ID = c.Customer_ID;

-- 9. Subquery: Customers who have total sales greater than average customer sales
SELECT c.Customer_Name, SUM(o.Sales) AS total_sales
FROM Orders o
JOIN Customers c
ON o.Customer_ID = c.Customer_ID
GROUP BY c.Customer_Name
HAVING total_sales > (
    SELECT AVG(total_sales)
    FROM (
        SELECT SUM(Sales) AS total_sales
        FROM Orders
        GROUP BY Customer_ID
    ) AS subquery
)
ORDER BY total_sales DESC;

-- 10. Top 3 most profitable product sub-categories
SELECT Sub_Category, ROUND(SUM(Profit), 2) AS total_profit
FROM Orders
GROUP BY Sub_Category
ORDER BY total_profit DESC
LIMIT 3;

-- 11. Monthly sales trend view
CREATE VIEW monthly_sales_summary AS
SELECT 
  month(Order_Date) AS month_number,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit
FROM orders
GROUP BY month(Order_Date)
ORDER BY month_number; 

-- 12. Query the monthly sales summary view
SELECT * FROM monthly_sales_summary;

-- 13. Segment-wise average profit
SELECT c.Segment, ROUND(AVG(o.Profit), 2) AS avg_profit
FROM Orders o
JOIN Customers c
ON o.Customer_ID = c.Customer_ID
GROUP BY c.Segment
ORDER BY avg_profit DESC;

-- 14. Optimize performance with indexes
CREATE INDEX idx_customer_id_orders ON Orders(Customer_ID);
CREATE INDEX idx_customer_id_customers ON Customers(Customer_ID);
CREATE INDEX idx_region_customers ON Customers(Region);
CREATE INDEX idx_order_date ON Orders(Order_Date);
