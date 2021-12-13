# Advanced SQL Code and Analytics

This repository documents the process of extracting data from a `SQL` database and includes notes on the subtleties of the `MySQL` language.

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
WHERE avg_price > national_average;
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

This is a fun one that requires us to use the `DATEDIFF` function and use `HAVING` once the user ids are grouped together. We are finding the ids of the users who are defined as Active in our database. In this situation, we define Active as users who have 5 or more consecutive days logged in. We use `HAVING` instead of `WHERE` after `GROUP BY` because we want to count the ids inside each group, instead of counting the rows before the grouping, as `WHERE` would do. In the SQL order of operations, `WHERE` is executed before `GROUP BY`, whereas `HAVING` is executed after `GROUP BY`. Lastly, we added in a self join here as well! 

``` sql
SELECT DISTINCT Logins1.id, 
   (SELECT name 
   FROM accounts 
   WHERE id = Logins1.id) AS name
FROM logins AS Logins1, logins AS Logins2
WHERE Logins1.id = Logins2.id AND DATEDIFF(Logins1.login_date, Logins2.login_date) BETWEEN 1 AND 4
GROUP BY Logins1.id, Logins1.login_date
HAVING COUNT(DISTINCT Logins2.login_date) = 4;
```

Finally, the problem asks use to get the project names of the projects that are on track to be overbudget. A project budget is based off of employee salaries and needs to be prorated for the length of time for each individual project so each employee’s salary is only included for the duration of the project, and not the entire year. To do this, we convert the end date and start date into the MySQL date format with `::DATE`. In addition, we include a subquery within the `FROM` statement.

``` sql

SELECT title,
       budget,
       CEILING(prorated_expenses) AS prorated_employee_expense
FROM
  (SELECT title,
          budget,
          (end_date::DATE - start_date::DATE) * (sum(salary)/365) AS prorated_expenses
   FROM google_projects 
   JOIN google_emp_projects ON google_projects.id = google_emp_prjects.project_id
   JOIN google_employees ON google_emp_projects.emp_id = google_employees.id
   GROUP BY title,
            budget,
            end_date,
            start_date) AS from_query
WHERE prorated_expenses > budget
ORDER BY title ASC;
``` 



