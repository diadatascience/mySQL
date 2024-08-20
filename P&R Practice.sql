#GROUP BY

#Group by rolls up everything into these rows, in contrast to using DISTINCT
SELECT gender
FROM employee_demographics
GROUP BY gender;

#This gives an error, b/c SELECT needs to match group by if NOT performing an aggregate function
SELECT first_name
FROM employee_demographics
GROUP BY gender;

#AGGREGATE FUNCTION This is an example of an aggregation that doesn't require it to be the same in group by
SELECT gender, AVG(age)
FROM employee_demographics
GROUP BY gender;

#Group by occupation
SELECT occupation
FROM employee_salary
GROUP BY occupation
;

#Group by occupation AND salary
SELECT occupation, salary
FROM employee_salary
GROUP BY occupation, salary
;

#Aggregate functions (AVG and MAX)
SELECT gender, AVG(age), MAX(age)
FROM employee_demographics
GROUP BY gender
;

#Aggregate functions (AVG and MAX and COUNT) telling us how many are needed in each group
SELECT gender, AVG(age), MAX(age), COUNT(Age)
FROM employee_demographics
GROUP BY gender
;

#ORDER BY (ASC or DESC)

SELECT *
FROM employee_demographics
ORDER BY first_name ASC;

#Multiple ORDER BY items

SELECT *
FROM employee_demographics
ORDER BY gender, age DESC ;
#Here, gender is not being used to order on anything because there's no unique gender fields, therefore what you place in Order By is really important


#POSITIONS of fields in Order By (not names) - NOT reccomended because if columns get removed or changed, this can be affected
SELECT *
FROM employee_demographics
ORDER BY 5, 4;

#HAVING vs WHERE
#Group by runs AFTER where clause, which is why this gives an error because where can't be done before group. This is the time to use HAVING clause
SELECT gender, AVG(age)
FROM employee_demographics
WHERE AVG(age) > 40
GROUP BY gender
;

#HAVING comes AFTER group by, which works
SELECT gender, AVG(age)
FROM employee_demographics
GROUP BY gender
HAVING AVG(age) > 40
;

#Here the row level is filtering at the WHERE, but HAVING doesn't run until after the group by clause (IF you want to filter on aggregate columns, will need to use HAVING)
SELECT occupation, AVG(salary)
FROM employee_salary
WHERE occupation LIKE '%manager%'
GROUP BY occupation
HAVING AVG(salary) > 75000
;

#LIMIT and ALIASING

#Selecting top 3 from a table
SELECT *
FROM employee_demographics
LIMIT 3
;

#Selecting top 3 oldest employees (DESC because going from highest age down)
SELECT *
FROM employee_demographics
ORDER BY age DESC
LIMIT 3
;

#BY adding a comma then an additional number, we are telling to start at row 2 then select the first column afterwards
SELECT *
FROM employee_demographics
ORDER BY age DESC
LIMIT 2, 1
;

#Aliasing used to change the name of a column (changing aggregate to column avg_age

SELECT gender, AVG(age) AS avg_age
FROM employee_demographics
GROUP BY gender
HAVING avg_age > 40
;

#INNER JOINS PLUS ALIASING - Think of it like a venn diagram, inner join is going to return rows that are the same in both columns from both tables.
#By default, JOIN represents INNER JOIN but you can write INNER if you like + Aliases on the table

SELECT *
FROM employee_demographics AS dem
JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id ;
    
#Notice number 2 is missing? Let's take a look

SELECT *
FROM employee_demographics;

SELECT *
FROM employee_salary;

#We can see there's no employee_id = 2 in the demographics table so it does not populate

#Errors with ambiguous columns, sometimes you will need to include the table name in the select statement if there are columns that are similar in both tables
SELECT dem.employee_id, age, occupation
FROM employee_demographics AS dem
JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id ;
    
    
#OUTTER JOINS - where there is Outter left and outter right - still thinking venn diagram,
#Outter Left is everything from the left, and only matches from the right
#Outter Right is everything from the right, and only matches from the left

#RIGHT JOIN

SELECT *
FROM employee_demographics AS dem
LEFT JOIN employee_salary AS sal
ON dem.employee_id = sal.employee_id ;
# This returns everything in the right table with matches (right being salary)

#LEFT JOIN
SELECT *
FROM employee_demographics AS dem
RIGHT JOIN employee_salary AS sal
ON dem.employee_id = sal.employee_id ;

#Here we get nulls on employee ID 2 because we are taking everything from demographics but only what matches on the left otherwise null

