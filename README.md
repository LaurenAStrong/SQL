# Advanced SQL Code and Analytics

This repository documents the process of extracting data from a `SQL` database and includes notes on the subtletlies of the `MySQL` language.

First is an example of utilizing CTEs and combining them in a query later to find which cities in a Zillow Transactions database have an average market listing price above the national average.

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









