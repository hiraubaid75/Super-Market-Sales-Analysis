/* ASSIGNMENT 1

PLEASE WRITE YOUR CODE BELOW EACH EXERCISE 
PLEASE DON'T SUBMIT ANYTHING ELSE, JUST THIS SCRIPT FILE WITH YOUR CODE UNDER EACH EXERCISE
TOTAL MARKS: 30

*/


-- Q1 [5 marks]
-- Each invoice_id has a middle number (for e.g. 46 in 727-46-3608). Write a query to get each middle number and the count of invoices for that middle number
-- (you will first need to figure out how to create a column in the select clause to extract 
-- the invoice_middle_number (hint: nested substring_index() can help) and then group by this column)
-- order your result by invoice_middle_number in ascending order


SELECT 
    SUBSTRING_INDEX(SUBSTRING_INDEX(`Invoice ID`, '-', 2), '-', -1) AS invoice_middle_number, 
    COUNT(*) AS invoice_count 
FROM 
    supermarket_sales 
GROUP BY 
    invoice_middle_number 
ORDER BY 
    invoice_middle_number ASC;

-- Q2 [5 marks]
-- Get product_line, unit_price, and a label for each unit_price called price_category
-- unit_price greater than 70 is expensive
-- unit_price ranging from 40 to 70 is moderately expensive
-- unit_price less than 40 is cheap
-- order your result by the unit_price in descending order
SELECT 
    SUBSTRING_INDEX(`Customer type.Product line`, '.', -1) AS product_line,
    `Unit price` as unit_price ,
	CASE 
        WHEN `Unit price` <= 40 THEN 'Cheap'
        WHEN (`Unit price` > 40 AND `Unit price` <= 70 )THEN 'moderately expensive'
        WHEN `Unit price` > 70 THEN "expensive"
        ELSE 'Unknown'
    END AS price_category
FROM 
    supermarket_sales

-- Q3 [3 marks]
-- Continuing from the query above, find out the count of invoices for each price_category
-- order your result by price_category in ascending order

select  price_category,count(1) `invoice count` from
(SELECT 
    SUBSTRING_INDEX(`Customer type.Product line`, '.', -1) AS product_line,
    `Unit price` as unit_price ,
	CASE 
        WHEN `Unit price` <= 40 THEN 'Cheap'
        WHEN (`Unit price` > 40 AND `Unit price` <= 70 )THEN 'moderately expensive'
        WHEN `Unit price` > 70 THEN "expensive"
        ELSE 'Unknown'
    END AS price_category
FROM 
    supermarket_sales) t   group by price_category order by count(1)

-- Q4 [5 marks]
-- For all invoices EXCEPT for the 'Fashion accessories' and 'Health and beauty' invoices:
-- Return branch name and total tax for each branch that has a total tax greater than 8000
-- Round off total tax to 3 dp
-- Order result by branch in ascending order

select Branch, ROUND(sum(`Tax 5%`),3) `Total Tax` from supermarket_sales
 where `Customer type.Product line` NOT LIKE '%Fashion accessories%'
    AND `Customer type.Product line` NOT LIKE '%Health and beauty%'
    group by Branch 
		having `Total Tax` > 8000 order by `Total Tax` ASC;

-- Q5 [2 marks]
-- Add a column called shipping_charges to the table. Give it an appropriate datatype. 
	ALTER TABLE supermarket_sales 
ADD COLUMN shipping_charges DECIMAL(10, 2) DEFAULT 0;

-- Q6 [5 marks]
-- Update this shipping column in the following way:
-- If the invoice's total price is greater than 1000, then the shipping is free
-- If the invoice's total price is less than 1000, then the shipping is 250
-- (total price is unit_price * quantity + tax_5pct)

SET SQL_SAFE_UPDATES = 0;
UPDATE supermarket_sales 
SET shipping_charges = 250 
WHERE (`Unit Price` * `Quantity`) + `Tax 5%` < 1000;




-- Q7 [5 marks]
-- Return city, product_line and PER city PER product_line, show the following stats:
-- number of invoices as invoice_count
-- number of free shipping orders as free_shipping_orders_count
-- number of paid shipping orders as paid_shipping_orders_count
-- total of shipping_charges as total_shipping
-- finally, order result by city in ascending order and product_line in descending order
SELECT 
    city,
    SUBSTRING_INDEX(`Customer type.Product line`, '.', -1) AS product_line,
    COUNT(1) AS invoice_count,
    SUM(CASE WHEN shipping_charges = 0 THEN 1 ELSE 0 END) AS free_shipping_orders_count,
    SUM(CASE WHEN shipping_charges > 0 THEN 1 ELSE 0 END) AS paid_shipping_orders_count,
    SUM(shipping_charges) AS total_shipping
FROM 
    supermarket_sales
GROUP BY 
    city, product_line
ORDER BY 
    city ASC, 
    product_line DESC;