#SELF JOIN - where you tie the table to itself (Must still have ON for the fields connecting on and which table is first)

SELECT * 
FROM employee_salary AS emp1
JOIN employee_salary AS emp2
	ON emp1.employee_id = emp2.employee_id;
    
#SELF JOIN - example where company wants to do a secret santa, and you are connecting every employee to the person underneath in the table to be their secret santa
#BUT only selecting the first and last names

SELECT emp1.employee_id AS emp_santa,
emp1.first_name AS first_name_santa,
emp1.last_name AS last_name_santa,
emp2.employee_id AS emp_santa,
emp2.first_name AS first_name_santa,
emp2.last_name AS last_name_santa
FROM employee_salary AS emp1
JOIN employee_salary AS emp2
	ON emp1.employee_id + 1 = emp2.employee_id;
    
#Joining Multiple Tables together
SELECT *
FROM employee_demographics AS dem
JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id;
#These tables have a department ID that is undefined

#This is a reference table for the department id's (not updated often)
SELECT *
FROM parks_departments;

#Now we want to join the department ID from the reference table to the joined tables up top from the salary table
SELECT *
FROM employee_demographics AS dem
JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id
JOIN parks_departments as pd
	ON sal.dept_id = pd.department_id;
    
#Unions (allows you to combine rows together from both separate and same tables)
SELECT age, gender
FROM employee_demographics
UNION
SELECT first_name, last_name
FROM employee_salary;
#This is an example of a bad/random data combination. Data typically needs to be the same.
#By default, union is distinct (but written out here)

SELECT first_name, last_name
FROM employee_demographics
UNION DISTINCT
SELECT first_name, last_name
FROM employee_salary;

#Union All which is NOT distinct results (no duplicates removed)
SELECT first_name, last_name
FROM employee_demographics
UNION DISTINCT
SELECT first_name, last_name
FROM employee_salary;

#Adding Labels where you put the name in single quotes then use AS Label AND add in Union for highly paid
#Union is also using the 'JOIN' feature
SELECT first_name, last_name,'Old' AS Label
FROM employee_demographics
WHERE age > 50
UNION
SELECT first_name, last_name,'Highly Paid Employee' AS Label
FROM employee_salary
WHERE salary > 70000;

#Double Union, And and Where example for employee that is older man or woman, or a highly paid employee to decide on layoffs
SELECT first_name, last_name,'Old Man' AS Label
FROM employee_demographics
WHERE age > 40 AND gender = 'male'
UNION
SELECT first_name, last_name,'Old Lady' AS Label
FROM employee_demographics
WHERE age > 40 AND gender = 'female'
UNION
SELECT first_name, last_name,'Highly Paid Employee' AS Label
FROM employee_salary
WHERE salary > 70000
ORDER BY first_name, last_name;

#STRING FUNCTIONS FOR CLEANING DATA

#Looking at the length of a string
SELECT LENGTH('skyfall');

SELECT *
FROM employee_demographics;

#Let's look at the length of each name
SELECT first_name, LENGTH(first_name)
FROM employee_demographics;

#Adding in Order by, and skipping first two rows
SELECT first_name, LENGTH(first_name)
FROM employee_demographics
ORDER BY 2;
#use case for Length can be looking at phone numbers to be exactly 10 numbers

#UPPER and LOWER where Upper puts in upper case and lower puts in lower case
SELECT UPPER('sky');
SELECT LOWER('SKY');

SELECT first_name, UPPER(first_name)
FROM employee_demographics;

SELECT first_name, LOWER(first_name)
FROM employee_demographics;

#TRIM cuts down white space before and after string (leading and trailing)
#RTrim does right side and LTrim does left side
SELECT TRIM('       sky        ');
SELECT LTRIM('       sky        ');
SELECT RTRIM('       sky        ');

#Selecting certain number of characters from either left or right hand side (in this case first 4)
#Not the most useful
SELECT first_name, LEFT(first_name, 4)
FROM employee_demographics;

#SUBSTRINGS where we create a new set of strings, in this case starting from the third character and taking two characters after
SELECT first_name, 
	LEFT(first_name, 4),
    RIGHT(first_name, 4),
SUBSTRING(first_name, 3,2)
FROM employee_demographics;

#Want to create a substring of which month each person was born
SELECT first_name, 
	LEFT(first_name, 4),
    RIGHT(first_name, 4),
SUBSTRING(first_name, 3,2)
birth_date,
SUBSTRING(birth_date, 6,2) AS birth_month
FROM employee_demographics;

