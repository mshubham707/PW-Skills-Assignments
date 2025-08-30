
use assignment;

/*
=====================
SQL BASICS QUESTIONS
=====================
*/

/*
1. Create a table called employees with the following structure:
   emp_id (integer, should not be NULL and should be a primary key)
   emp_name (text, should not be NULL)
   age (integer, should have a check constraint to ensure the age is at least 18)
   email (text, should be unique for each employee)
   salary (decimal, with a default value of 30,000).
   -> Write the SQL query to create the above table with all constraints.
*/

create table employees ( emp_id int primary key , 
						emp_name varchar(20) not null,
                        age int check(age>=18), 
                        email varchar(30) unique, 
                        salary decimal(10,2) default 30000
                        );


/*
2. Explain the purpose of constraints and how they help maintain data integrity in a database. 
   Provide examples of common types of constraints.
Ans. Constraints are as the name suggests the limit or check on the column values preventing any unwanted or invalid values to get inserted into the table
	 thus maintaining data intergrity in the database.
     Examples of constraints are:
			- NOT NULL: preventing null values in a column
					(ex. emp_name varchar(20) not null)
            - UNIQUE: ensuring values are unique
					(ex. email varchar(30) unique)
            - DEFAULT: dealing with null values by defining a default value
					(ex. salary decimal(10,2) default 30000)
			- CHECK: ensure value meets the condition
					(ex. age int check(age>=18))
            - PRIMARY KEY: unique identifier to each row (not null and unique)
					(ex. emp_id int primary key)
            - FOREIGN KEY: to establish relationship between two tables
					(ex. dept_id INT REFERENCES department(dept_id))
   
*/

/*
3. Why would you apply the NOT NULL constraint to a column? 
   Can a primary key contain NULL values? Justify your answer.
Ans. Some columns cannot be null such as an employee id or a student id or let's say the name of emloyee/student thus applying the NOT NULL constraint helps preventing that.
	 No a PRIMARY KEY means NOT NULL and UNIQUE which acts a unique identifer to the row hence you won't want a primary key to be having null values.
   
*/

/*
4. Explain the steps and SQL commands used to add or remove constraints on an existing table. 
   Provide an example for both adding and removing a constraint.
Ans.  Let's say employees table is an existing table with no constraints already there.
*/
	  -- To add a constraint:
			ALTER TABLE employees 
            ADD CONSTRAINT check_age CHECK( age >=30);
	   -- To remove a constraint:
			ALTER TABLE employees 
            DROP CONSTRAINT check_age;		
 


/*
5. Explain the consequences of attempting to insert, update, or delete data in a way that violates constraints. 
   Provide an example of an error message that might occur when violating a constraint.
Ans. If you try to enter an inavlid value into the column violating the constraint it will throw an error saying the violation is done.
		
*/
insert into employees (emp_id, emp_name, age, email) values (101, "SM", 20, "sm12@exmple.com"), (102, "KL", 17, "kl21@co.in") ; #age>=18
-- Error Code: 3819. Check constraint 'employees_chk_1' is violated.

/*
6. You created a products table without constraints as follows:
   CREATE TABLE products (
       product_id INT,
       product_name VARCHAR(50),
       price DECIMAL(10, 2));
   Now, you realise that:
   - product_id should be a primary key
   - price should have a default value of 50.00
*/

   CREATE TABLE products (
       product_id INT,
       product_name VARCHAR(50),
       price DECIMAL(10, 2));
	ALTER TABLE products
	ADD CONSTRAINT pk_id PRIMARY KEY (product_id);
    ALTER TABLE products
	ALTER COLUMN price SET DEFAULT 50.00;
    
/*
7. You have two tables:
   -> Write a query to fetch the student_name and class_name for each student using an INNER JOIN.
*/

