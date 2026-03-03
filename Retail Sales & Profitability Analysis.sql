
-- STEP 1: CREATE DATABASE


CREATE DATABASE retail_sales_project;
USE retail_sales_project;


-- STEP 2: CREATE SALES TABLE


CREATE TABLE sales (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    order_date DATE,
    region VARCHAR(50),
    product VARCHAR(50),
    customer_id INT,
    quantity INT,
    price INT,
    planned_revenue INT
);



-- STEP 3: CREATE HELPER TABLE (1–10)


CREATE TABLE numbers (num INT);

INSERT INTO numbers (num)
VALUES (1),(2),(3),(4),(5),(6),(7),(8),(9),(10);


-- STEP 4: GENERATE 10,000+ SALES RECORDS


INSERT INTO sales (order_date, region, product, customer_id, quantity, price, planned_revenue)

SELECT 
    DATE_ADD('2024-01-01', INTERVAL FLOOR(RAND()*365) DAY),
    ELT(FLOOR(1 + (RAND()*4)), 'North','South','East','West'),
    ELT(FLOOR(1 + (RAND()*3)), 'Laptop','Mobile','Tablet'),
    FLOOR(1000 + (RAND()*5000)),
    FLOOR(1 + (RAND()*5)),
    FLOOR(10000 + (RAND()*40000)),
    FLOOR(50000 + (RAND()*200000))
FROM numbers a
CROSS JOIN numbers b
CROSS JOIN numbers c
CROSS JOIN numbers d;



-- STEP 5: CHECK TOTAL RECORDS


SELECT COUNT(*) AS total_records FROM sales;



-- KPI 1: TOTAL REVENUE


SELECT 
    SUM(quantity * price) AS total_revenue
FROM sales;



-- KPI 2: MONTHLY REVENUE TREND


SELECT 
    MONTH(order_date) AS month,
    SUM(quantity * price) AS monthly_revenue
FROM sales
GROUP BY MONTH(order_date)
ORDER BY month;



-- KPI 3: REVENUE GROWTH (MONTH OVER MONTH)


SELECT 
    month,
    monthly_revenue,
    monthly_revenue - LAG(monthly_revenue) 
    OVER (ORDER BY month) AS revenue_growth
FROM (
    SELECT 
        MONTH(order_date) AS month,
        SUM(quantity * price) AS monthly_revenue
    FROM sales
    GROUP BY MONTH(order_date)
) AS monthly_data;



-- KPI 4: PLAN VS ACTUAL (REGIONAL VARIANCE)


SELECT 
    region,
    SUM(planned_revenue) AS planned_revenue,
    SUM(quantity * price) AS actual_revenue,
    SUM(quantity * price) - SUM(planned_revenue) AS variance
FROM sales
GROUP BY region;



-- PERFORMANCE REPORT: REGION RANKING


SELECT 
    region,
    SUM(quantity * price) AS total_revenue,
    RANK() OVER (ORDER BY SUM(quantity * price) DESC) AS revenue_rank
FROM sales
GROUP BY region;



-- PERFORMANCE REPORT: PRODUCT PERFORMANCE


SELECT 
    product,
    SUM(quantity) AS total_quantity_sold,
    SUM(quantity * price) AS product_revenue
FROM sales
GROUP BY product
ORDER BY product_revenue DESC;

SELECT * FROM sales;

SELECT * 
FROM retail_sales_project.sales;

SELECT * 
FROM sales
LIMIT 1000;

