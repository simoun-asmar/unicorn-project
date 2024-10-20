/*Question#1: How many customers do we have in the data?*/

SELECT
	COUNT(DISTINCT customer_id)
      
FROM 
	customers
;

/*Question#2: What was the city with the most profit for the company in 2015?*/


WITH top_city AS (
    SELECT
        o.shipping_city,  -- Select the shipping city
        SUM(od.order_profits) AS total_profit  -- Calculate total profit per city
    FROM order_details AS od
    JOIN orders AS o 
    ON o.order_id = od.order_id  -- Join orders with order details on order_id
    WHERE EXTRACT(YEAR FROM o.order_date::DATE) = 2015  -- Filter for orders from 2015
    GROUP BY o.shipping_city  -- Group by shipping city
    ORDER BY total_profit DESC  -- Order by total profit in descending order
    LIMIT 1  -- Limit the result to the top city
)

SELECT shipping_city  -- Select the city with the highest total profit
FROM top_city
;

/*Question#3: In 2015, what was the most profitable city's profit?*/

SELECT
    o.shipping_city,  -- Select the shipping city
    SUM(od.order_profits) AS total_profit  -- Calculate total profit per city
FROM 
    order_details AS od
JOIN orders AS o 
ON o.order_id = od.order_id  -- Join orders with order details on order_id
WHERE 
    EXTRACT(YEAR FROM o.order_date::DATE) = 2015  -- Filter for orders from the year 2015
GROUP BY
    o.shipping_city  -- Group by shipping city
ORDER BY 
    total_profit DESC  -- Order by total profit in descending order
LIMIT 1  -- Limit the result to the top city
;


/*Question#4: How many different cities do we have in the data?*/
SELECT
			COUNT(DISTINCT shipping_city)

FROM orders
;

/*Question#5: Show the total spent by customers from low to high.*/


SELECT
    c.customer_id,  -- Select customer ID
    SUM(od.order_sales) AS total_spent  -- Calculate total sales (total spent by the customer)
FROM 
    customers AS c
JOIN 
    orders AS o ON o.customer_id = c.customer_id  -- Join customers with orders on customer_id
JOIN 
    order_details AS od ON od.order_id = o.order_id  -- Join orders with order details on order_id
GROUP BY 
    1  -- Group by customer_id
ORDER BY 
    2 ASC;  -- Order by total spent in ascending order



/*Question#6: What is the most profitable city in the State of Tennessee?*/


SELECT shipping_city
FROM (
    SELECT
        o.shipping_city,  -- Select the shipping city
        SUM(od.order_profits) AS total_profit  -- Calculate total profit per city
    FROM orders AS o
    LEFT JOIN order_details AS od 
    ON od.order_id = o.order_id  -- Left join to get order details
    WHERE o.shipping_state = 'Tennessee'  -- Filter for orders from Tennessee
    GROUP BY o.shipping_city  -- Group by shipping city
    ORDER BY total_profit DESC  -- Order by total profit in descending order
    LIMIT 1  -- Limit to the city with the highest profit
) AS top_city;



/*Question#7: What’s the average annual profit for that city across all years?*/


SELECT
    ROUND(AVG(od.order_profits)::NUMERIC, 2) AS total_profit  -- Calculate and round the average profit to 2 decimal places
FROM 
    orders AS o
LEFT JOIN 
    order_details AS od ON od.order_id = o.order_id  -- Left join to get order details
WHERE 
    o.shipping_city = 'Lebanon'  -- Filter for orders from the city of Lebanon
 ;



/*Question#8: What is the distribution of customer types in the data?*/


SELECT
    customer_segment,  -- Select customer segment
    COUNT(DISTINCT customer_id) AS customer_per_segment,  -- Count distinct customers per segment
    ROUND(100 * COUNT(DISTINCT customer_id)::NUMERIC / (SELECT COUNT(DISTINCT customer_id) FROM customers), 2) || '%' AS customer_perc  -- Calculate percentage of customers per segment and format as percentage
FROM 
    customers
GROUP BY 
    1  -- Group by customer segment
;



/*Question#9: What’s the most profitable product category on average in Iowa across all years?*/


SELECT
    p.product_category,  -- Select product category
    AVG(od.order_profits) AS avg_profit  -- Calculate average profit per product category
FROM 
    product AS p
JOIN 
    order_details AS od ON od.product_id = p.product_id  -- Join products with order details
JOIN 
    orders AS o ON o.order_id = od.order_id  -- Join order details with orders
WHERE 
    o.shipping_state = 'Iowa'  -- Filter for orders shipped to Iowa
GROUP BY 
    1  -- Group by product category
ORDER BY 
    2 DESC  -- Order by average profit in descending order
LIMIT 
    1 -- Limit to the top product category by average profit
;


/*Question#10: What is the most popular product in that category across all states in 2016?*/


SELECT
    p.product_name,  -- Select product name
    SUM(quantity) AS total_quantity  -- Calculate total quantity of the product sold
FROM 
    product AS p
JOIN 
    order_details AS od ON od.product_id = p.product_id  -- Join products with order details
JOIN 
    orders AS o ON o.order_id = od.order_id  -- Join order details with orders
WHERE 
    p.product_category = 'Furniture'  -- Filter for products in the 'Furniture' category
    AND EXTRACT(YEAR FROM o.order_date::DATE) = '2016'  -- Filter for orders from the year 2016
GROUP BY 
    1  -- Group by product name
ORDER BY 
    2 DESC  -- Order by total quantity in descending order
LIMIT 
    1  -- Limit to the top product by quantity
;



/*Question#11: Which customer got the most discount in the data? (in total amount)*/ 