CREATE TABLE classes (class_id INT PRIMARY KEY, class_name VARCHAR(20));
CREATE TABLE students (student_id INT PRIMARY KEY, student_name VARCHAR(20), class_id INT REFERENCES classes(class_id));
INSERT INTO classes values (101, 'Math'), (102, 'Science'), (103, 'History');
INSERT INTO students values (1, 'Alice', 101), (2, 'Bob', 102), (3, 'Charlie', 101);
-- join to fetch student_name and class_name
SELECT student_name, class_name from students as s
	 JOIN classes as c
     ON s.class_id = c.class_id;

/*
8. Consider the following three tables:

customers
+-------------+---------------+
| customer_id | customer_name |
+-------------+---------------+
| 101         | Alice         |
| 102         | Bob           |
+-------------+---------------+

orders
+----------+------------+-------------+
| order_id | order_date | customer_id |
+----------+------------+-------------+
|    1     | 2024-01-01 |    101      |
|    2     | 2024-01-03 |    102      |
+----------+------------+-------------+

products

+------------+--------------+----------+
| product_id | product_name | order_id |
+------------+--------------+----------+
|     1      | Laptop       |    1     |
|     2      | Phone        |  NULL    |
+------------+--------------+----------+


   -> Write a query that shows all order_id, customer_name, and product_name,
      ensuring that all products are listed even if they are not associated with an order.
      (Hint: use INNER JOIN and LEFT JOIN)
*/
-- Customers Table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50) NOT NULL
);

-- Orders Table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    order_date DATE NOT NULL,
    customer_id INT,
    CONSTRAINT fk_customer FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Products Table
DROP TABLE if exists products ;
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50) NOT NULL,
    order_id INT NULL,
    CONSTRAINT fk_order FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

-- Insert data into Customers
DROP TABLE if exists customers;
INSERT INTO Customers (customer_id, customer_name) VALUES
(101, 'Alice'),
(102, 'Bob');

-- Insert data into Orders
DROP TABLE if exists orders;
INSERT INTO Orders (order_id, order_date, customer_id) VALUES
(1, '2024-01-01', 101),
(2, '2024-01-03', 102);

-- Insert data into Products
DROP TABLE if exists products;
INSERT INTO Products (product_id, product_name, order_id) VALUES
(1, 'Laptop', 1),
(2, 'Phone', NULL);

SELECT o.order_id, c.customer_name, p.product_name
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
RIGHT JOIN products as p
ON o.order_id = p.order_id
;

/*
9. Given the following tables:

products
+------------+--------------+
| product_id | product_name |
+------------+--------------+
|    101     | Laptop       |
|    102     | Phone        |
+------------+--------------+

sales
+---------+------------+--------+
| sale_id | product_id | amount |
+---------+------------+--------+
|    1    |    101     |  500   |
|    2    |    102     |  300   |
|    3    |    101     |  700   |
+---------+------------+--------+

   -> Write a query to find the total sales amount for each product using an INNER JOIN and the SUM() function.
*/
-- Products Table
DROP TABLE if exists products;
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50) NOT NULL
);

-- Sales Table
DROP TABLE if exists sales;
CREATE TABLE Sales (
    sale_id INT PRIMARY KEY,
    product_id INT,
    amount DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_product FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Insert data into Products
INSERT INTO Products (product_id, product_name) VALUES
(101, 'Laptop'),
(102, 'Phone');

-- Insert data into Sales
INSERT INTO Sales (sale_id, product_id, amount) VALUES
(1, 101, 500),
(2, 102, 300),
(3, 101, 700);

select product_name, sum(amount) As Total_Sale_Amount
from products as p
join sales as s
on p.product_id = s.product_id
group by product_name; 

/*
10. You are given three tables:

customers
+-------------+---------------+
| customer_id | customer_name |
+-------------+---------------+
|      1      | Alice         |
|      2      | Bob           |
+-------------+---------------+

orders
+----------+------------+-------------+
| order_id | order_date | customer_id |
+----------+------------+-------------+
|    1     | 2024-01-02 |      1      |
|    2     | 2024-01-05 |      2      |
+----------+------------+-------------+

order details
+----------+------------+----------+
| order_id | product_id | quantity |
+----------+------------+----------+
|    1     |    101     |    2     |
|    1     |    102     |    1     |
|    2     |    101     |    3     |
+----------+------------+----------+

   -> Write a query to display the order_id, customer_name, and the quantity of products 
      ordered by each customer using an INNER JOIN between all three tables.
*/
-- Customers Table
drop table if exists customers;
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50) NOT NULL
);