#REPLACE replacing specific characters with the ones we want - replacing a with z (in this case only lower case)

SELECT first_name, REPLACE(first_name,'a', 'z')
FROM employee_demographics;

#LOCATING position in a sequence

SELECT LOCATE('x', 'Alexander');

SELECT LOCATE('An', first_name)
FROM employee_demographics;

#CONCATENATION of multiple columns with spaces (' ')
SELECT first_name, last_name,
CONCAT(first_name,' ', last_name) AS full_name
FROM employee_demographics;

#CASE STATEMENTS (if, else statements)
#Single When in case statement
SELECT first_name, last_name, age,
CASE
	WHEN age <= 30 THEN 'Young'
END
FROM employee_demographics; 

#CASE STATEMENTS (if, else statements) + Between
#SMultiple When in cases statement, remember to use double quotes if your string includes a single quote
SELECT first_name, last_name, age,
CASE
	WHEN age <= 30 THEN 'Young'
    WHEN age BETWEEN 31 AND 50 THEN 'Old'
    WHEN age >= 50 THEN "On Death's Door"
END AS age_bracket
FROM employee_demographics;

#Looking at pay increase and bonus guidelines
# <5000 = 5% (shown in example of salary * 0.05)
# > 5000 = 7%  (shown in example as * 1.07)
# Finance = 10% bonus
#What are each persons pay increase?

SELECT first_name, last_name, salary,
CASE 
	WHEN salary < 50000 THEN salary + (salary * 0.05)
    WHEN salary > 50000 THEN salary * 1.07
END AS new_salary
FROM employee_salary;

#What is finance department id?
SELECT * 
FROM parks_departments;
#it's 6

SELECT first_name, last_name, salary,
CASE 
	WHEN salary < 50000 THEN salary + (salary * 0.05)
    WHEN salary > 50000 THEN salary * 1.07
END AS new_salary,
CASE
	WHEN dept_id = 6 THEN salary * 1.10
END AS Bonus
FROM employee_salary;

#INTERMEDIATE MYSQL

#SUBQUERIES - sometimes we don't want to join two tables together so we do a subquery
#Subquery is a query within another query but can only have ONE column to select

#Select subqueries

SELECT * 
FROM employee_demographics
WHERE employee_id IN
			(SELECT employee_id
				FROM employee_salary
                WHERE dept_id = 1);
#If you run just the sub query, you see 1-6 then 12, but the full query doesn't have 2 because that user is only in one table


#Comparing each individual salary to the total average salary at the company using a subquery in select but from the same table
SELECT first_name, salary,
	(SELECT AVG(salary)
    FROM employee_salary)
    FROM employee_salary;

#FROM subqueries
#We are selecting the aggregations of the general table

SELECT gender, AVG(age), MAX(age), MIN(age), COUNT(age)
FROM employee_demographics
GROUP BY gender;

#Wanting to get the average of each average age, count, geneder, etc using FROM statement + an alias

SELECT * 
FROM 
(SELECT gender, AVG(age), MAX(age), MIN(age), COUNT(age)
FROM employee_demographics
GROUP BY gender) AS agg_table;

#Now let's perform aggregations on this table BUT rename them
#Here you are taking the subquery table created above, then returning the average of max age

SELECT AVG(max_age)
FROM 
(SELECT 
gender, 
AVG(age) AS avg_age, 
MAX(age) AS max_age, 
MIN(age) AS min_age, 
COUNT(age) 
FROM employee_demographics
GROUP BY gender) AS agg_table;


#WINDOW FUNCTIONS

#First Let's compare average salaries by gender groups
SELECT gender, AVG(salary) AS avg_salary
FROM employee_demographics AS dem
JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender;

#Now let's use a window function where we are looking at average salary over everything [OVER()], not grouped by anything
SELECT gender, AVG(salary) OVER(PARTITION BY gender)
FROM employee_demographics AS dem
JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id;
    
#The abelow queries is completely independent of with partition, where it just creates the separate column providing the requested info.
SELECT dem.first_name, dem.last_name, gender, AVG(salary) AS avg_salary
FROM employee_demographics AS dem
JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id
GROUP BY dem.first_name, dem.last_name, gender;

SELECT dem.first_name, dem.last_name, gender, AVG(salary) OVER(PARTITION BY gender)
FROM employee_demographics AS dem
JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id;

    
#Let's look at SUM of salaries partitioned by gender
SELECT dem.first_name, dem.last_name, gender,
SUM(salary) OVER(PARTITION BY gender)
FROM employee_demographics AS dem
JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id;
#Here we see the sum of womens salaries is 215k and 402k
    
