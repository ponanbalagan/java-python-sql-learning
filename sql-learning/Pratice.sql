/* SQL ORDER OF EXECUTION
    SELECT
    FROM
    JOIN
    ON
    WHERE
    GROUP BY
    HAVING
    ORDER BY  */
--SELECT STATEMENT--
Select * from actor;
SELECT title,release_year FROM film;
SELECT DISTINCT first_name FROM actor; /*DISTINCT - Removing Duplicates*/

--WHERE CLAUSE FOR FILETRING--
SELECT * FROM actor WHERE first_name='PENELOPE';
SELECT actor_id,first_name,last_name FROM actor WHERE actor_id>150;
SELECT first_name,last_name FROM actor WHERE last_name='AKROYD';

--LOGICAL OPERATORS AND,OR,NOT--
SELECT * FROM actor WHERE first_name='PENELOPE' AND last_name='GUINESS';
SELECT * FROM actor WHERE first_name='PENELOPE' OR last_name='GUINESS';

--NOT,!=,<> THREE SYMBOLS ARE SAME--
SELECT * FROM actor WHERE NOT first_name='PENELOPE';
SELECT * FROM actor WHERE  first_name<>'PENELOPE';
SELECT * FROM actor WHERE first_name!='PENELOPE';

--COMBINE AND,OR,NOT--
SELECT actor_id, first_name, last_name FROM actor WHERE (first_name = 'PENELOPE' OR first_name = 'NICK') AND actor_id < 50;
SELECT actor_id, first_name, last_name FROM actor WHERE NOT (first_name = 'PENELOPE' OR first_name = 'NICK');

--IN,NOT IN--
SELECT actor_id, first_name, last_name FROM actor WHERE first_name IN ('PENELOPE', 'NICK', 'ED');
SELECT actor_id, first_name, last_name FROM actor WHERE first_name NOT IN ('PENELOPE', 'NICK', 'ED');

--BETWEEN AND NOT BETWEEN (Check if a value lies in a range (inclusive on both ends))--
SELECT actor_id, first_name, last_name FROM actor WHERE actor_id BETWEEN 50 AND 60;
SELECT actor_id, first_name, last_name FROM actor WHERE actor_id NOT BETWEEN 1 AND 50;

--LIKE (Pattern Matching) "%" → matches any number of characters (including zero), "_" -> matches exactly one character
SELECT first_name, last_name FROM actor WHERE first_name LIKE 'J%'; --STARTS WITH J
SELECT first_name, last_name FROM actor WHERE first_name LIKE '%Y'; --ENDS WITH Y
SELECT first_name, last_name FROM actor WHERE first_name LIKE '%ER%'; --CONTAINS ER ANYWHERE
SELECT first_name, last_name FROM actor WHERE first_name LIKE '_A%'; --STARTS WITH "A" AFTER ONE CHARACTER
SELECT first_name, last_name FROM actor WHERE first_name LIKE 'N___'; --STARTS WITH "N" AND HAS 4 CHARACTERS IN TOTAL

--ORDER BY (Sorting the result set) Default - ASCENDING (A-Z,1-100), DESC = Descending (Z → A, 100 → 1)
SELECT first_name, last_name FROM actor ORDER BY first_name;
SELECT first_name, last_name FROM actor ORDER BY first_name DESC;
SELECT first_name, last_name FROM actor ORDER BY last_name, first_name; -- Sort by last_name, then by first_name

--LIMIT/TOP – Restrict the number of rows [Eg: “Top 5”, “Top 10” - ASC, HIGHEST - DESC,LOWEST- ASC]. ORDER RULE: (SELECT → FROM → WHERE → ORDER BY → LIMIT).
SELECT actor_id, first_name, last_name FROM actor ORDER BY actor_id LIMIT 5;
SELECT actor_id, first_name, last_name FROM actor ORDER BY actor_id DESC LIMIT 5; --Last 5 actors [Highest]

--OFFSET → how many rows to skip from the top.
SELECT actor_id, first_name, last_name FROM actor ORDER BY actor_id LIMIT 10 OFFSET 10; --Skip first 10 rows and display next 10 rows

--NULL HANDLING (IS NULL, IS NOT NULL) RULE: never use "= NULL" or "!= NULL". Always use "IS NULL" or "IS NOT NULL" for display Null/Empty Values.
SELECT * FROM actor WHERE last_update IS NULL; --Find rows where last_update is NULL (should return 0 rows)
SELECT * FROM actor WHERE last_update IS NOT NULL; -- Find rows where last_update is NOT NULL (should return all 200 rows)

/* PARANTHESES RULES FOR LOGICAL OPERATORS
-------------------------------------------------------------------------------------
Situation        Do you need parentheses?             Example
-------------------------------------------------------------------------------------
Only AND,                 No                            A AND B AND C
Only OR                   No                            A OR B OR C
Mixing AND + OR           Yes                           (A OR B) AND C
Multiple LIKE patterns    Yes                           (LIKE 'A%' OR LIKE 'B%')
NOT with multiple conditions Yes                        NOT (A OR B)

*/

