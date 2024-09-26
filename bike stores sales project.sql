
-- 1. Customer Location Information: Provide a list of all customers along with their respective city and state.

SELECT 
    customer_id,
    CONCAT(first_name, ' ', last_name) AS customer_name,
    city,
    state
FROM
    customers;


-- 2. Store Distribution by State: How many stores are there in each state?

SELECT 
    state, COUNT(store_id) AS Number_of_stores
FROM
    stores
GROUP BY state;


-- 3. Product and Brand Details: List all products with their name, price, and associated brand.

SELECT 
    product_name, list_price, brand_name
FROM
    brands AS b
        INNER JOIN
    products AS p ON b.brand_id = p.brand_id;


-- 4. Customer Purchase History: Show all orders made by a specific customer, including order status and dates.

SELECT 
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    order_status,
    order_date
FROM
    customers AS c
        INNER JOIN
    orders AS o ON c.customer_id = o.customer_id
WHERE
    c.customer_id = 111;


-- 5. Order Item Breakdown: For a given order, provide a breakdown of all the items, including quantity and product price.

SELECT 
    product_name, quantity, p.list_price AS price
FROM
    order_items AS oi
        INNER JOIN
    products AS p ON oi.product_id = p.product_id
WHERE
    order_id = 6;
    

-- 6. Staff Assignments: Which staff members are assigned to work at a specific store?

SELECT 
    CONCAT(stf.first_name, ' ', stf.last_name) AS staff_name,
    str.*
FROM
    staffs AS stf
        INNER JOIN
    stores AS str ON stf.store_id = str.store_id
WHERE
    stf.store_id = 2;


-- 7. Product Category Overview: Display all products within a specific category.

SELECT 
    product_name
FROM
    products
WHERE
    category_id = 4;


-- 8.Basic Product Inventory: How many units of each product are in stock at each store? (Requires a join between stocks and products tables)

SELECT 
    str.store_name AS store_name,
    COUNT(p.product_id) AS number_of_available_product
FROM
    stores AS str
        INNER JOIN
    stocks AS stc ON str.store_id = stc.store_id
        INNER JOIN
    products AS p ON stc.product_id = p.product_id
GROUP BY store_name;


-- 9. Order and Store Details: Show a list of all orders, including the store name where each order was placed. (Requires a join between orders and stores tables)

SELECT 
    o.order_id, s.store_name
FROM
    orders AS o
        INNER JOIN
    stores AS s ON o.store_id = s.store_id
ORDER BY o.order_id;


-- 10. Product Sales Volume: What is the total quantity sold for each product?

SELECT 
    p.product_name, SUM(oi.quantity) AS qty_sold
FROM
    products AS p
        INNER JOIN
    order_items AS oi ON p.product_id = oi.product_id
GROUP BY p.product_name;


-- 11. Store Sales Performance: Calculate the total sales value (based on quantity and price) for each store.

SELECT 
    s.store_name,
    SUM(oi.quantity * oi.list_price - oi.discount) AS total_sales
FROM
    stores AS s
        INNER JOIN
    orders AS o ON s.store_id = o.store_id
        INNER JOIN
    order_items AS oi ON oi.order_id = o.order_id
GROUP BY s.store_name;


-- 12.Late Shipments: Identify orders that were shipped after their required date.

SELECT 
    order_id, required_date, shipped_date
FROM
    orders
WHERE
    required_date < shipped_date;
    
    
-- 13. Top-Selling Products: Which are the top 5 best-selling products based on quantity sold?

SELECT 
    p.product_name, SUM(oi.quantity) AS qty_sold
FROM
    products AS p
        INNER JOIN
    order_items AS oi ON p.product_id = oi.product_id
GROUP BY p.product_name
ORDER BY qty_sold DESC
LIMIT 5;


-- 14. Store Inventory Insights: How many total products are stocked in each store?

SELECT 
    sr.store_name, SUM(sc.quantity) as products_qty
