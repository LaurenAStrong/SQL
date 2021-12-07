# Advanced SQL Code and Analytics

This repository documents the process of extracting data from a `SQL` database and includes notes on the subtletlies of the `MySQL` language.

First, is an example of utilizing CTEs and combining them in a query later to find which cities in a Zillow Transactions database have an average market listing price above the national average.

```sql
 WITH city_average AS (
    SELECT city, AVG(mkt_price) AS avg_price
    FROM zillow_transactions
    GROUP BY city), 
 
 national_average AS ( 
    SELECT city, avg_price, AVG(avg_price) OVER() AS national_average
    FROM city_average) 

SELECT DISTINCT city 
FROM national_average 
WHERE avg_price > national_average
```

Second, we are tasked with finding which worker has the highest salary. We could use `ORDER DESC` and `LIMIT 1`, but use the `DENSE_RANK()` function here since if there is a tie for the highest salary among more than 1 employee, we will get the full list of ties, whereas we wouldn’t be able to do so had we not used a window function such as `DENSE_RANK()` In total, in this query, we use a CTE to join two tables and perform a ranking with the window function, and then select the ranking that is equal to the highest rank of 1. 

```sql
WITH Ranking AS (
SELECT  title.worker_title, DENSE_RANK() OVER (ORDER BY salary DESC) AS rnk
    FROM worker
    JOIN title
    ON worker.worker_id = title.worker_ref_id)

SELECT worker_title
FROM Ranking
WHERE rnk = 1;
```

This is a fun one that requires us to use the `DATEDIFF` function and use `HAVING` once the user ids are grouped together. We are finding the ids of the users who are defined as Active in our databasae. In this situation, we define Active as users who have 5 or more consecutive days logined in. We use `HAVING` instead of `WHERE` after `GROUP BY` because we want to count the ids inside each group, instead of counting the rows before the grouping, as `WHERE` would do. In the SQL order of operations, `WHERE` is executed before `GROUP BY`, whereas `HAVING` is executed after `GROUP BY`. Lastly, we added in a self join here as well! 

```sql
SELECT DISTINCT Logins1.id, (SELECT name FROM accounts WHERE id=Logins1.id) AS name
FROM logins AS Logins1, logins AS Logins2
WHERE Logins1.id = Logins2.id AND DATEDIFF(Logins1.login_date, Logins2.login_date) BETWEEN 1 AND 4
GROUP BY Logins1.id, Logins1.login_date
HAVING COUNT(DISTINCT Logins2.login_date) = 4
```
