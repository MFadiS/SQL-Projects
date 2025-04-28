-- SQL Sales Analysis
 -- Create Table
 DROP TABLE IF EXISTS retail_sales;
 CREATE TABLE retail_sales(
transactions_id	 INT PRIMARY KEY,
sale_date	DATE,
sale_time TIME,	
customer_id	INT,
gender	VARCHAR(15),
age	INT,
category VARCHAR(15),	
quantiy	INT,
price_per_unit	FLOAT,
cogs	FLOAT,
total_sale FLOAT
 )

-- Checking for NULL values
 SELECT* FROM retail_sales
 WHERE sale_time IS NULL
 OR sale_date IS NULL
 OR gender IS NULL
 OR category IS NULL
 OR quantity IS NULL
 OR cogs IS NULL
 OR price_per_unit IS NULL
 OR total_sale IS NULL;

-- Deleting NUll values
DELETE FROM retail_sales
WHERE sale_time IS NULL
 OR sale_date IS NULL
 OR gender IS NULL
 OR category IS NULL
 OR quantity IS NULL
 OR cogs IS NULL
 OR price_per_unit IS NULL
 OR total_sale IS NULL;

 -- How much sales we have
SELECT COUNT(*) as total_sale FROM retail_sales

--How many customers
SELECT COUNT (DISTINCT customer_id) FROM retail_sales

SELECT DISTINCT category FROM retail_sales

-- Data Analysis and key business problems
	-- Sales made on 2022-11-05
		SELECT*
		FROM retail_sales
		WHERE sale_date = '2022-11-05'

	-- Transactions in clothing catrgory where quantity sold is more than 10
		SELECT *
		FROM retail_sales
		WHERE category = 'Clothing'
			AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
			AND quantity >= 4
	
	-- Calculate total sales for each category
	SELECT category,
	SUM(total_sale) AS net_sales,
	COUNT(*) AS total_orders
	FROM retail_sales
	GROUP BY 1

	-- Average age of customers who purchased from beauty category
	SELECT category,
	ROUND(AVG(age),2) as mean_age
	FROM retail_sales
	WHERE category = 'Beauty'
	GROUP BY 1

	-- Transactios where total sales is greater than 1000
	SELECT *
	FROM retail_sales
	WHERE total_sale >= 1000

 	-- Total number of Transactions made by each gender in each category
	 SELECT category, 
	 		gender,
	 		COUNT(DISTINCT transactions_id) as total_trans
	 FROM retail_sales
	 GROUP BY category, gender

	 -- Calculate average sale for each month, find the best selling month
	 SELECT year, month, avg_sales
	 FROM(
	 SELECT 
	 		EXTRACT(YEAR FROM sale_date) as year,
			EXTRACT(MONTH FROM sale_date) as month,
			AVG(total_sale) as avg_sales,
			RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank 
			
	FROM retail_sales
	GROUP BY 1,2
	) as t1
	WHERE rank =1
			 
	-- Top 5 customers based on highest total sales
	SELECT customer_id, SUM(total_sale) as total
	FROM retail_sales
	GROUP BY 1
	ORDER BY 2 DESC
	LIMIT 5

	-- Unique customers who purchased from each category
	SELECT category, COUNT(DISTINCt customer_id) as unique_customer
	FROM retail_sales
	GROUP BY category

	-- Create each shift and number of orders
	WITH hourly_sales
	AS(
	SELECT *,
		CASE
			WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
			WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
			ELSE 'Night'
		END as shifts
	
	FROM retail_sales
	)
	SELECT shifts,
	COUNT(*) as total_order
	FROM hourly_sales
	GROUP BY shifts

-- End of Project
	 