USE Publications; # CARGA SCHEMA PUBLICATION

SELECT * FROM AUTHORS order by au_id;# IMPRESION DE TABLA CHALLENGE 1
SELECT * FROM titleauthor order by au_id;# IMPRESION DE TABLA CHALLENGE 1
SELECT * FROM titles;# IMPRESION DE TABLA CHALLENGE 1
SELECT * FROM sales order by title_id;# IMPRESION DE TABLA CHALLENGE 1



#TABLA STEP 1
SELECT au_id AS 'AUTHOR ID', a.`title_id` AS 'TITLE ID', au_lname AS 'LAST NAME', au_fname AS 'FIRST NAME', 
b.price * c.qty * (b.royalty / 100) * (a.royaltyper / 100) AS sales_royalty   #a.`royaltyper`, b.`royalty`, c.`qty`
FROM authors
JOIN `titleauthor` a USING(au_id)
JOIN `titles` b USING(title_id)
JOIN `sales` c USING(title_id)
ORDER BY `au_id`;


#TABLA STEP 2 bueno
SELECT au_id AS 'AUTHOR ID', a.`title_id` AS 'TITLE ID', au_lname AS 'LAST NAME', au_fname AS 'FIRST NAME', 
SUM(b.price * c.qty * (b.royalty / 100) * (a.royaltyper / 100)) AS 'TOTAL ROYALTIES'    #a.`royaltyper`, b.`royalty`, c.`qty`
FROM authors
JOIN `titleauthor` a USING(au_id)
JOIN `titles` b USING(title_id)
JOIN `sales` c USING(title_id)
GROUP BY au_id , a.`title_id`
ORDER BY au_id;


#TABLA STEP 3 POR CORREGIR
SELECT au_id AS 'AUTHOR ID', a.`title_id` AS 'TITLE ID', au_lname AS 'LAST NAME', au_fname AS 'FIRST NAME', 
SUM(b.price * c.qty * (b.royalty / 100) * (a.royaltyper / 100)) AS 'TOTAL ROYALTIES'  , sum(b.advance)  #a.`royaltyper`, b.`royalty`, c.`qty`
FROM authors
JOIN `titleauthor` a USING(au_id)
JOIN `titles` b USING(title_id)
JOIN `sales` c USING(title_id)
GROUP BY au_id 
ORDER BY au_id;



CREATE TABLE STEP_3 AS #Bueno step 3
SELECT `AUTHOR ID`,`LAST NAME`,`FIRST NAME`, 
SUM(`TOTAL ROYALTIES`+ T.advance) AS `Profits`   #a.`royaltyper`, b.`royalty`, c.`qty`
FROM STEP_2 S
JOIN TITLES T ON T.title_id = S.`title ID`
GROUP BY `AUTHOR ID` 
LIMIT 3;

SELECT * FROM STEP_3;# IMPRESION DE TABLA STEP 3
DROP TABLE IF EXISTS STEP_3;