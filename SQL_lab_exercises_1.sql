-- LAB TEST 0


-- Chapter 1-3

-- b) Write a query that lists all the tables in your group database. 
sp_tables;

-- Chapter 4

-- c) Write a query that lists all the unique order numbers from the orderitems table. 
SELECT DISTINCT order_num
FROM orderitems;

-- d) Write a query that lists 2 records from the orderitems table.
SELECT TOP(2) *
FROM orderitems;

-- Chapter 5

-- b) Write  a  query  that  lists  the  three  products  with  the  highest  item  prices  (with descending ordering).
SELECT TOP(3) *
FROM orderitems
ORDER BY item_price DESC;

-- Chapter 6

-- b) List the customers with a cust_id between 10002 and 10004.
SELECT cust_id, cust_name
FROM customers
WHERE cust_id BETWEEN 10002 AND 10004;

-- c) List the customers (cust_name and cust_id) that have an email address and are in zipcode 44444.
SELECT *
FROM customers
WHERE cust_email IS NOT NULL AND cust_zip = 44444;

-- Chapter 7

-- b) List the order items with order_num 20005 or 20009 and with an item_price >= 10, order by prod_id.
-- Use an or operator in your statement.
SELECT *
FROM orderitems
WHERE (order_num = 20005 OR order_num = 20009) AND item_price >= 10
ORDER BY prod_id;

-- c) List the order items with order_num 20005 or 20009 and with an item_price >= 10, order by prod_id.
-- Use an in operator in your statement.
SELECT *
FROM orderitems
WHERE order_num IN (20005,20009) AND item_price >= 10
ORDER BY prod_id;

-- d) List all the records from the OrderItems table that do not match the properties listed in 7b).
SELECT *
FROM orderitems
WHERE order_num NOT IN (20005,20009) OR item_price < 10
ORDER BY prod_id;



-- LAB TEST 1



-- Chapter 8

-- b) List the order items that have a prod_id that contain a numeric value.
SELECT *
FROM orderitems
WHERE prod_id LIKE '%[0-9]%';

-- c) List the order items that have a prod_id that does not contain a numeric value.
SELECT *
FROM orderitems
WHERE NOT prod_id LIKE '%[0-9]%';

-- d) Store the result of the previous query (8c) in a temporary table.
-- Include your unique student number in the table’s name (e.g. ‘#Q8d_1034561’).
-- Write a query to show all the records of this table. After that remove (i.e. drop) the temporary table.
SELECT *
INTO Q8d_2088800
FROM orderitems
WHERE NOT prod_id LIKE '%[0-9]%';

SELECT *
FROM Q8d_2088800;

DROP TABLE Q8d_2088800;

-- e) List 10 records from the table Patstat where the column ‘npl_biblio’ does not contain any numeric values, but does contain the words ‘et al’.
-- Store the results in a temporary table. Select in this temporary table the records that end with ‘abstract.’.
-- After that drop the temporary table.

SELECT TOP(10) *
INTO Q8e_2088800
FROM Patstat
WHERE NOT (npl_biblio LIKE '%[0-9]%') AND npl_biblio LIKE '%et al%';

SELECT *
FROM Q8e_2088800
WHERE npl_biblio LIKE '%abstract.';

DROP TABLE Q8e_2088800;

-- Chapter 9

-- b) List all the fields from the Customer table, and include the additional fields ‘cust_address_city’,
-- which is the concatenation of customer address and city (separated with a single space) and the field ‘initial’,
-- which is the first character of the field ‘cust_contact’.
SELECT * , (RTrim(cust_address) + ' ' + cust_city) AS cust_address_city, LEFT(cust_contact, 1) AS initial
FROM customers;

-- c) Limit the number of records of the query in 9b, by a query that only shows customers with an initial that starts with a ‘J’.
SELECT * , (RTrim(cust_address) + ' ' + cust_city) AS cust_address_city, LEFT(cust_contact, 1) AS initial
FROM customers
WHERE LEFT(cust_contact, 1) = 'J';

-- d) Write a query that computes the result of (100 * 10) module 10 with the column name ‘Result’.
SELECT ((100*10)%10) AS Result;

-- e) Write a query that lists the current date and time with the column name ‘CurrentDate’.
SELECT GETDATE() as CurrentDate;

-- Chapter 10

