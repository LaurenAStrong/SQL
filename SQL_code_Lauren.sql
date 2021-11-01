# Task:
# Find the client with the most orders. The order_number is the primary key, and there is only one client with the highest 
# number of orders. 

# Table 1: Orders
# order_number      client_id
# 1 					 1
# 2						 2
# 3						 2
# 4						 3

# Base case:
SELECT client_id
FROM Orders
GROUP BY client_id
ORDER BY count(order_number) DESC
LIMIT 1;


#Edge case: If there was a tie between top orders, we could use a subquery or window function.for

# Edge case: With subquery:
SELECT client_id 
FROM Orders
GROUP BY client_id
HAVING count(order_number) =
    (SELECT count(order_number)
    FROM Orders
    GROUP BY client_id
    ORDER BY count(order_number) DESC
    LIMIT 1);

# Edge case: With window function:
SELECT rk.client_id
FROM 
(SELECT client_id ,dense_rank() over (order by count(order_number) desc) as order_rank
	FROM Orders 
	GROUP BY client_id) AS rk
	WHERE rk.order_rank = 1;



# Task:
# Find the product with more than 5 customers

#Table 1: Products
# product_id      customer_id
# 1 					 1
# 2						 2
# 3						 2
# 4						 3
# 1 					 22
# 1						 5
# 1						 8
# 1						 3
# 1 					 21
# 2						 3
# 3						 2
# 4						 5


# Base case
SELECT product_id
FROM Products
GROUP BY product_id
HAVING COUNT(customer_id) >5;


# With a subquery wtih temporary table
SELECT product_id
FROM 
    (SELECT product_id, COUNT(DISTINCT customer_id) AS num
    FROM Products
    GROUP BY product_id) AS temp
WHERE num >= 5;


