#Challenge 1 - Most Profiting Authors

#Step 1:Calculate the profit of each sale for each author 
 CREATE TEMPORARY TABLE  publications.PROFIT_SALE
 SELECT 
 titles.title_id 'TITLES_ID', 
 authors.au_id 'AUTHOR_ID', 
 (titles.price*sales.qty*(titleauthor.royaltyper/100)*(titles.royalty/100)) 'PROFIT' #royalty of each sale for each author
 
 FROM publications.authors AS au
 LEFT JOIN publications.titleauthor AS ti_au
 ON au.au_id = ti_au.au_id
 LEFT JOIN publications.titles AS ti
 ON ti_au.title_id = ti.title_id
 LEFT JOIN publications.sales AS sa
 ON ti.title_id = sa.title_id
 GROUP BY TITLES_ID, AUTHOR_ID, PROFIT
 ORDER BY ti.title_id;
 #Comprobacion
 SELECT *
 FROM publications.PROFIT_SALE;

 #Step 2: Aggregate the total royalties for each title for each author
 CREATE TEMPORARY TABLE  publications.PROFIT_TITLE
 SELECT 
 PROFIT_SALE.title_id, 
 PROFIT_SALE.au_id, 
 SUM(PROFIT_SALE.Profit) AS 'TITLE_PROFIT'
 FROM publications.PROFIT_SALE
 GROUP BY PROFIT_SALE.title_id, PROFIT_SALE.au_id;
 #Comprobacion
 SELECT *
 FROM publications.PROFIT_TITLE
 ORDER BY PROFIT_TITLE.au_id;

 #Step 3: Calculate the total profits of each author
 SELECT 
 PROFIT_TITLE.au_id, 
 SUM(PROFIT_TITLE.Title_profit) AS 'TOTAL_PROFIT'
 FROM publications.PROFIT_TITLE
 GROUP BY PROFIT_TITLE.au_id
 ORDER BY TOTAL_PROFIT DESC
 LIMIT 3;
 
 
 #Challenge 2 - Alternative Solution

SELECT b.au_id, SUM(b.Title_profit) AS 'Total_profit'
 FROM
 (SELECT a.title_id, a.au_id, SUM(a.Profit) AS 'Title_profit'
 FROM
 (SELECT titles.title_id, authors.au_id, (titles.price*sales.qty*(titleauthor.royaltyper/100)*(titles.royalty/100)) AS 'Profit' 
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
 
 
 #Challenge 3
#Elevating from your solution in Challenge 1 & 2, create a permanent table named most_profiting_authors to hold the data about the most profiting authors. The table should have 2 columns:

#au_id - Author ID
#profits - The profits of the author aggregating the advances and royalties
CREATE TABLE publications.most_profiting_authors
SELECT PROFIT_TITLE.au_id, SUM(PROFIT_TITLE.Title_profit) AS 'Profits'
FROM publications.PROFIT_TITLE
GROUP BY PROFIT_TITLE.au_id
ORDER BY Profits DESC
LIMIT 3;