#Rolling totals that start at a specific value and add on subsequent rows based on the partition of gender, using Order BY where salary is being added to the existing total of 215K
SELECT dem.first_name, dem.last_name, gender,salary,
SUM(salary) OVER(PARTITION BY gender ORDER BY dem.employee_id) AS Rolling_Total
FROM employee_demographics AS dem
JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id;
    #Can also be done regardless of the partition of gender
    
#Window Like functions - Row Number, Rank, Dense Rank
#Row Number
SELECT dem.employee_id, dem.first_name, dem.last_name, gender,salary,
ROW_NUMBER() OVER(PARTITION BY gender ORDER BY salary DESC)AS row_num
FROM employee_demographics AS dem
JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id;

#RANK assigns the same number where order by is the same, and then assigns the following the number positionally (7 instead of 6 after two 5 rows)
SELECT dem.employee_id, dem.first_name, dem.last_name, gender,salary,
ROW_NUMBER() OVER(PARTITION BY gender ORDER BY salary DESC)AS row_num,
RANK () OVER(PARTITION BY gender ORDER BY salary DESC) AS rank_num
FROM employee_demographics AS dem
JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id;
    
#Dense RANK gives the next row its numeric value, not positional value (6 instead of 7 after two 5 rows)
SELECT dem.employee_id, dem.first_name, dem.last_name, gender,salary,
ROW_NUMBER() OVER(PARTITION BY gender ORDER BY salary DESC)AS row_num,
RANK () OVER(PARTITION BY gender ORDER BY salary DESC) AS rank_num,
DENSE_RANK () OVER(PARTITION BY gender ORDER BY salary DESC) AS dense_rank_num
FROM employee_demographics AS dem
JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id;
    
    
#ADVANCED MYSQL

#CTE's or Common Table Expressions - allow you to define a subquery block that you can reference within the main query
#CTE's use WITH to name/define the CTE

WITH CTE_Example AS
(
SELECT gender, AVG(salary) AS avg_sal, MAX(salary) AS max_sal, MIN(salary) AS min_sal, COUNT(salary) AS count_sal
FROM employee_demographics AS dem
JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender
)

#So now that we've created the CTE table we're able to query it down below
WITH CTE_Example AS
(
SELECT gender, AVG(salary) AS avg_sal, MAX(salary) AS max_sal, MIN(salary) AS min_sal, COUNT(salary) AS count_sal
FROM employee_demographics AS dem
JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender
)
SELECT *
FROM CTE_Example
;

#Another example of querying the CTE table for average salary of both males and females
WITH CTE_Example AS
(
SELECT gender, AVG(salary) AS avg_sal, MAX(salary) AS max_sal, MIN(salary) AS min_sal, COUNT(salary) AS count_sal
FROM employee_demographics AS dem
JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender
)
SELECT AVG(avg_sal)
FROM CTE_Example;
#When you build a CTE you can only use it immediately after, that's why the SELECT statement comes after the CTE
#A CTE does not create a real table, so a select statement for it cannot be used alone (see example below)

SELECT AVG(avg_sal)
FROM CTE_Example;


#This is an example of if this was written as a subquery instead

SELECT AVG(avg_sal) 
FROM (SELECT gender, AVG(salary) AS avg_sal, MAX(salary) AS max_sal, MIN(salary) AS min_sal, COUNT(salary) AS count_sal
FROM employee_demographics AS dem
JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender
) AS example_subquery ;


#You can create multiple CTE's within one for a more complex query
WITH CTE_Example AS
(
SELECT employee_id, gender, birth_date
FROM employee_demographics AS dem
WHERE birth_date > '1985-01-01'
), 
CTE_Example2 AS
(SELECT employee_id, salary
FROM employee_salary
WHERE salary > 50000
)
SELECT *
FROM CTE_Example
JOIN CTE_Example2 ON CTE_Example.employee_id = CTE_Example2.employee_id;

#Overwriting column names within the CTE 'WITH' line, so you can remove the 'AS' labels from the SELECT statement

WITH CTE_Example (Gender, AVG_Sal, MAX_Sal, MIN_Sal, COUNT_Sal) AS
(
SELECT gender, AVG(salary), MAX(salary), MIN(salary), COUNT(salary)
FROM employee_demographics AS dem
JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender
)
SELECT *
FROM CTE_Example;