-- Orders Table
DROP TABLE if exists orders;
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    order_date DATE NOT NULL,
    customer_id INT,
    CONSTRAINT fk_customer FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Order_Details Table
DROP TABLE if exists order_details; 
CREATE TABLE Order_Details (
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    PRIMARY KEY (order_id, product_id),
    CONSTRAINT fk_order FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

-- Insert into Customers
INSERT INTO Customers (customer_id, customer_name) VALUES
(1, 'Alice'),
(2, 'Bob');

-- Insert into Orders
INSERT INTO Orders (order_id, order_date, customer_id) VALUES
(1, '2024-01-02', 1),
(2, '2024-01-05', 2);

-- Insert into Order_Details
INSERT INTO Order_Details (order_id, product_id, quantity) VALUES
(1, 101, 2),
(1, 102, 1),
(2, 101, 3);

select o.order_id, c.customer_name, sum(od.quantity) as total_quantity
from customers as c
left join orders as o
on c.customer_id = o.customer_id
left join order_details as od
on o.order_id = od.order_id
group by o.order_id, customer_name;


/*
=====================
SQL COMMANDS (Maven Movies DB)
=====================
*/
use mavenmovies;
/*
1. Identify the primary keys and foreign keys in Maven Movies DB. Discuss the differences.
Ans. Primary key uniquely identifies a row in a table. It is unique and cannot be null.
	 In the Maven Movies DB, some of the primary keys are:
		actor.actor_id, actor_award.actor_award_id,  customer.customer_id, film.film_id, payment.payment_id
     Foregin keys are used to establish a relationship between two tables by refrencing a primary key in another table. 
     Examples of Foreign keys in the Maeven Movies DB are:
		film_actor.actor_id, references actor.actor_id
		film_actor.film_id, references film.film_id
		rental.customer_id, references customer.customer_id
		rental.inventory_id, references inventory.inventory_id
		payment.customer_id, references customer.customer_id
		payment.rental_id, references rental.rental_id
		customer.store_id, references store.store_id
        
*/
SELECT 
    TABLE_NAME,
    COLUMN_NAME,
    CONSTRAINT_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE REFERENCED_TABLE_NAME IS NOT NULL
  AND TABLE_SCHEMA = 'mavenmovies';

/*
2. List all details of actors.
*/
select*from actor;

/*
3. List all customer information from DB.
*/
select*from customer;

/*
4. List different countries.
*/
select country 
from country;

/*
5. Display all active customers.
*/
select first_name, last_name from customer
where active=1;

/*
6. List all rental IDs for customer with ID 1.
*/
select rental_id from rental
where customer_id = 1;


/*
7. Display all the films whose rental duration is greater than 5.
*/
select film_id, title, rental_duration from film
where rental_duration >5;

/*
8. List the total number of films whose replacement cost is greater than $15 and less than $20.
*/
select film_id, title, replacement_cost from film
where replacement_cost > 15 and replacement_cost < 20;

/*
9. Display the count of unique first names of actors.
*/
select count( distinct first_name) as unique_name_count from actor;

/*
10. Display the first 10 records from the customer table.
*/
select*from customer
limit 10;

/*
11. Display the first 3 records from the customer table whose first name starts with ‘b’.
*/
select*from customer
where first_name like 'b%'
limit 3;

/*
12. Display the names of the first 5 movies which are rated as ‘G’.
*/
select film_id, title, rating from film
where rating = 'G'
limit 5;

/*
13. Find all customers whose first name starts with "a".
*/
select*from customer
where first_name like 'a%'
;


/*
14. Find all customers whose first name ends with "a".
*/
select*from customer
where first_name like '%a'
;

/*
15. Display the list of first 4 cities which start and end with ‘a’.
*/
select city from city
where city like '%a'
limit 4;

/*
16. Find all customers whose first name has "NI" in any position.
*/
select*from customer
where first_name like "%NI%";

/*
17. Find all customers whose first name has "r" in the second position.
*/
select*from customer
where first_name like "_r%";

/*
18. Find all customers whose first name starts with "a" and are at least 5 characters in length.
*/
select first_name, length(first_name) name_len from customer
where first_name like "a%" and length(first_name)>=5;
;

/*
19. Find all customers whose first name starts with "a" and ends with "o".
*/
select first_name from customer
where first_name like 'a%o';

/*
20. Get the films with pg and pg-13 rating using IN operator.
*/
select title, rating from film
where rating in ('pg', 'pg-13');

/*
21. Get the films with length between 50 to 100 using BETWEEN operator.
*/

select title, length from film
where length between 50 and 100;


/*
22. Get the top 50 actors using LIMIT operator.
*/
select*from actor
limit 50;

/*
23. Get the distinct film ids from inventory table.
*/
select distinct film_id from inventory;


/*
=====================
FUNCTIONS
=====================
*/

/*
-- Aggregate Functions
1. Retrieve the total number of rentals made in the Sakila database. (COUNT)
*/
select count(*) as total_rental from rental;

/*
2. Find the average rental duration (in days) of movies rented. (AVG)
*/
select avg(rental_duration) as rental_duration_days from film;

/*
-- String Functions
3. Display the first name and last name of customers in uppercase. (UPPER)
*/
select upper(first_name) fn_up, upper(last_name) ln_up from actor;

/*
4. Extract the month from the rental date and display it with rental ID. (MONTH)
*/
select rental_id, month(rental_date) month_no from rental;

/*
-- GROUP BY
5. Retrieve the count of rentals for each customer (customer ID + rental count).
*/
select customer_id, count(rental_id) rental_count from rental
group by customer_id;

/*
6. Find the total revenue generated by each store. (SUM + GROUP BY)
*/ 
select s.store_id, sum(p.amount) total_revenue
from staff as s
left join payment as p 
on s.staff_id = p.staff_id
group by s.store_id
;


/*
7. Determine the total number of rentals for each category of movies.
*/

select c.name, count(x.rental_id) as count
from category c
join film_category fc on c.category_id = fc.category_id
join inventory i on fc.film_id = i.film_id
join
(select r.rental_id, r.inventory_id from customer c
join rental r on r.customer_id = c.customer_id) x
on x.inventory_id = i.inventory_id
group by c.name
;


/*
8. Find the average rental rate of movies in each language.
*/
select l.name, avg(f.rental_rate) as avg_rental_rate from film f
join language l
on l.language_id = f.language_id
group by l.name
;


/*
-- Joins
9. Display the title of the movie, customer’s first name, and last name who rented it.
*/
select  f.title, c.first_name, c.last_name from film f
join inventory i on f.film_id = i.film_id
join rental r on r.inventory_id = i.inventory_id
join customer c on r.customer_id = c.customer_id
;

/*
10. Retrieve the names of all actors who appeared in the film "Gone with the Wind."
*/
select concat(a.first_name, " ", a.last_name) as actor_name from film f
join film_actor fa on fa.film_id = f.film_id
join actor a on a.actor_id = fa.actor_id
where f.title = "Gone with the Wind"
;


/*
11. Retrieve the customer names along with the total amount they've spent on rentals.
*/
select concat(c.first_name," ", c.last_name) as customer_name, sum(amount) as total_amount
from customer c 
join payment p on c.customer_id = p.customer_id
group by customer_name;

/*
12. List the titles of movies rented by each customer in a particular city (e.g., 'London').
*/
select concat(c.first_name," ", c.last_name) as customer_name, f.title from customer c
join address a on c.address_id = a.address_id
join city ci on ci.city_id = a.city_id
join rental r on r.customer_id = c.customer_id
join inventory i on i.inventory_id = r.inventory_id
join film f on f.film_id = i.film_id
where city ="London"
;


/*
-- Advanced Joins & GROUP BY
13. Display the top 5 rented movies along with the number of times rented.
*/
select f.title, count(r.rental_id) as rent_count from film f
join inventory i on i.film_id = f.film_id
join rental r on r.inventory_id = i.inventory_id
group by f.title
order by rent_count desc
limit 5;


/*
14. Determine the customers who have rented movies from both stores (store ID 1 and store ID 2).
*/

select concat(c.first_name," ", c.last_name) as customer_name from customer c
join rental r on r.customer_id = c.customer_id
join inventory i on i.inventory_id = r.inventory_id
group by customer_name
having count(distinct i.store_id) = 2;

/*
=====================
WINDOW FUNCTIONS
=====================
*/

/*
1. Rank the customers based on the total amount they've spent on rentals.
*/
select concat(c.first_name," ", c.last_name) name , sum(p.amount) as total_amount, rank() over(order by sum(p.amount) desc)  rnk
from customer c 
join payment p on p.customer_id = c.customer_id
group by c.first_name, c.last_name
order by rnk;

/*
2. Calculate the cumulative revenue generated by each film over time.
*/

select  f.title, p.payment_date, sum(p.amount) over(partition by f.title order by p.payment_date rows between unbounded preceding and current row) as cum_rev
from film f
join inventory i on i.film_id = f.film_id
join rental r on i.inventory_id = r.inventory_id
join payment p on p.rental_id = r.rental_id
;


/*
3. Determine the average rental duration for each film, considering films with similar lengths.
*/
select title, length, avg(rental_duration) over(partition by length) as avg_rental_duration
from film
;


/*
4. Identify the top 3 films in each category based on rental counts.
*/

with x as (
select   f.title, c.name as category, count(r.rental_id)  rental_count, dense_rank() over(partition by c.name order by count(r.rental_id) desc) as rnk
from film f
join film_category fc on fc.film_id = f.film_id
join category c on c.category_id = fc.category_id
join inventory i on i.film_id = f.film_id
join rental r on i.inventory_id = r.inventory_id
group by f.title, c.name )
select category, title, rental_count from x
where rnk <=3
;


/*
5. Calculate the difference in rental counts between each customer’s total rentals and the average rentals.
*/

select concat(c.first_name, " ", c.last_name) as name, count(r.rental_id) as total_rentals, 
round(avg(count(r.rental_id)) over(),2) as avg_rentals,
round(count(r.rental_id) - avg(count(r.rental_id)) over(),2) as count_var
from customer c
join rental r on r.customer_id = c.customer_id
group by c.first_name, c.last_name;


/*
6. Find the monthly revenue trend for the entire rental store over time.
*/
select distinct year(p.payment_date) as year_no, month(p.payment_date) as month_no, 
monthname(p.payment_date) month_name, 
sum(p.amount) over(partition by month(p.payment_date),year(p.payment_date)) as monthly_rev 
from payment p
join staff s on s.staff_id = p.staff_id
order by year_no, month_no;


/*
7. Identify the customers whose total spending on rentals falls within the top 20% of all customers.
*/
with amount_tab as (
select distinct concat(c.first_name," ", c.last_name) as name, 
sum(p.amount) over(partition by concat(c.first_name," ", c.last_name)) as total_amount
from customer c
join payment p on c.customer_id = p.customer_id
order by total_amount desc )
select*from (
	select name, total_amount, round(cume_dist() over(order by total_amount)*100,2) as cum_rank
	from amount_tab
) x
where x.cum_rank>=80
order by cum_rank desc
;



/*
8. Calculate the running total of rentals per category, ordered by rental count.
*/

with rentals as (
select   f.title, c.name, count(r.rental_id) rental_count
from film f
join film_category fc
on f.film_id = fc.film_id
join category c
on c.category_id = fc.category_id
join inventory i on i.film_id = fc.film_id
join rental r on i.inventory_id = r.inventory_id
group by f.title, c.name )
select *, sum(rental_count) over(partition by name order by rental_count desc rows between unbounded preceding and current row) as running_total
from rentals
;


/*
9. Find the films that have been rented less than the average rental count for their category.
*/

with rental_counts as (
select   f.title, c.name, count(r.rental_id) rental_count, round(avg(count(r.rental_id)) over(partition by c.name),2) as avg_rental_count
from film f
join film_category fc
on f.film_id = fc.film_id
join category c
on c.category_id = fc.category_id
join inventory i on i.film_id = fc.film_id
join rental r on i.inventory_id = r.inventory_id
group by f.title, c.name )
select * from rental_counts
where rental_count < avg_rental_count
;


/*
10. Identify the top 5 months with the highest revenue and display the revenue generated.
*/

select distinct month(payment_date) month_no, monthname(payment_date) month, sum(amount) over(partition by monthname(payment_date)) total_revenue
from payment
order by total_revenue desc
limit 5;



/*
=====================
NORMALISATION & CTE
=====================
*/

/*
1. First Normal Form (1NF):
   Identify a table in Sakila DB that violates 1NF and normalize it.
   Answer: actor_award table violates 1NF as awards column contain more than more than one value.
		   We can normalise it by adding each award as separate row for same actor_id and name with new actor_award id.
*/ 
select*from actor_award;
DROP TABLE IF EXISTS actor_award_normalized;

CREATE TABLE actor_award_normalized (
    actor_id INT,
    award_name VARCHAR(100) NOT NULL
);

create temporary table cte_result as 
WITH RECURSIVE award_split AS (
    SELECT actor_award_id,
           actor_id,
           TRIM(SUBSTRING_INDEX(awards, ',', 1)) AS award_name,
           SUBSTRING(awards, LENGTH(SUBSTRING_INDEX(awards, ',', 1)) + 2) AS remaining
    FROM actor_award
    where actor_id is not null
    UNION ALL
    SELECT actor_award_id,
           actor_id,
           TRIM(SUBSTRING_INDEX(remaining, ',', 1)) AS award_name,
           SUBSTRING(remaining, LENGTH(SUBSTRING_INDEX(remaining, ',', 1)) + 2) AS remaining
    FROM award_split
    WHERE remaining <> '' and actor_id is not null
) 
select actor_id, award_name from award_split;
INSERT INTO actor_award_normalized (actor_id, award_name) #making a new table out of this temp table to create a 1NF compliant actor award table
SELECT actor_id, award_name
FROM cte_result;

select*from actor_award_normalized; #new 1NF compliant table


/*
2. Second Normal Form (2NF):
   Choose a table in Sakila and check if it’s in 2NF. Normalize if needed.
Ans. Selected category table doesn't violate 2NF, all columns are depended on the primary key category_id
*/
select*from category;


/*
3. Third Normal Form (3NF):
   Identify a table that violates 3NF, describe transitive dependencies, and normalize.
Ans. Here also, actor_award table violates 3NF as it contains actor first_name, last_name which is dependent on actor_id.
	 We have already created an actor award table now we can remove actor_id and actor's name into a new table.
*/
create table actor_name as 
select actor_id, first_name, last_name from actor_award;
select*from actor_name; #this new table is now free from 3NF violation.

/*
4. Normalization Process:
   Normalize a specific table in Sakila from unnormalized form to at least 2NF.
Ans. In the above two examples I have already normalized a table to 3NF form. Now there are no such tables left to normalise.
*/


/*
5. CTE Basics:
   Retrieve distinct actor names and the number of films they acted in (actor + film_actor).
*/
 with actor_table as (
select concat(first_name, " ", last_name) as actor_name, actor_id
from actor)
select a.actor_name,  count(fa.film_id) film_count
from actor_table a
left join film_actor fa on a.actor_id = fa.actor_id
group by  a.actor_id
order by film_count desc
;

/*
6. CTE with Joins:
   Combine film + language tables to display film title, language name, and rental rate.
*/

with language_tab as
( select language_id, name as language_name from language)
select f.title, lt.language_name, f.rental_rate
from film f
join language_tab as lt
on f.language_id = lt.language_id;



/*
7. CTE for Aggregation:
   Find total revenue generated by each customer (customer + payment).
*/
with revenue_tab as
(select customer_id, sum(amount) as total_spends from payment
group by customer_id)
select c.customer_id, concat(c.first_name, " ", c.last_name) as customer_name , r.total_spends
from customer c
left join revenue_tab r on r.customer_id = c.customer_id
;


/*
8. CTE with Window Functions:
   Rank films based on their rental duration.
*/
with film_rank as (
select film_id, title, dense_rank() over(order by rental_duration) as rnk
from film)
select*from film_rank
order by rnk, title
;


/*
9. CTE and Filtering:
   List customers who made more than two rentals, then join with customer table.
*/

WITH rental_counts AS (
    SELECT customer_id, COUNT(rental_id) AS rental_count
    FROM rental
    GROUP BY customer_id
    HAVING COUNT(rental_id) > 2
)
SELECT CONCAT(c.first_name, ' ', c.last_name) AS customer_name, r.rental_count
FROM rental_counts r
JOIN customer c ON c.customer_id = r.customer_id
ORDER BY r.rental_count DESC;



/*
10. CTE for Date Calculations:
    Find the total number of rentals made each month (rental_date).
*/

WITH monthly_rentals AS (
    SELECT YEAR(rental_date) AS year_no,
           MONTH(rental_date) AS month_no,
           MONTHNAME(rental_date) AS month_name,
           COUNT(rental_id) AS total_rentals
    FROM rental
    GROUP BY YEAR(rental_date), MONTH(rental_date), MONTHNAME(rental_date)
)
SELECT month_name, total_rentals
FROM monthly_rentals
ORDER BY year_no, month_no;


/*
11. CTE and Self-Join:
    Generate pairs of actors who have appeared in the same film together.
*/
WITH actor_pairs AS (
    SELECT f.title,
           a1.actor_id AS actor_1_id,
           CONCAT(a1.first_name, ' ', a1.last_name) AS actor_1_name,
           a2.actor_id AS actor_2_id,
           CONCAT(a2.first_name, ' ', a2.last_name) AS actor_2_name
    FROM film f
    JOIN film_actor fa1 ON f.film_id = fa1.film_id
    JOIN actor a1 ON fa1.actor_id = a1.actor_id
    JOIN film_actor fa2 ON f.film_id = fa2.film_id
    JOIN actor a2 ON fa2.actor_id = a2.actor_id
    WHERE a1.actor_id < a2.actor_id  
)
SELECT *
FROM actor_pairs
ORDER BY title, actor_1_name, actor_2_name;

/*
12. Recursive CTE:
    Find all employees in the staff table who report to a specific manager (reports_to column).
*/
-- as there isn't a reports to columns lets create new table to understand this

CREATE TABLE staff_tab (
    staff_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    reports_to INT NULL,   -- points to staff_id of the manager
    FOREIGN KEY (reports_to) REFERENCES staff_tab(staff_id)
);
INSERT INTO staff_tab (staff_id, first_name, last_name, reports_to) VALUES
(1, 'Mike', 'Hillyer', NULL),   -- top manager
(2, 'Jon', 'Stephens', 1),      -- reports to Mike
(3, 'Susan', 'Smith', 1),       -- reports to Mike
(4, 'Karen', 'Johnson', 2),     -- reports to Jon
(5, 'John', 'Doe', 3);          -- reports to Susan
;

with recursive manager_table as (
	select staff_id, concat(first_name," ", last_name) as name,reports_to, 1 as lvl  
    from staff_tab where staff_id =1
    union
    select s.staff_id, concat(s.first_name," ", s.last_name) as name,s.reports_to, m.lvl + 1 as lvl
    from manager_table m
    join staff_tab s
    on s.reports_to = m.staff_id )
select m.name as employee_name, concat(s.first_name, " ", s.last_name) as manager_name, m.lvl  from manager_table m
left join staff_tab s on s.staff_id = m.reports_to
;