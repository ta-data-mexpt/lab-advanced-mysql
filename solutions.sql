#Challenge 1 - Most Profiting Authors
#Step 1: Calculate the royalties of each sales for each author
SELECT titleauthor.title_ID, titleauthor.au_id, 
(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) "sales_royalty"
FROM titleauthor 
JOIN titles 
ON titles.title_id = titleauthor.title_id
JOIN sales
ON sales.title_id = titleauthor.title_id
ORDER BY titleauthor.title_id;

#Step 2: Aggregate the total royalties for each title for each author
SELECT royalties.title_ID, royalties.au_id, SUM(sales_royalty) "All_royalties"
FROM(
SELECT titleauthor.title_ID, titleauthor.au_id, 
(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) "sales_royalty"
FROM titleauthor 
JOIN titles 
ON titles.title_id = titleauthor.title_id
JOIN sales
ON sales.title_id = titleauthor.title_id
ORDER BY titleauthor.title_id) AS royalties
GROUP BY royalties.au_id, royalties.title_id;
#lo interesate es tener que asignarle un nombre al input del paso 1, no encontré otra manera de poder realizar el ejericio

#Step 3: Calculate the total profits of each author
SELECT *, AuthorID, titles.advance * (titleauthor.royaltyper / 100) + Royalties AS Profit
FROM (SELECT TitleID, AuthorID, SUM(Royalty) AS Royalties
FROM (SELECT titles.title_id AS TitleID, titleauthor.au_id AS AuthorID, titles.price * sales.qty * (titles.royalty / 100) * (titleauthor.royaltyper / 100) AS Royalty
FROM titleauthor
JOIN titles ON titles.title_id = titleauthor.title_id
JOIN sales ON titles.title_id = sales.title_id) AS royaltiies
GROUP BY royaltiies.TitleID, royaltiies.AuthorID) AS royal_author_title
JOIN titles  ON royal_author_title.TitleID = titles.title_id
JOIN titleauthor ON titles.title_id = titleauthor.title_id;

#Challenge 2 - Alternative Solution
SELECT *, AuthorID, titles.advance * (titleauthor.royaltyper / 100) + Royalties AS Profit
FROM (SELECT TitleID, AuthorID, SUM(Royalty) AS Royalties
FROM (SELECT titles.title_id AS TitleID, titleauthor.au_id AS AuthorID, titles.price * sales.qty * (titles.royalty / 100) * (titleauthor.royaltyper / 100) AS Royalty
FROM titleauthor
JOIN titles ON titles.title_id = titleauthor.title_id
JOIN sales ON titles.title_id = sales.title_id) AS royaltiies
GROUP BY royaltiies.TitleID, royaltiies.AuthorID) AS royal_author_title
JOIN titles  ON royal_author_title.TitleID = titles.title_id
JOIN titleauthor ON titles.title_id = titleauthor.title_id
GROUP BY AuthorID;

#Challenge 3
CREATE TEMPORARY TABLE temp_royalty
SELECT titleauthor.au_id, titleauthor.title_id, (titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) "sales_royalty"
FROM titleauthor
JOIN titles 
ON titles.title_id = titleauthor.title_id
JOIN sales 
ON sales.title_id = titleauthor.title_id;

CREATE TEMPORARY TABLE temp_royalty2
SELECT temp_royalty.title_id, temp_royalty.au_id, SUM(sales_royalty) "All_royalties"
FROM temp_royalty
GROUP BY temp_royalty.au_id, temp_royalty.title_id;

CREATE TABLE most_profiting_authors
SELECT royal_author_title.au_id, SUM(titles.advance * (titleauthor.royaltyper / 100) + "All_royalties") AS Profit
FROM temp_royalty2 AS royal_author_title
JOIN titles ON royal_author_title.title_id = titles.title_id
JOIN  titleauthor ON titles.title_id = titleauthor.title_id AND royal_author_title.au_id = titleauthor.au_id
GROUP BY  royal_author_title.au_id
ORDER BY Profit DESC
LIMIT 10;
#Me sale Error Code: 1292. Truncated incorrect DOUBLE value: 'All_royalties'