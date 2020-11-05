# Challenge 1 - Most Profiting Authors

# Step 1

CREATE TEMPORARY TABLE publications.ind_royalties
SELECT sale.title_id AS `Title ID`, au.au_id AS `AUTHOR ID`, 
titles.price * sale.qty * titles.royalty / 100 * tau.royaltyper / 100 AS `Royalty` #,ifnull(titles.advance,0) AS Advance
FROM publications.authors au
LEFT JOIN publications.titleauthor tau
ON au.au_id = tau.au_id
LEFT JOIN publications.titles titles
ON tau.title_id = titles.title_id
LEFT JOIN publications.sales sale
ON titles.title_id = sale.title_id
ORDER BY au.au_id;

# Step 2

CREATE TEMPORARY TABLE publications.total_royalties
SELECT `Title ID`, `AUTHOR ID`, ifnull(SUM(`Royalty`),0) AS `Royalty`
FROM publications.ind_royalties
GROUP BY `Title ID`, `AUTHOR ID`;

# Step 3

SELECT `AUTHOR ID`, total_royalties.Royalty + titles.advance AS Profit
FROM publications.total_royalties total_royalties
INNER JOIN publications.titles titles
ON total_royalties.`Title ID` = titles.title_id
ORDER BY Profit DESC
LIMIT 3;

# Challenge 2 - Alternative Solution

SELECT `AUTHOR ID`, total_royalties.Royalty + titles.advance AS Profit
FROM(
SELECT `Title ID`, `AUTHOR ID`, ifnull(SUM(`Royalty`),0) AS `Royalty`
FROM(
SELECT sale.title_id AS `Title ID`, au.au_id AS `AUTHOR ID`, 
titles.price * sale.qty * titles.royalty / 100 * tau.royaltyper / 100 AS `Royalty` #,ifnull(titles.advance,0) AS Advance
FROM publications.authors au
LEFT JOIN publications.titleauthor tau
ON au.au_id = tau.au_id
LEFT JOIN publications.titles titles
ON tau.title_id = titles.title_id
LEFT JOIN publications.sales sale
ON titles.title_id = sale.title_id
ORDER BY au.au_id) title_royalties
GROUP BY `Title ID`, `AUTHOR ID`) total_royalties
INNER JOIN publications.titles titles
ON total_royalties.`Title ID` = titles.title_id
ORDER BY Profit DESC
LIMIT 3;

# Challenge 3

CREATE TABLE publications.most_profiting_authors
SELECT `AUTHOR ID`, total_royalties.Royalty + titles.advance AS Profit
FROM publications.total_royalties total_royalties
INNER JOIN publications.titles titles
ON total_royalties.`Title ID` = titles.title_id
ORDER BY Profit DESC
LIMIT 3;