USE Publications; # CARGA SCHEMA PUBLICATION

SELECT * FROM AUTHORS order by au_id;# IMPRESION DE TABLA CHALLENGE 1
SELECT * FROM titleauthor order by au_id;# IMPRESION DE TABLA CHALLENGE 1
SELECT * FROM titles;# IMPRESION DE TABLA CHALLENGE 1
SELECT * FROM sales order by title_id;# IMPRESION DE TABLA CHALLENGE 1



CREATE TABLE STEP_1 AS #BUENO step 1
SELECT au_id AS 'AUTHOR ID', a.`title_id` AS 'TITLE ID', au_lname AS 'LAST NAME', au_fname AS 'FIRST NAME', 
b.price * c.qty * (b.royalty / 100) * (a.royaltyper / 100) AS sales_royalty   #a.`royaltyper`, b.`royalty`, c.`qty`
FROM authors
JOIN `titleauthor` a USING(au_id)
JOIN `titles` b USING(title_id)
JOIN `sales` c USING(title_id)
ORDER BY `au_id`;

SELECT * FROM STEP_1;# IMPRESION DE TABLA STEP 2
DROP TABLE IF EXISTS STEP_1;

CREATE TABLE STEP_2 AS #Bueno step 2
SELECT `AUTHOR ID`,`TITLE ID`,`LAST NAME`,`FIRST NAME`, 
SUM(sales_royalty) AS 'TOTAL ROYALTIES'   #a.`royaltyper`, b.`royalty`, c.`qty`
FROM STEP_1
GROUP BY `AUTHOR ID`, `TITLE ID` ;

SELECT * FROM STEP_2;# IMPRESION DE TABLA STEP 2
DROP TABLE IF EXISTS STEP_2;

SELECT * FROM titles;# IMPRESION DE TABLA title para ver y sacar advance


CREATE TABLE STEP_3 AS #Bueno step 3
SELECT `AUTHOR ID`,`LAST NAME`,`FIRST NAME`, 
SUM(`TOTAL ROYALTIES`+ T.advance) AS `Profits`   #a.`royaltyper`, b.`royalty`, c.`qty`
FROM STEP_2 S
JOIN TITLES T ON T.title_id = S.`title ID`
GROUP BY `AUTHOR ID` 
LIMIT 3;

SELECT * FROM STEP_3;# IMPRESION DE TABLA STEP 3
DROP TABLE IF EXISTS STEP_3;


########################### CHALLENGE 2

CREATE TEMPORARY TABLE STEP_1_temp AS #BUENO step 1
SELECT au_id AS 'AUTHOR ID', a.`title_id` AS 'TITLE ID', au_lname AS 'LAST NAME', au_fname AS 'FIRST NAME', 
b.price * c.qty * (b.royalty / 100) * (a.royaltyper / 100) AS sales_royalty   #a.`royaltyper`, b.`royalty`, c.`qty`
FROM authors
JOIN `titleauthor` a USING(au_id)
JOIN `titles` b USING(title_id)
JOIN `sales` c USING(title_id)
ORDER BY `au_id`;
SELECT * FROM STEP_1_temp;# IMPRESION DE TABLA STEP 2
DROP TABLE IF EXISTS STEP_1_temp;

CREATE TEMPORARY TABLE STEP_2_temp AS #Bueno step 2
SELECT `AUTHOR ID`,`TITLE ID`,`LAST NAME`,`FIRST NAME`, 
SUM(sales_royalty) AS 'TOTAL ROYALTIES'   #a.`royaltyper`, b.`royalty`, c.`qty`
FROM STEP_1_temp
GROUP BY `AUTHOR ID`, `TITLE ID` ;

SELECT * FROM STEP_2_temp;# IMPRESION DE TABLA STEP 2
DROP TABLE IF EXISTS STEP_2_temp;

CREATE TEMPORARY TABLE  STEP_3_temp AS #Bueno step 3
SELECT `AUTHOR ID`,`LAST NAME`,`FIRST NAME`, 
SUM(`TOTAL ROYALTIES`+ T.advance) AS `Profits`   #a.`royaltyper`, b.`royalty`, c.`qty`
FROM STEP_2_temp S
JOIN TITLES T ON T.title_id = S.`title ID`
GROUP BY `AUTHOR ID` 
LIMIT 3;

SELECT * FROM STEP_3_temp;# IMPRESION DE TABLA STEP 3
DROP TABLE IF EXISTS STEP_3_temp;

######################## CHALLENGE 3


CREATE TABLE  most_profiting_authors AS # most_profiting_authors CREA TABLA
SELECT `AUTHOR ID`,`LAST NAME`,`FIRST NAME`, 
SUM(`TOTAL ROYALTIES`+ T.advance) AS `Profits`   #a.`royaltyper`, b.`royalty`, c.`qty`
FROM STEP_2_temp S
JOIN TITLES T ON T.title_id = S.`title ID`
GROUP BY `AUTHOR ID` 
LIMIT 3;

SELECT * FROM most_profiting_authors;# IMPRESION DE TABLA STEP 3
DROP TABLE IF EXISTS most_profiting_authors;