#TEMPORARY TABLES & Comparing with CTE's
#Table only visible to the session they're created in (cannot be saved)
#Can be best used to manipulate data before inserting into a more permanent table

#Start by creating table and defining data types
CREATE TEMPORARY TABLE temp_table
(first_name varchar(50), 
last_name varchar(50),
favourive_movie varchar(100)
);

#Now to see table

SELECT *
FROM temp_table;

#You can now insert data into this table created in order to look at it

INSERT INTO temp_table
VALUES('Alex', 'Freberg', 'Lord of the Rings: The Two Towers');

SELECT *
FROM temp_table;

SELECT * 
FROM employee_salary;

#Now lets create one with our parks and rec dataset
#Use naming for the table that is easy to follow
CREATE TEMPORARY TABLE salary_over_50k
SELECT *
FROM employee_salary
WHERE salary >= 50000;

#Now let's query this data from our new temp table
#Temp tables are usually more complex than CTE's

SELECT *
FROM salary_over_50k;

#STORED PROCEDURES
#Way to store your SQL code so that you can use it to recall all the code that you wrote in your stored procedure
#Meaningful for store complex queries and repetitive codes

#Here is the code we want to save within a stored procedure (example shows the exact table specified)
USE Parks_and_Recreation;
CREATE PROCEDURE large_salaries()
SELECT *
FROM employee_salary
WHERE salary >= 50000;

#Now let's call the stored procedure
#Also, if you want to run from the stored procedures in the schema on the left-hand side, you can click the lightning bolt beside the specific procedure
CALL large_salaries();

#Stored Procedures with multiple queries using a delimiter (typically its a semicolon, but we can change to $$)
#Include BEGIN and END, then change back delimiter

DELIMITER $$
CREATE PROCEDURE large_salaries3()
BEGIN
	SELECT *
	FROM employee_salary
	WHERE salary >= 50000;
	SELECT *
	FROM employee_salary
	WHERE salary >= 10000;
END $$
DELIMITER ;

CALL large_salaries3();

#Parameters are variables passed as a stored procedure when called
#We're telling the call procedure they need to pass an integer for this query to go through

DELIMITER $$
CREATE PROCEDURE large_salaries4(employee_id_param INT)
BEGIN
	SELECT salary
	FROM employee_salary
    WHERE employee_id = employee_id_param;
END $$
DELIMITER ;

CALL large_salaries4(1);

#Triggers and Events
#Trigger is a block of code that executes automatically when an event takes place on a specific table

SELECT *
FROM employee_demographics;

SELECT *
FROM employee_salary;

#When an employee is hired and salary is input, their details are automatically put into the demographics table (except for employee ID 2, so we need to update manually)
#For each row says trigger gets activated for each row/hired employee
#In microsoft for example, theres batch level updates that trigger once for multiple tables (but not the case here)
#NEW takes rows added, OLD takes rows deleted
DELIMITER $$
CREATE TRIGGER employee_insert
	AFTER INSERT ON employee_salary
    FOR EACH ROW 
BEGIN 
	INSERT INTO employee_demographics(employee_id, first_name, last_name)
    VALUES (NEW.employee_id, NEW.first_name, NEW.last_name);
    END $$
DELIMITER ;

#Now, let's add a new employee to employee salary
INSERT INTO employee_salary (employee_id, first_name, last_name, occupation, salary, dept_id)
VALUES (13, 'Jean-Ralphio', 'Saperstein', 'Entertainment 720 CEO', '1000000', NULL);

#Let's check the salary table for employee ID 13
SELECT *
FROM employee_salary;

#Now, check that the trigger created a new row in demographics table for this employee
SELECT *
FROM employee_demographics;

#A trigger happens when an event takes place, whereas an event takes place when its scheduled to
#Ex can pull data from a specific file path or build reports that are exported on a schedule (Daily, weekly, monthly automations)

#In this example, legislation wants us to retire folks over 60 when they turn 60 and delete them from the tables with lifetime pay

SELECT *
FROM employee_demographics
WHERE age >= 60;

DELIMITER $$
CREATE EVENT delete_retirees
ON SCHEDULE EVERY 30 SECOND
DO
BEGIN
	DELETE
    FROM employee_demographics
    WHERE age >= 60;
END $$
DELIMITER ;

#Now let's check that he is deleted

SELECT *
FROM employee_demographics;

#If there's an issue creating your event, you can check using below

SHOW VARIABLES LIKE 'event%';

#IF the above is OFF so you do NOT have permissions to delete anything, go to edit, preferences, SQL editor, then go to bottom to uncheck SAFE updates