Use walmart;

-- Creating Sales table 

CREATE TABLE sales (
    invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10 , 2 ) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6 , 4 ) NOT NULL,
    total DECIMAL(12 , 4 ) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10 , 2 ) NOT NULL,
    gross_margin_pct FLOAT(11 , 9 ),
    gross_income DECIMAL(12 , 4 ),
    rating FLOAT(2 , 1 )
);

select * from sales;

-- =======================Feature Engineering ===============================

-- Adding Time_of_day column
SELECT time,
(CASE 
	WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
	WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
	ELSE "Evening" 
END) AS time_of_day
FROM sales;

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

UPDATE sales
SET time_of_day = (
	CASE 
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
		WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
		ELSE "Evening" 
	END
);

-- Adding Day_name column
SELECT date,
DAYNAME(date) AS day_name
FROM sales;

ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);

UPDATE sales
SET day_name = DAYNAME(date);

--  Adding Momth_name column
SELECT date,
MONTHNAME(date) AS month_name
FROM sales;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);

UPDATE sales
SET month_name = MONTHNAME(date);

-- ============================= Product Analysis =================================

-- How many unique product lines does the data have?
SELECT 
	DISTINCT product_line
    FROM sales;
    
-- What is the most common payment method?
SELECT payment,
	COUNT(payment)
    FROM sales
    GROUP BY payment;
    
-- What is the most selling product line?
SELECT 
	product_line, COUNT(product_line) as total_count
    FROM sales
    GROUP BY product_line
    ORDER BY total_count desc;
    
-- What is the total revenue by month (highest to lowest) :
SELECT 
	month_name ,SUM(total)
    FROM sales
    GROUP BY month_name
    ORDER BY month_name desc;
    
-- What month had the largest COGS?
SELECT 
	SUM(COGS), month_name
    FROM sales
    GROUP BY month_name
    ORDER BY SUM(COGS) DESC;
    
-- Top 3 product line had the largest revenue?
SELECT 
	 product_line,SUM(total-COGS) AS revenue
    FROM sales
    GROUP BY product_line
    ORDER BY revenue DESC
    limit 3;
    
-- What is the city with the largest revenue?
SELECT 
	SUM(total-COGS) AS revenue, city
    FROM sales 
    GROUP BY city
    ORDER BY revenue DESC;
    
-- What product line had the largest TAX?
SELECT 
    product_line, AVG(tax_pct) AS avg_tax
FROM
    sales
GROUP BY product_line
ORDER BY avg_tax DESC;

-- Fetch each product line showing "Good", "Bad". 
-- Good if its greater than average sales
select avg(Total) as avg_total from sales;
SELECT 
     product_line,
    CASE
        WHEN AVG(total) > (SELECT AVG(total) FROM sales) THEN 'GOOD'
        ELSE 'BAD'
    END AS result
FROM sales
GROUP BY product_line;

-- Which branch sold more products than average product sold?
SELECT 
branch, AVG(total)
FROM sales
GROUP BY branch
ORDER BY avg(total) desc;

-- What is the most common product line by gender?
SELECT
	gender, product_line,
    COUNT(gender) as total_cnt
    FROM sales
    GROUP BY gender , product_line
    ORDER BY total_cnt DESC;
       
-- What is the average rating of each product line?
SELECT 
	product_line ,AVG(rating) as avg_rating
    FROM sales
    GROUP BY product_line
    ORDER BY avg_rating DESC;
    
-- =========================== SALES ANALYSIS ===========================

-- Number of sales made in each time of the day per weekday
SELECT
	day_name, COUNT(day_name) as sales_per_day
    FROM sales
    GROUP BY day_name
    ORDER BY sales_per_day;
    
-- Which of the customer types brings the most revenue?
SELECT 
	customer_type, SUM(total-COGS) AS revenue
    FROM sales
    GROUP BY customer_type
    ORDER BY revenue DESC;

-- Which city has the largest tax percent/ VAT (Value Added Tax)?
SELECT
	city , ROUND(AVG(tax_pct), 2) AS avg_tax_pct
    FROM sales
    GROUP BY city
    ORDER BY avg_tax_pct DESC;
    
-- Which customer type pays the most in VAT?

SELECT
	customer_type, AVG(tax_pct) AS total_tax
    FROM sales
    GROUP BY customer_type
    ORDER BY total_tax DESC;
    
-- ======================= CUSTOMER ANALYSIS ===========================

-- How many unique customer types does the data have?
SELECT
	DISTINCT customer_type
    FROM sales;

-- How many unique payment methods does the data have?
SELECT
	DISTINCT payment_method
    FROM sales;

-- What is the most common customer type?
SELECT
	customer_type, COUNT(customer_type) AS total_customer_type
    FROM sales
    GROUP BY customer_type
    ORDER BY total_customer_type DESC;
    
-- Which customer type buys the most?
SELECT 
	customer_type, COUNT(*) as buys
    FROM sales
    GROUP BY customer_type
    ORDER BY buys DESC;

 -- What is the gender of most of the customers?
 SELECT 
	gender, COUNT(*) as total_gender
    FROM sales
    GROUP BY gender
    ORDER BY total_gender DESC;

-- What is the gender distribution per branch?
SELECT 
	 COUNT(branch) as branch_cnt , branch , gender
    FROM sales
    GROUP BY branch, gender
    ORDER BY branch;
    
-- Which time of the day do customers give most ratings?
SELECT
	time_of_day, AVG(rating) AS avg_rating
    FROM sales
    GROUP BY time_of_day
    ORDER BY avg_rating DESC;

-- Which top 3 day of the week has the best avg ratings? 
SELECT
	day_name, AVG(rating) as avg_rating
    FROM sales
    GROUP BY day_name
    ORDER BY avg_rating DESC
    limit 3;
    
-- Which branch has the best average rating?
SELECT
    AVG(rating) AS avg_rating,
    branch
FROM sales
GROUP BY branch
ORDER BY avg_rating DESC;

    