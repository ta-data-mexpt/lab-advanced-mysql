#Challenge1
SELECT titleauthor.title_id AS titleID, titleauthor.au_id 
AS authorID, titles.price * sales.qty * titles.royalty / 100 *  titleauthor.royaltyper / 100 AS sales_royalty
FROM publications.titleauthor titleauthor
RIGHT JOIN publications.titles titles ON titleauthor.title_id = titles.title_id
JOIN publications.sales sales ON titles.title_id = sales.title_id;

CREATE TEMPORARY TABLE agreggated_total_royalties SELECT titleID, authorID, SUM(sales_royalty) AS totalRoyalties
FROM (SELECT titleauthor.title_id AS titleID, titleauthor.au_id AS authorID, titles.price * sales.qty * titles.royalty / 100 *  titleauthor.royaltyper / 100 AS sales_royalty
FROM publications.titleauthor titleauthor
RIGHT JOIN publications.titles titles ON titleauthor.title_id = titles.title_id
JOIN publications.sales sales ON titles.title_id = sales.title_id) royalties_per_sales
GROUP BY royalties_per_sales.authorID, royalties_per_sales.titleID;


SELECT authorID, titles.advance + totalRoyalties AS Profits
FROM agreggated_total_royalties
JOIN publications.titles titles ON agreggated_total_royalties.titleID = titles.title_id
ORDER BY Profits DESC;


#CHALLENGE2


#CHALLENGE 3

CREATE TABLE prof_authors 
SELECT authorID, titles.advance + totalRoyalties AS Profits
FROM(SELECT titleID, authorID, SUM(sales_royalty) AS totalRoyalties
FROM (SELECT titleauthor.title_id AS titleID, titleauthor.au_id AS authorID, titles.price * sales.qty * titles.royalty / 100 *  titleauthor.royaltyper / 100 AS sales_royalty
FROM publications.titleauthor titleauthor
RIGHT JOIN publications.titles titles ON titleauthor.title_id = titles.title_id
JOIN publications.sales sales ON titles.title_id = sales.title_id) royalties_per_sales
GROUP BY royalties_per_sales.authorID, royalties_per_sales.titleID) agreggated_total_royalties
JOIN publications.titles titles ON agreggated_total_royalties.titleID = titles.title_id
ORDER BY Profits DESC;
