## Challenge 1 - Most Profiting Authors
#STEP 1
SELECT 
ta.title_id AS Title_id,
ta.au_id AS Author_id,
 IFNULL(t.price*s.qty*t.royalty/100*ta.royaltyper/100,0) AS sr
FROM titleauthor AS ta 
RIGHT JOIN titles AS t ON t.title_id = ta.title_id
LEFT JOIN sales AS s ON s.title_id = t.title_id;
#STEP 2
SELECT Title_id, Author_id, SUM(sr) AS Total_Royalty
FROM (
	SELECT 
	ta.title_id AS Title_id,
	ta.au_id AS Author_id,
 	IFNULL(t.price*s.qty*t.royalty/100*ta.royaltyper/100,0) AS sr
	FROM titleauthor AS ta 
	RIGHT JOIN titles AS t ON t.title_id = ta.title_id
	LEFT JOIN sales AS s ON s.title_id = t.title_id
	) AS Sales_royalty
GROUP BY Title_id, Author_id;
#STEP3
SELECT Author_id, IFNULL(advance+tr,0) AS Profits
FROM (
	SELECT Title_id, Author_id, SUM(sr) AS tr, advance
			FROM (
			SELECT 
			ta.title_id AS Title_id,
			ta.au_id AS Author_id,
			t.advance AS advance,
	 		IFNULL(t.price*s.qty*t.royalty/100*ta.royaltyper/100,0) AS sr
			FROM titleauthor AS ta 
			RIGHT JOIN titles AS t ON t.title_id = ta.title_id
			LEFT JOIN sales AS s ON s.title_id = t.title_id
			) AS Sales_royalty
	GROUP BY Title_id, Author_id, advance
	) AS Total_royalty
ORDER BY Profits DESC
LIMIT 3;
##Challenge 2 - The other way

CREATE TEMPORARY TABLE Sales_Royalty
SELECT 
ta.title_id AS Title_id,ta.au_id AS Author_id, t.advance AS advance,
IFNULL(t.price*s.qty*t.royalty/100*ta.royaltyper/100,0) AS sr
FROM titleauthor AS ta 
RIGHT JOIN titles AS t ON t.title_id = ta.title_id
LEFT JOIN sales AS s ON s.title_id = t.title_id;

CREATE TEMPORARY TABLE Total_royalty
SELECT sr.Title_id AS Title_id, sr.Author_id AS Author_id , sr.tr AS Total_Royalty, sr.advance AS Advance
FROM Sales_royalty AS sr
GROUP BY sr.Title_id, sr.Author_id, sr.advance;

SELECT Author_id, IFNULL(Advance+Total_Royalty,0) AS Profits
FROM Total_royalty 
ORDER BY Profits DESC
LIMIT 3;

#No esta funcionando, :(, me hago bolas con los nombres. 

##Challenge 3
CREATE TABLE most_profit_authors
SELECT Author_id, IFNULL(advance+tr,0) AS Profits
FROM (
	SELECT Title_id, Author_id, SUM(sr) AS tr, advance
			FROM (
			SELECT 
			ta.title_id AS Title_id,
			ta.au_id AS Author_id,
			t.advance AS advance,
	 		IFNULL(t.price*s.qty*t.royalty/100*ta.royaltyper/100,0) AS sr
			FROM titleauthor AS ta 
			RIGHT JOIN titles AS t ON t.title_id = ta.title_id
			LEFT JOIN sales AS s ON s.title_id = t.title_id
			) AS Sales_royalty
	GROUP BY Title_id, Author_id, advance
	) AS Total_royalty
ORDER BY Profits DESC;

