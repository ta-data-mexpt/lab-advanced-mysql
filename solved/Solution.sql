USE publications;
-- C1
	-- FIRST
SELECT titleauthor.title_ID, titleauthor.au_id, 
(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) "sales_royalty"
FROM titleauthor 
JOIN titles ON titles.title_id = titleauthor.title_id
JOIN authors ON authors.au_id = titleauthor.au_id
JOIN sales ON sales.title_id = titleauthor.title_id
ORDER BY titleauthor.title_id;

	-- SECOND
SELECT ro.title_ID, ro.au_id, SUM(sales_royalty) "Total Royalties"
FROM (
SELECT titleauthor.title_ID, titleauthor.au_id, 
(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) "sales_royalty"
FROM titleauthor 
JOIN titles ON titles.title_id = titleauthor.title_id
JOIN authors ON authors.au_id = titleauthor.au_id
JOIN sales ON sales.title_id = titleauthor.title_id) as ro
group by ro.au_id, ro.title_id;

	-- THIRD
SELECT ro.au_id, SUM(sales_royalty) "All_Royalties"
FROM (
SELECT titleauthor.title_ID, titleauthor.au_id, 
(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) "sales_royalty"
FROM titleauthor 
JOIN titles ON titles.title_id = titleauthor.title_id
JOIN authors ON authors.au_id = titleauthor.au_id
JOIN sales ON sales.title_id = titleauthor.title_id) as ro
Group by ro.au_id ORDER BY All_Royalties desc
LIMIT 3;

-- C2
CREATE TEMPORARY TABLE Rylty_TableTemp
SELECT titleauthor.au_id, titleauthor.title_ID,  
(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) "sales_royalty"
FROM titleauthor 
JOIN titles ON titles.title_id = titleauthor.title_id
JOIN authors ON authors.au_id = titleauthor.au_id
JOIN sales ON sales.title_id = titleauthor.title_id;

SELECT au_id, SUM(sales_royalty) "SUM_Royalties" FROM Rylty_TableTemp
GROUP BY au_id ORDER BY SUM_Royalties desc
LIMIT 3;

-- C3
CREATE TABLE authors_fifis
SELECT au_id, SUM(sales_royalty) "profits" FROM Rylty_TableTemp
GROUP BY au_id ORDER BY profits desc
LIMIT 3;

select * from authors_fifis
-- Creo que con las correcciones de Zahid esto ya debe de quedar.