FROM
    stocks AS sc
        INNER JOIN
    stores AS sr ON sc.store_id = sr.store_id
GROUP BY sr.store_name;


-- 15. Loyal Customers: Which customers have placed more than one order?

SELECT 
    o.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS cust_name,
    COUNT(o.order_id) AS num_of_orders
FROM
    customers AS c
        INNER JOIN
    orders AS o ON c.customer_id = o.customer_id
GROUP BY o.customer_id , cust_name
HAVING num_of_orders > 1;


-- 16. Inactive Customers: Provide a list of customers who have not placed any orders yet.

SELECT 
    o.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS cust_name,
    COUNT(o.order_id) AS num_of_orders
FROM
    customers AS c
        LEFT JOIN
    orders AS o ON c.customer_id = o.customer_id
GROUP BY o.customer_id , cust_name
HAVING num_of_orders IS NULL;

-- query as per GPT
-- SELECT 
--     c.customer_id,
--     CONCAT(c.first_name, ' ', c.last_name) AS cust_name
-- FROM
--     customers AS c
--         LEFT JOIN
--     orders AS o ON c.customer_id = o.customer_id
-- WHERE 
--     o.order_id IS NULL;



-- 17. Top Revenue-Generating Stores: Which are the top 3 stores generating the highest sales revenue?

SELECT 
    str.store_name,
    SUM(oi.list_price * oi.quantity - oi.discount) AS total_sales
FROM
    stores AS str
        INNER JOIN
    orders AS o ON str.store_id = o.store_id
        INNER JOIN
    order_items AS oi ON oi.order_id = o.order_id
GROUP BY str.store_name
ORDER BY total_sales DESC
LIMIT 3;


-- 18. High-Performing Staff: Identify the staff members who have managed the most number of orders.

SELECT 
    stf.staff_id,
    CONCAT(stf.first_name, ' ', stf.last_name) AS staff_name,
    COUNT(o.order_id) AS num_of_orders
FROM
    orders AS o
        INNER JOIN
    staffs AS stf ON o.staff_id = stf.staff_id
GROUP BY stf.staff_id , staff_name
ORDER BY num_of_orders DESC
LIMIT 5;


-- 19. Category Discount Analysis: Calculate the average discount offered for products within each category.

SELECT 
    c.category_name, AVG(oi.discount) AS discount
FROM
    categories AS c
        INNER JOIN
    products AS p ON c.category_id = p.category_id
        INNER JOIN
    order_items AS oi ON p.product_id = oi.product_id
GROUP BY c.category_name;


-- 20. Top-Spending Customers: Who are the top 5 customers based on their total spend (calculated as price * quantity)?

SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    SUM(oi.list_price * oi.quantity - oi.discount) AS total_spending
FROM
    customers AS c
        INNER JOIN
    orders AS o ON c.customer_id = o.customer_id
        INNER JOIN
    order_items AS oi ON o.order_id = oi.order_id
GROUP BY c.customer_id , last_name
ORDER BY total_spending DESC
LIMIT 5;


-- 21. Low Inventory Stores: Which store has the lowest overall stock of products?

SELECT 
    str.store_name, SUM(stc.quantity) AS stock_quantity
FROM
    stores AS str
        INNER JOIN
    stocks AS stc ON str.store_id = stc.store_id
GROUP BY str.store_name
ORDER BY stock_quantity
LIMIT 1;


-- 22. Unsold Products: List the products that have never been ordered.

SELECT 
    p.product_name, oi.order_id
FROM
    order_items AS oi
        RIGHT JOIN
    products AS p ON oi.product_id = p.product_id
WHERE
    oi.order_id IS NULL;


-- 23. On-Time Shipments: What percentage of orders were shipped on or before the required date?

SELECT 
    (SELECT 
            COUNT(order_id)
        FROM
            orders
        WHERE
            required_date < shipped_date )  / (SELECT 
            COUNT(order_id)
        FROM
            orders) *100 AS Percentage_order_ship_before;
            
            
            
            
            














































































































































