-- b) Write a query that lists the column cust_email from the Customers table,
-- together with a new column with the name ‘cust_email_domain’ that gives only the domain of an email, e.g. ‘coyote.com’.
SELECT cust_email, SUBSTRING(cust_email, CHARINDEX('@', cust_email)+1, LEN(cust_email) - CHARINDEX('@', cust_email)+1) AS cust_email_domain
FROM customers;

-- c) Write a new query based on the query in 10b), where the ‘com’ in the new column is replaced by ‘org’.
SELECT cust_email, REPLACE(SUBSTRING(cust_email, CHARINDEX('@', cust_email)+1, LEN(cust_email) - CHARINDEX('@', cust_email)+1), '.com', '.org') AS cust_email_domain
FROM customers;

-- d) Write a query that lists the columns order_num, order_date, and the calculated (numeric) columns:
-- year, quarter, and month. Order the result by year, quarter, and month.
SELECT order_num, order_date, Year(order_date) AS 'year', DATEPART(QUARTER, order_date) AS 'quarter', Month(order_date) AS 'month'
FROM orders
ORDER BY year, quarter, month;

-- e) Write a query that lists the columns order_num, order_date, and the calculated columns: year, quarter, month, and day.
-- However, day should be represented as a text value (week day). Find all orders made during the weekend.
SELECT order_num, order_date, Year(order_date) AS 'year', DATEPART(QUARTER, order_date) AS 'quarter', Month(order_date) AS 'month', DateName(weekday, Day(order_date)) AS 'day'
FROM orders
WHERE DateName(weekday, Day(order_date)) IN ('Saturday', 'Sunday')
ORDER BY year, quarter, month, day;

-- f) Write a query that rounds the item_price as follows, 5.99 to 6.00 and 2.50 to 3.00.
-- The query should include the original item_price and the rounded item_price.
SELECT *, ROUND(item_price, 0) AS rounded_item_price
FROM orderitems;

-- g) Briefly study the ranking functions on https://docs.microsoft.com/en-us/sql/t-sql/functions/ranking-functions-transact-sql.
-- Add a ranking to a temporary copy of the Ordersitems table for the item_prices, and create queries that produce the exact result of the table below where the ranking <= 4.
SELECT *
INTO #temp
FROM orderitems;

SELECT *, DENSE_RANK() OVER (ORDER BY item_price DESC) AS 'ranking'
INTO #temp2
FROM #temp

SELECT *
FROM #temp2
WHERE ranking <= 4;

DROP TABLE #temp, #temp2;

-- Chapter 11

-- b) Write a query that sums all the ‘item_prices’ in the orderitems table.
-- Label the result column as ‘price_sum_total’.
SELECT SUM(item_price) AS price_sum_total
FROM orderitems;

-- c) Write a query that counts the number of unique elements in the column ‘npl_biblio’ from the table Patstat.
-- Label the result column as ‘count_npl_biblio_unique’.
SELECT COUNT(DISTINCT npl_biblio) AS count_npl_biblio_unique
FROM Patstat

-- d) Revenues is computed as (quantity * itemprice), in the orderitems table.
-- Write a single query that computes the sum of the revenues, and gives the maximum and minimum revenues.
SELECT SUM(revenue) AS sum, MAX(revenue) AS max, MIN(revenue) AS min
FROM (SELECT *, quantity*item_price AS revenue FROM orderitems) as rev

-- Chapter 12

-- b) Write a query that includes order_num, and that counts the number of orders per order_num (label as ‘order_num_count’)
-- and summarizes the revenue per order_num (label as ‘order_num_revenue’).
-- Only show results where the order_num_revenue >= 100. Order the result on ‘order_num_revenue’ in an ascending way.
SELECT order_num, COUNT(*) AS 'order_num_count', SUM(quantity*item_price) AS 'order_num_revenue'
FROM orderitems
GROUP BY order_num
HAVING SUM(quantity*item_price) >= 100
ORDER BY order_num_revenue ASC;

-- c) Write a query that includes prod_id, and that counts the number of orders per prod_id (label as prod_id_count’)
-- and summarizes the revenue per prod_id (label as ‘prod_id_revenue’).
-- Only show results where the prod_id_revenue >= 50 and prod_id_revenue <= 150.
-- Order the result on ‘prod_id_revenue’ in an ascending way.
SELECT prod_id, COUNT(*) AS 'prod_id_count', SUM(quantity*item_price) AS 'prod_id_revenue'
FROM orderitems
GROUP BY prod_id
HAVING SUM(quantity*item_price) BETWEEN 50 AND 150
ORDER BY prod_id_revenue ASC;