SELECT  
    c.customer_id,  -- Select customer ID
    ROUND(SUM(od.order_discount * od.order_sales)::NUMERIC, 2) AS total_discount_amount  -- Calculate and round the total discount amount for each customer
FROM 
    customers AS c
JOIN 
    orders AS o ON o.customer_id = c.customer_id  -- Join customers with orders
JOIN 
    order_details AS od ON od.order_id = o.order_id  -- Join orders with order details
GROUP BY 
    1  -- Group by customer ID
ORDER BY 
    2 DESC  -- Order by total discount amount in descending order
LIMIT 
    1  -- Limit to the customer with the highest discount amount
;


/*Question#12: How widely did monthly profits vary in 2018?*/


SELECT    
    EXTRACT(MONTH FROM o.order_date) AS month_num,  -- Extract the month number from the order date
    MAX(od.order_profits),  -- Get the maximum profit for the month
    MIN(od.order_profits),  -- Get the minimum profit for the month
    MAX(od.order_profits) - MIN(od.order_profits) AS month_vary  -- Calculate the difference between max and min profit for the month
FROM 
    orders AS o
JOIN 
    order_details AS od ON o.order_id = od.order_id  -- Join orders with order details
WHERE 
    EXTRACT(YEAR FROM o.order_date) = '2018'  -- Filter for orders from the year 2018
GROUP BY 
    1  -- Group by the month number
;



/*Question#13: Which was the biggest order regarding sales in 2015?*/


SELECT 
    od.order_id,  -- Select order ID
    MAX(od.order_sales) AS biggest_sale  -- Get the maximum sale amount for the order
FROM 
    orders AS o
JOIN 
    order_details AS od ON o.order_id = od.order_id  -- Join orders with order details
WHERE 
    EXTRACT(YEAR FROM o.order_date) = '2015'  -- Filter for orders from the year 2015
GROUP BY 
    1  -- Group by order ID
ORDER BY 
    2 DESC  -- Order by biggest sale in descending order
LIMIT 
    1  -- Limit to the order with the largest sale
;



/*Question#14: What was the rank of each city in the East region in 2015 in quantity?*/


WITH quantity_per_city AS (
    -- Get total quantity of orders per city in the 'East' region for 2015
    SELECT
        o.shipping_city,  -- Select shipping city
        SUM(od.quantity) AS total_quantity  -- Calculate total quantity of orders per city
    FROM 
        orders AS o
    JOIN 
        order_details AS od ON o.order_id = od.order_id  -- Join orders with order details
    WHERE
        o.shipping_region = 'East'  -- Filter for orders in the 'East' region
        AND EXTRACT(YEAR FROM o.order_date) = '2015'  -- Filter for orders from the year 2015
    GROUP BY
        1  -- Group by shipping city
    ORDER BY
        2 DESC  -- Order by total quantity in descending order
)

SELECT 
    shipping_city,  -- Select shipping city
    DENSE_RANK() OVER (ORDER BY total_quantity DESC) AS rank  -- Rank cities by total quantity
FROM
    quantity_per_city
;



/*Question#15: Display customer names for customers who are in the segment ‘Consumer’ or ‘Corporate.’
How many customers are there in total?*/


SELECT
    DISTINCT customer_name  -- Select distinct customer names (647 customers)
FROM
    customers
WHERE 
    customer_segment IN ('Consumer', 'Corporate');  -- Filter for customers in 'Consumer' or 'Corporate' segments



/*Question#16: Calculate the difference between the largest and smallest order quantities for product id ‘100.’*/


SELECT
    MAX(od.quantity) - MIN(od.quantity) AS diff_between_largest_smallest_qua  -- Calculate the difference between the largest and smallest quantities
FROM 
    product AS p
JOIN
    order_details AS od ON od.product_id = p.product_id  -- Join products with order details
WHERE 
    p.product_id = '100'  -- Filter for the product with product_id '100'
;


/*Question#17: Calculate the percent of products that are within the category ‘Furniture.’ */


SELECT
    100 * ROUND(COUNT(DISTINCT product_id) FILTER (WHERE product_category = 'Furniture')
                / COUNT(DISTINCT product_id)::NUMERIC, 2) || '%' AS perc_of_prod        -- Calculate the percentage of products in the 'Furniture' category, rounded to 2 decimal places
FROM 
    product
;



/*Question#18: Display the number of product manufacturers with more than 1 product in the product table.*/


SELECT
    COUNT(DISTINCT product_manufacturer)  -- Count distinct manufacturers with more than one product
FROM (
    SELECT
        product_manufacturer  -- Select product manufacturer
    FROM 
        product 
    GROUP BY 
        1  -- Group by product manufacturer
    HAVING 
        COUNT(product_id) > 1  -- Only include manufacturers with more than one product
) AS filtered_manufacturer
;



/*Question#19: Show the product_subcategory and the total number of products in the subcategory.
Show the order from most to least products and then by product_subcategory name ascending.*/


SELECT
    product_subcategory,  -- Select product subcategory
    COUNT(product_id) AS total_products  -- Count the total number of products in each subcategory
FROM 
    product
GROUP BY 
    1  -- Group by product subcategory
ORDER BY
    2 DESC, 1  -- Order by total products in descending order, and by subcategory name in ascending order as a tiebreaker
;


/*Question#20: Show the product_id(s), the sum of quantities, where the total sum of its product quantities is greater than 
or equal to 100.*/


SELECT
    product_id,  -- Select product ID
    SUM(quantity) AS total_quantity  -- Sum the total quantity of each product
FROM
    order_details
GROUP BY 
    1  -- Group by product ID
HAVING 
    SUM(quantity) >= 100  -- Only include products where the total quantity is 100 or more
;