--AGGREGATE FUNCTIONS (COUNT, SUM, AVG, MIN, MAX) EG:["how many"," "total," "average"] Must Use "Aliases". AGGREGATE FUNCTIONS always put after "SELECT" & before "WHERE" statement. 
--NULL values are ignored in aggregate functions except COUNT(*). 
--COUNT(*) counts all rows including NULLs. COUNT(column_name) counts only non-NULL values in that column.
--AVG() ignores NULL values. If all values are NULL, AVG() returns NULL.

SELECT COUNT(*) AS total_actors FROM actor; 
SELECT COUNT(DISTINCT first_name) AS distinct_first_names FROM actor;      /*Count how many Unique first names are there in actor table */
SELECT COUNT(*) AS j_actors FROM actor WHERE first_name LIKE 'J%';         /*Count how many actors have first name starting with ‘J’*/
SELECT MAX(actor_id) AS highest_id, MIN(actor_id) AS lowest_id FROM actor; /*Find the highest and lowest actor_id*/
SELECT AVG(actor_id) AS average_actor_id FROM actor;                       /*Find the average actor_id*/
SELECT MEDIAN(actor_id) AS median_actor_id FROM actor;                     /*Find the median actor_id (formula: Middle two values/2) */

--GROUP BY groups rows that have the same values, then you can use COUNT, SUM, AVG, MAX, MIN on each group. Eg:"how many actors are in each country","Avg Salary of employees in each dept"
--      RULE: Column in "SELECT" that are not part of an aggregate func must be included in the GROUP BY

 SELECT rating, COUNT(*) AS total_films FROM film GROUP BY rating ORDER BY total_films DESC; /*How many films per rating*/
 SELECT * FROM film;

--HAVING is used to filter groups based on aggregate functions.
/*     RULE:You can't use Aggregate functions in the "WHERE" clause. You can only use them in the "HAVING" clause.
            "Aliases" can be used in the "HAVING" clause but not in the "WHERE" clause.
             Filter data before aggregation - Use "WHERE". Filter data after aggregation - Use "HAVING". */

 SELECT rating,COUNT(*) AS total_films FROM film GROUP BY rating HAVING COUNT(*) > 200 ORDER BY total_films DESC; /*Ratings that have more than 200 films*/

--JOINS - Combine rows from two or more tables based on a related column between them. 
--INNER JOIN (Default) - Give me only the matching rows that exist in both tables.
--                       It also display "duplicates"  if there are multiple matches in the second table. (i.e) display more rows than actual rows in the first table.

/*RULE:   Always use "ON" to specify the matching condition between the two tables. 
     2:   Always use "Aliases" for table names to make the query more readable. 
     3:   Always use "ORDER BY" to sort the result set. 
     4:   Always use "LIMIT" to restrict the number of rows returned.
     5:   Order of execution: SELECT → FROM → JOIN → ON → WHERE → GROUP BY → HAVING → ORDER BY → LIMIT.
     6:   NULL Values are not be included in the result set.

     7:   Minimum and Maximum matching Number of Keys/Rows is same. 
          Example: Table A(100 rows) Table B(80 rows) Keys matched (60 rows) means MIN is 60,MAX is also 60.

     8:   Row Explosion: If there are multiple matches in the second table, it will display more rows than actual rows in the first table. 
          Example:       Table A(100 rows) Table B(80 rows) Keys matched (60 rows) means MIN is 60,MAX is 60 but 
                         If there are multiple matches in the second table, it will display more than 60 rows in the result set.

     9:   ROW MULTIPLICATION: Formula: If Table A has N duplicate rows, Table B has M duplicate rows |Result rows = N × M|
          Example:                     Table A -> id 1 1 2  ,  Table B -> id  1 1 1 2 
                                       Result: Total rows= 1 1 1 1 1 1 2 (7 rows) = 6 + 1 = 7 rows. rows for column id1 =2*3=6 rows.

    10.  "FROM a, b WHERE a.id = b.id" is logically same as "FROM a INNER JOIN b ON a.id = b.id".

         
  SYNTAX MEMORIZE:
                  SELECT columns
                  FROM first_table
                  JOIN second_table 
                  ON matching_condition; */
SELECT  a.actor_id,a.first_name,a.last_name,fa.film_id FROM actor a INNER JOIN film_actor fa ON a.actor_id = fa.actor_id ORDER BY a.actor_id LIMIT 10;

--LEFT JOIN- Return all rows from the left table + matching rows from the right table.
--           If there is no match, still keep the left table row and put NULL for right table columns.

SELECT  a.actor_id,a.first_name,fa.film_id FROM actor a LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id;

--RIGHT JOIN- Return all rows from the right table + matching rows from the left table. NULL on Left side,If there is no matching rows.
SELECT  a.actor_id, a.first_name,fa.film_id FROM actor a RIGHT JOIN film_actor fa ON a.actor_id = fa.actor_id;

