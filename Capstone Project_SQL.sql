/*-------------------------------------- CAPSTONE PROJECT ------------------------------------------*/

/*--------------------------------------ANALYSIS ON CREDIT CARD APPROVAL PREDICTION DATASET------------------------------------------*/

CREATE DATABASE credit_card; 				# Creating the database
USE credit_card; 							# Using the database

-- Cleaned dataset imported using the Table Data Import Wizard

SHOW TABLES; 								# Displaying the tables available in the database

SELECT * FROM credit_data_cleaned; 			# Viewing the Table

ALTER TABLE credit_data_cleaned 
ADD PRIMARY KEY (ind_id); 					# Creating Primary key on the index column

DESC credit_data_cleaned; 					# Brief Description of table and datatypes of each variable

/*-------------------------------------------------------------------------------------------------------------------*/
# Question 1. Group the customers based on their income type and find the average of their annual income.

/* Approach:
To find the average of annual incomes, we need to use `AVG` aggregation function and then we will use `ROUND` function to round the values to 3 decimal places.
Then grouping will be done on the `type_income` column as asked in the problem. */

SELECT type_income, ROUND(AVG(annual_income),3) AS `avg_annual_income` 
FROM credit_data_cleaned
GROUP BY type_income;

/*-------------------------------------------------------------------------------------------------------------------*/
# Ouestion 2. Find the female owners of cars and property.

/* Approach:
To find the number female owners of car and property, we will use `COUNT` function and then specify the conditions in `WHERE` clause 
for `gender`, `car_owner` and `propert_owner` column by separating each of the conditions by `AND` logical operator. */

SELECT gender, COUNT(*) AS `owners_of_car_and_property` 
FROM credit_data_cleaned
WHERE (car_owner = 'Y') AND (propert_owner = 'Y') AND (gender= 'F');

/*-------------------------------------------------------------------------------------------------------------------*/
# Question 3. Find the male customers who are staying with their families.

/* Approach:
To find the number of male customers staying with their families, we will use `COUNT` aggregation function and specify the conditions in
`WHERE` clause for `gender` and `housing_type` by seperating them with `AND` logical operator. */

SELECT gender, housing_type, COUNT(*) AS `count`
FROM credit_data_cleaned 
WHERE gender = 'M' AND housing_type = 'With parents';

/*-------------------------------------------------------------------------------------------------------------------*/
# Question 4. Please list the top five people having the highest income.

/* Approach:
Here, we will apply `ORDER BY` clause in descending order using `DESC` keyword on `annual_income` column 
and then to get top 5 records, `LIMIT` function will be used. */

SELECT * FROM credit_data_cleaned 
ORDER BY annual_income DESC 
LIMIT 5;

/*-------------------------------------------------------------------------------------------------------------------*/
# Question 5. How many married people are having bad credit?

/* Approach:
To find the number of married people having bad credit, `COUNT` function will be used and conditions will be specified in the `WHERE`clause
for `marital_status` and `label` columns. */

SELECT 'Married People having Bad credit' AS `description`, label, marital_status, count(*) AS `count`
FROM credit_data_cleaned 
WHERE marital_status = 'Married' AND label = 1;

/*-------------------------------------------------------------------------------------------------------------------*/
# Question 6. What is the highest education level and what is the total count?

/* Approach:
In the given dataset we have the following 5 levels of education: 
1. Lower secondary
2. Secondary / secondary special
3. Incomplete higher
4. Higher education
5. Academic degree

The highest level of education is certainly the Academic Degree. 
Now, to find the total count of individuals having the highest degree, we will use `COUNT` function and specify the condition
in `WHERE` clause for Academic Degree holders. */

SELECT DISTINCT(education) AS `education_levels` FROM credit_data_cleaned; 			# To check different levels of education present in the dataset

SELECT education, COUNT(*) `count`
FROM credit_data_cleaned
WHERE education = 'Academic degree';

/*-------------------------------------------------------------------------------------------------------------------*/
# Question 7. Between married males and females, who is having more bad credit? 

/* Approach:
We can do this by using multiple approaches like using simple `ORDER BY` clause, Window Functions, Subqueries, CTEs, etc.
Here I have used CTE.
To find the number of married males and females having bad credit, we will use `COUNT` function and specify the conditions for
`marital_status` and `label` in `WHERE` clause, then grouping will be done on `gender` column.
Then we will store the query block in a CTE which is defined using `WITH` clause, and call the CTE by specifing the condition of
maximum count using `MAX` function in the `WHERE` clause. */

WITH max_bad_credit AS(
		SELECT gender, count(*) AS `count_of_bad_credit` FROM credit_data_cleaned 
		WHERE marital_status = 'Married' AND label = 1
		GROUP BY gender
		)
SELECT * FROM max_bad_credit
WHERE `count_of_bad_credit` = (SELECT MAX(`count_of_bad_credit`) FROM max_bad_credit);


/*-------------------------------------------------------------------------------------------------------------------*/
