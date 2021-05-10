USE publications;

-- CHALLENGE 1
CREATE TEMPORARY TABLE Sales_Royalty_Temp_1
SELECT t.title_id AS TitleID, ta.au_id AS AuthorID, t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100 AS Sales_Royalty
FROM titles t
JOIN sales s
	ON t.title_id = s.title_id
JOIN titleauthor ta
	ON ta.title_id = s.title_id
;

CREATE TEMPORARY TABLE Sales_Royalty_Temp_2
SELECT TitleID, AuthorID, SUM(Sales_Royalty) AS Total_Royalty
FROM Sales_Royalty_Temp_1
GROUP BY Sales_Royalty_Temp_1.TitleID, Sales_Royalty_Temp_1.AuthorID;

CREATE TEMPORARY TABLE Sales_Royalty_Temp_3
SELECT AuthorID, titles.advance*(titleauthor.royaltyper/100)+Total_Royalty AS Profit
FROM Sales_Royalty_Temp_2
JOIN titles 
	ON Sales_Royalty_Temp_2.TitleID=titles.title_id
JOIN titleauthor 
	ON titles.title_id=titleauthor.title_id
GROUP BY Sales_Royalty_Temp_2.AuthorID
ORDER BY Profit DESC
LIMIT 3;

-- CHALLENGE 2


-- CHALLENGE 3    
SELECT AuthorID, titles.advance + Sales_Royalty_Temp_2.Total_Royalty AS Profits
FROM Sales_Royalty_Temp_3
JOIN titleauthor
	ON Sales_Royalty_Temp_3.au_id = titleauthor.au_id
JOIN titles
	ON Sales_Royalty_Temp_3.title_id = title.title_id
;