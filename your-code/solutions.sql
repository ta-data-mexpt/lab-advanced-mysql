USE publications;
-- Challenge 1
-- Step #1
SELECT titleauthor.title_ID, titleauthor.au_id, 
(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) "sales_royalty"
FROM titleauthor 
JOIN titles 
ON titles.title_id = titleauthor.title_id
JOIN authors
ON authors.au_id = titleauthor.au_id
JOIN sales
ON sales.title_id = titleauthor.title_id
ORDER BY titleauthor.title_id;

-- Step #2
SELECT ro.title_ID, ro.au_id, SUM(sales_royalty) "All Royalties"
FROM (
SELECT titleauthor.title_ID, titleauthor.au_id, 
(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) "sales_royalty"
FROM titleauthor 
JOIN titles 
ON titles.title_id = titleauthor.title_id
JOIN authors
ON authors.au_id = titleauthor.au_id
JOIN sales
ON sales.title_id = titleauthor.title_id) as ro
group by ro.au_id, ro.title_id;

-- Step #3
SELECT ro.au_id, SUM(sales_royalty) "All_Royalties"
FROM (
SELECT titleauthor.title_ID, titleauthor.au_id, 
(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) "sales_royalty"
FROM titleauthor 
JOIN titles 
ON titles.title_id = titleauthor.title_id
JOIN authors
ON authors.au_id = titleauthor.au_id
JOIN sales
ON sales.title_id = titleauthor.title_id) as ro
Group by ro.au_id
ORDER BY All_Royalties desc
LIMIT 3;

-- Challenge 2
CREATE TEMPORARY TABLE temp_royalty_table
SELECT titleauthor.au_id, titleauthor.title_ID,  
(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) "sales_royalty"
FROM titleauthor 
JOIN titles 
ON titles.title_id = titleauthor.title_id
JOIN authors
ON authors.au_id = titleauthor.au_id
JOIN sales
ON sales.title_id = titleauthor.title_id;

SELECT au_id, SUM(sales_royalty) "Total_Royalties" FROM temp_royalty_table
GROUP BY au_id
ORDER BY Total_Royalties desc
LIMIT 3;

-- Challenge 3
CREATE TABLE most_profiting_authors
SELECT au_id, SUM(sales_royalty) "profits" FROM temp_royalty_table
GROUP BY au_id
ORDER BY profits desc
LIMIT 3;

select * from most_profiting_authors