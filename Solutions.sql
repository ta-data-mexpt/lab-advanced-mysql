# CHALLENGE 1
#PASO 1
USE publications;
CREATE TEMPORARY TABLE publications.saless_royalty
SELECT t.title_id, ta.au_id, (t.price * s.qty * (t.royalty / 100) * (ta.royaltyper / 100)) AS sales_royalty
FROM titles t
LEFT JOIN titleauthor ta
ON t.title_id = ta.title_id
LEFT JOIN sales s
ON t.title_id = s.title_id;

#PASO 2
CREATE TEMPORARY TABLE publications.ag_royalties
SELECT  title_id, au_id, SUM(sales_royalty) AS aggregated_royalties
FROM saless_royalty
GROUP BY au_id,title_id;

#PASO 3 
CREATE TEMPORARY TABLE publications.labante
SELECT au.au_id AS "AUTHOR_ID" , au.au_lname AS "LAST NAME",au.au_fname AS "FIRTS NAME", SUM(sal.qty) AS "TOTAL"
FROM publications.authors au
LEFT JOIN publications.titleauthor titau
ON au.au_id=titau.au_id
LEFT JOIN publications.titles titles
ON titau.title_id=titles.title_id
LEFT JOIN publications. sales sal
ON titles.title_id=sal.title_id 
GROUP BY au.au_id
ORDER BY TOTAL DESC;

SELECT ar.au_id, (ar.aggregated_royalties*l.TOTAL+ t.advance) AS profits
FROM ag_royalties ar
LEFT JOIN labante l
ON ar.au_id=l.AUTHOR_ID
LEFT JOIN titles t
ON ar.title_id=t.title_id
GROUP BY ar.au_id
ORDER BY profits DESC LIMIT 3;

#CHALLENGE 2
SELECT ar.au_id, (ar.aggregated_royalties*l.TOTAL+ t.advance) AS profits
FROM (SELECT  title_id, au_id, SUM(sales_royalty) AS aggregated_royalties
FROM saless_royalty
GROUP BY au_id,title_id) AS ar
LEFT JOIN (SELECT au.au_id AS "AUTHOR_ID" , au.au_lname AS "LAST NAME",au.au_fname AS "FIRTS NAME", SUM(sal.qty) AS "TOTAL"
FROM publications.authors au
LEFT JOIN publications.titleauthor titau
ON au.au_id=titau.au_id
LEFT JOIN publications.titles titles
ON titau.title_id=titles.title_id
LEFT JOIN publications. sales sal
ON titles.title_id=sal.title_id 
GROUP BY au.au_id
ORDER BY TOTAL DESC) AS l
ON ar.au_id=l.AUTHOR_ID
LEFT JOIN titles t
ON ar.title_id=t.title_id
GROUP BY ar.au_id
ORDER BY profits DESC 
LIMIT 3;

#CHALENGE 3
CREATE TABLE publications.most_profiting_authors
SELECT ar.au_id, (ar.aggregated_royalties*l.TOTAL+ t.advance) AS profits
FROM ag_royalties ar
LEFT JOIN labante l
ON ar.au_id=l.AUTHOR_ID
LEFT JOIN titles t
ON ar.title_id=t.title_id
GROUP BY ar.au_id
ORDER BY profits DESC 
LIMIT 3;
#Tengo dudas en si lo hice bien, me gustaría recibir sus comentarios :) gracias!