/* Advanced MySQL */
USE publications;


/* CHALLENGE 1 */
CREATE TEMPORARY TABLE publications.sales_royxqty 
SELECT ta.au_id AS AuthorID, titles.title AS Title, (titles.price * publications.sales.qty * titles.royalty / 100 * ta.royaltyper / 100) AS TotalProfit
FROM titles
LEFT JOIN titleauthor ta
ON ta.title_id = titles.title_id
RIGHT JOIN sales
ON ta.title_id = sales.title_id;

SELECT AuthorID, SUM(TotalProfit) AS Profits
FROM publications.sales_royxqty
GROUP BY AuthorID
ORDER BY TotalByBook DESC
LIMIT 3; 

/* CHALLENGE 2 */
SELECT ta.au_id AS AuthorID, Titles.title AS Title, SUM((Titles.price * publications.sales.qty * Titles.royalty / 100 * ta.royaltyper / 100)) AS TotalProfit
FROM titles AS Titles
LEFT JOIN titleauthor ta
ON ta.title_id = titles.title_id
RIGHT JOIN sales
ON ta.title_id = sales.title_id
GROUP BY 1
ORDER BY 3 DESC
LIMIT 3;


/* CHALLENGE 3 */
CREATE TABLE most_profiting_authors
SELECT AuthorID, SUM(TotalProfit) AS Profits
FROM publications.sales_royxqty
GROUP BY AuthorID
ORDER BY Profits DESC
LIMIT 3; 

SELECT *
FROM most_profiting_authors;