-- d) Write a query that finds the ‘npl_biblio’ (scientific references) from the table Patstat with exactly 21 duplicates, i.e. 21 identical scientific records.
SELECT npl_biblio, COUNT(*) AS 'npl_biblio_count'
FROM Patstat
GROUP BY npl_biblio
HAVING COUNT(*) = 21;

-- e) Write a query, related to table xemp, that answers the question: 'Which department(s) has (have) the highest average salary?'.
-- Your result should include both the department name and its average salary. Do not use Top, but the Max function.
SELECT deptname, AVG(empsalary) AS avg_salary
FROM xemp
GROUP BY deptname
ORDER BY avg_salary DESC;


-- LAB TEST 2


-- Chapter 13

-- b) Find the customer details (‘cust_name’ and ‘cust_contact’) who did not order items ‘TNT2’ or ‘SLING’.
-- Be sure to implement subqueries.
SELECT cust_name, cust_contact
FROM customers
WHERE cust_id NOT IN (SELECT cust_id
                     FROM orders
                     WHERE order_num IN (SELECT order_num
                                      FROM orderitems
                                      WHERE prod_id IN ('TNT2', 'SLING')));

-- d) Find all the customers that did not place any orders. Use a ‘not in’ clause.
SELECT cust_name, cust_contact
FROM customers
WHERE cust_id NOT IN (SELECT cust_id
                        FROM Orders);

-- e) Find all the customers that did not place any orders. Use a ‘not exists’ clause.
SELECT cust_name, cust_contact
FROM customers
WHERE NOT EXISTS (SELECT *
                FROM Orders
                WHERE orders.cust_id = customers.cust_id);

-- f) Find the customer name and ID for any customer who did not made orders in the month of September 2005.
-- Use an ‘exists’ clause in your query.
SELECT cust_name, cust_id
FROM customers
WHERE NOT EXISTS (SELECT *
            FROM orders
            WHERE DateDiff(month, order_date,'2005-09-01') = 0 AND customers.cust_id = orders.cust_id);

-- g) In the table ‘patstat_golden_set’, publications are listed and assigned to clusters (1- 100).
-- Write a query that will find the cluster_id with the highest number of publications.
-- List both the cluster_id and the total number of publications in your result.
SELECT TOP(1) cluster_id, COUNT(*) AS total_publications
FROM patstat_golden_set
GROUP BY cluster_id
ORDER BY total_publications DESC


-- Chapter 14

-- b) Find the Cartesian product of customers and order. Order the records by cust_id, and order_num.
SELECT *
FROM customers, orders
ORDER BY customers.cust_id, orders.order_num;

-- c) Recreate the query on page 126 by a query that uses an (inner) join clause instead of a where clause.
-- Be sure to use alias names for the tables (e.g. labels ‘a’ and ‘b’).
SELECT vend_name, prod_name, prod_price
FROM vendors as a INNER JOIN products as b
ON a.vend_id = b.vend_id
ORDER BY vend_name, prod_name;

-- d) List all the prod_id’s that where ordered by the customer ‘Coyote Inc.’ Order the result by prod_id.
SELECT prod_id
FROM customers, orders, orderitems
WHERE customers.cust_id = orders.cust_id
    AND orders.order_num = orderitems.order_num
    AND cust_name = 'Coyote Inc.'
ORDER BY prod_id

-- Chapter 15

-- b) Find all the customers that did not place any orders. Use a specific type of join.
SELECT customers.cust_name, customers.cust_id, COUNT(orders.order_num) AS num_ord
FROM customers LEFT OUTER JOIN orders
ON customers.cust_id = orders.cust_id
GROUP BY customers.cust_name, customers.cust_id
HAVING COUNT(orders.order_num) = 0

-- c) Create a full outer join between the tables customer, order, and orderitems.
-- Only show the fields for orders and orderitems.
SELECT orders.*, orderitems.*
FROM customers FULL OUTER JOIN orders ON customers.cust_id = orders.cust_id
FULL OUTER JOIN orderitems ON orders.order_num = orderitems.order_num;

