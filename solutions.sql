
SELECT sales.title_id, titleauthor.au_id, roysched.royalty, titles.price * sales.qty * (titles.royalty / 100) * (titleauthor.royaltyper / 100) AS sales_royalty
FROM titleauthor
JOIN sales
USING(title_id)
JOIN roysched
USING (title_id)
JOIN titles
USING (title_id);

SELECT title_id, au_id, SUM(sales_royalty) AS sum_sales_royalty
FROM (SELECT sales.title_id, titleauthor.au_id, roysched.royalty, titles.price * sales.qty * (titles.royalty / 100) * (titleauthor.royaltyper / 100) AS sales_royalty
FROM titleauthor
JOIN sales
USING(title_id)
JOIN roysched
USING (title_id)
JOIN titles
USING (title_id)) as table2
GROUP BY au_id, title_id;

SELECT au_id, (sum_sales_royalty + titles.advance) AS total_profit
FROM (SELECT title_id, au_id, SUM(sales_royalty) AS sum_sales_royalty
FROM (SELECT sales.title_id, titleauthor.au_id, roysched.royalty, titles.price * sales.qty * (titles.royalty / 100) * (titleauthor.royaltyper / 100) AS sales_royalty
FROM titleauthor
JOIN sales
USING(title_id)
JOIN roysched
USING (title_id)
JOIN titles
USING (title_id)) AS table2 
GROUP BY au_id, title_id) AS table3
JOIN titles
USING(title_id)
ORDER BY total_profit DESC
LIMIT 3;

#CHALLENGE#2

CREATE TEMPORARY TABLE Royal
SELECT sales.title_id, titleauthor.au_id, roysched.royalty, titles.price * sales.qty * (titles.royalty / 100) * (titleauthor.royaltyper / 100) AS sales_roy
FROM titleauthor
JOIN sales
USING(title_id)
JOIN roysched
USING (title_id)
JOIN titles
USING (title_id);

CREATE TEMPORARY TABLE Royal2
SELECT title_id, au_id, SUM(sales_roy) AS sum_sales_roy
FROM Royal
GROUP BY au_id, title_id;

CREATE TEMPORARY TABLE Royal3
SELECT au_id, (sum_sales_roy + titles.advance) AS total_prof
FROM Royal2
JOIN titles
USING(title_id);

SELECT au_id, total_prof
FROM Royal3
ORDER BY total_prof DESC
LIMIT 3;

#CHALLENGE #3

CREATE TABLE most_profiting_authors
SELECT au_id, total_prof
FROM Royal3;

SELECT * FROM most_profiting_authors;
