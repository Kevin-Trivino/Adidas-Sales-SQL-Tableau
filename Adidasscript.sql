-- checking data types
SHOW FIELDS FROM adidas_sales FROM adidas;

-- rename columns
ALTER TABLE adidas_sales
CHANGE `Retailer ID` `Retailer_ID` INT,
CHANGE `Invoice Date` `Invoice_Date` TEXT,
CHANGE `Price per Unit` `Price_per_Unit` TEXT,
CHANGE `Units Sold` `Units_Sold` TEXT,
CHANGE `Total Sales` `Total_Sales` TEXT,
CHANGE `Operating Profit` `Operating_Profit` TEXT,
CHANGE `Operating Margin` `Operating_Margin` TEXT,
CHANGE `Sales Method` `Sales_Method` TEXT;

-- remove dollar signs and percentage symbols
UPDATE adidas_sales
SET Price_per_Unit = REPLACE(Price_per_Unit, '$', ''),
    Total_Sales = REPLACE(Total_Sales, '$', ''),
    Operating_Profit = REPLACE(Operating_Profit, '$', ''),
    Operating_Margin = REPLACE(Operating_Margin, '%', '');

-- modify data types
ALTER TABLE adidas_sales
MODIFY Price_per_Unit DECIMAL(10, 2),
MODIFY Total_Sales DECIMAL(10, 2),
MODIFY Operating_Profit DECIMAL(10, 2),
MODIFY Operating_Margin DECIMAL(10, 2);

UPDATE adidas_sales
SET Operating_Margin = Operating_Margin / 100;

## Data exploraiton ##

-- sales by region
SELECT region, SUM(total_sales) as total_sales
FROM adidas_sales
GROUP BY region 
ORDER BY total_sales DESC;

-- sales by product
SELECT product, SUM(total_sales) as total_sales
FROM adidas_sales
GROUP BY product 
ORDER BY total_sales DESC;

-- profit margin by product
SELECT product, 
	SUM(operating_profit) AS total_operating_profit, 
	SUM(total_sales) AS total_sales,
    SUM(operating_profit) / SUM(total_sales) AS profit_margin
FROM adidas_sales
GROUP BY product
ORDER BY profit_margin DESC;

-- avg price per unit for each product
SELECT product, ROUND(AVG(price_per_unit), 2) AS avg_price
FROM adidas_sales
GROUP BY product
ORDER BY avg_price DESC;

-- top cities in region
SELECT t1.region, t1.city, t1.total_sales
FROM (
	SELECT region, city, SUM(total_sales) AS total_sales, 
		RANK() OVER (PARTITION BY region ORDER BY SUM(total_sales) DESC) AS ranks
        FROM adidas_sales
        GROUP BY region, city
	) t1
WHERE t1.ranks = 1;