-- d) List all order items that that have the same ‘item_price’ (from the table orderitems).
-- Exclude items which have the same ‘prod_id’ and ‘order_num’.
SELECT b.prod_id, a.item_price
FROM orderitems AS a
JOIN orderitems AS b
ON a.item_price = b.item_price
WHERE a.order_item = b.order_item
AND (a.prod_id != b.prod_id OR a.order_num != b.order_num);

-- e) This question relates to the table Patstat.
-- I) Store all records with an even npl_publn_id in a temporary table called #even. Include all columns in your query.
SELECT *
INTO #even
FROM Patstat
WHERE npl_publn_id % 2 = 0;

SELECT*
FROM #even;

-- II) Store all records with an odd npl_publn_id in a temporary table called #odd. Include all columns in your query.
SELECT *
INTO #odd
FROM Patstat
WHERE npl_publn_id % 2 = 1;

SELECT*
FROM #odd;

-- III) Which even npl_publn_id(‘s) has/have the most matching (identical) npl_biblio’s in the table #odd?
-- Show a top 5, with the dense_rank() function, of the unique even npl_publn_id’s,
-- with a count of their number of matching npl_biblio’s (label as column ‘size’) in #odd,
-- and the description of the publication (npl_biblio).
SELECT *
FROM 
    (SELECT #even.npl_publn_id, #even.npl_biblio, COUNT(*) as size, DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) AS rank
    FROM #even INNER JOIN #odd 
    ON #even.npl_biblio = #odd.npl_biblio
    GROUP BY #even.npl_publn_id, #even.npl_biblio) as #temp
WHERE rank <= 5

-- IV) Drop all the temporary tables you have created.
DROP TABLE #odd, #even, #temp

-- Chapter 18

-- b)
create table #tmp (order_num int null);

INSERT INTO #tmp(order_num)
select distinct b.order_num
     from customers as a
     join orders as b on a.cust_id = b.cust_id
     join orderitems as c on b.order_num = c.order_num
     where cust_city in ('Detroit','Chicago') or item_price > 10;

SELECT *
FROM #tmp;

-- c) Insert the order numbers: 20010, 20011, 20012, and 20013 into the table ‘#tmp’.
-- List all the records in table ‘#tmp’.
INSERT INTO #tmp(order_num)
VALUES (20010), (20011), (20012), (20013);

SELECT *
FROM #tmp;

-- d) Make a copy, with the name #tmp2, of the table #tmp with a select into statement.
-- After that insert 3 records with null values. View your results.
SELECT order_num
INTO #tmp2
FROM #tmp;

INSERT INTO #tmp2
VALUES (NULL), (NULL), (NULL);

SELECT *
FROM #tmp2;

-- Chapter 19

-- b) Delete all rows in #tmp2 (from the previous questions), where the ‘order_num’ is null or larger than or equal to ‘20010’.
DELETE FROM #tmp2
WHERE order_num IS NULL OR order_num >= 20010;

-- c) Delete all rows from #tmp. After that drop both tables.
DELETE FROM #tmp;

DROP TABLE #tmp, #tmp2;

-- d) Make a copy of the table orderitems, with the name #orderitems.
-- In the table #orderitems update item_prices as follows: item_prices with a quantity > 1 are multiplied by 10
-- and item_prices with quantity 1 are multiplied by 5. After that drop the table #orderitems.
SELECT *
INTO #orderitems
FROM Orderitems;

UPDATE #orderitems
SET item_price = item_price*10
WHERE quantity > 1;

UPDATE #orderitems
SET item_price = item_price*5
WHERE quantity = 1;

SELECT*
FROM #orderitems

DROP TABLE #orderitems

-- e) Make a permanent copy of the table customers, with the name customers_[studentnumber].
-- In this new table, update the field ‘cust_email’ for customers with a replacement of ‘com’ with ‘org’.
-- Only update customers that are associated with ‘order_num’ 20005 and 20009.
-- After that drop the table customers_[studentnumber]. Please do not update or drop the original Customers table.
SELECT *
INTO customers_2088800
FROM Customers;

UPDATE customers_2088800
SET cust_email = REPLACE(cust_email, 'com', 'org')
WHERE cust_id IN (SELECT cust_id
                    FROM Orders
                    WHERE order_num IN (20005,20009));

SELECT *
FROM customers_2088800;

DROP TABLE customers_2088800;

