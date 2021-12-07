# Advanced SQL Code and Analytics

This repository documents the process of extracting data from a `SQL` database and includes notes on the subtletlies of the `MySQL` language.

First, is an example of utilizing CTEs and combining them in a query later to find which cities in a Zillow Transactions database have an average market listing price above the national average.

```sql
 with city_average as (
    select 
        city 
        , avg(mkt_price) as avg_price
    from zillow_transactions z
    group by 1 
) 
, national_average as ( 
    select 
        city 
        , avg_price 
        , avg(avg_price) over () as national_average
    from city_average
) 
select 
    distinct city 
from national_average 
where avg_price > national_average
```

Second, we are tasked with finding which worker has the highest salary. We could use `ORDER DESC` and `LIMIT 1`, but use the `DENSE_RANK()` function here since if there is a tie for the highest salary among more than 1 employee, we will get the full list of ties, whereas we wouldn’t be able to do so had we not used a window function such as `DENSE_RANK()` In total, in this query, we use a CTE to join two tables and perform a ranking with the window function, and then select the ranking that is equal to the highest rank of 1. 

```sql
WITH Ranking AS (
SELECT  title.worker_title, DENSE_RANK() OVER (ORDER BY salary DESC) as rnk
    FROM worker
    JOIN title
    ON worker.worker_id = title.worker_ref_id)

SELECT worker_title
FROM Ranking
WHERE rnk = 1;
```









