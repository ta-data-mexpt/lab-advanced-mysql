#CHALLENGE 1
#Step 1
CREATE TEMPORARY TABLE  publications.PROFIT_SALE
SELECT titles.title_id, authors.au_id, ROUND((titles.price*sales.qty*(titleauthor.royaltyper/100)*(titles.royalty/100)),2) AS 'Profit' 
FROM publications.authors AS authors
JOIN publications.titleauthor AS titleauthor
ON authors.au_id = titleauthor.au_id
JOIN publications.titles AS titles
ON titleauthor.title_id = titles.title_id
JOIN publications.sales
ON titles.title_id = sales.title_id
GROUP BY titles.title_id, authors.au_id, Profit
ORDER BY titles.title_id;
#Comprobacion
SELECT *
FROM publications.PROFIT_SALE;

#Step 2
CREATE TEMPORARY TABLE  publications.PROFIT_TITLE
SELECT PROFIT_SALE.title_id, PROFIT_SALE.au_id, SUM(PROFIT_SALE.Profit) AS 'Title_profit'
FROM publications.PROFIT_SALE
GROUP BY PROFIT_SALE.title_id, PROFIT_SALE.au_id;
#Comprobacion
SELECT *
FROM publications.PROFIT_TITLE
ORDER BY PROFIT_TITLE.au_id;

#Step 3
SELECT PROFIT_TITLE.au_id, SUM(PROFIT_TITLE.Title_profit) AS 'Total_profit'
FROM publications.PROFIT_TITLE
GROUP BY PROFIT_TITLE.au_id
ORDER BY Total_profit DESC
LIMIT 3;
-- -----------------------------------------------------------------
#CHALLENGE 2
SELECT b.au_id, SUM(b.Title_profit) AS 'Total_profit'
FROM
(SELECT a.title_id, a.au_id, SUM(a.Profit) AS 'Title_profit'
FROM
(SELECT titles.title_id, authors.au_id, ROUND((titles.price*sales.qty*(titleauthor.royaltyper/100)*(titles.royalty/100)),2) AS 'Profit' 
FROM publications.authors AS authors
JOIN publications.titleauthor AS titleauthor
ON authors.au_id = titleauthor.au_id
JOIN publications.titles AS titles
ON titleauthor.title_id = titles.title_id
JOIN publications.sales
ON titles.title_id = sales.title_id
GROUP BY titles.title_id, authors.au_id, Profit
ORDER BY titles.title_id) AS a
GROUP BY a.title_id, a.au_id) AS b
GROUP BY b.au_id
ORDER BY Total_profit DESC
LIMIT 3;
-- --------------------------------
#CHALLENGE 3
CREATE TABLE publications.most_profiting_authors
SELECT PROFIT_TITLE.au_id, SUM(PROFIT_TITLE.Title_profit) AS 'Profits'
FROM publications.PROFIT_TITLE
GROUP BY PROFIT_TITLE.au_id
ORDER BY Profits DESC
LIMIT 3;
