USE pubs;

#CHALLENGE 1 - Most Profiting Authors (SUBQUERIES)

#Step 1: Calculate the royalties of each sales from each author
#What I want: Title ID, Author ID, Royalty sale for each author
#From where:authors, titleauthor, titles.advance, roysched.royalty, saleees

SELECT * FROM sales;
SELECT * FROM titles;

SELECT titles.title_id AS TITLE_ID, authors.au_id AS AUTHOR_ID, titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100 AS SALES_ROYALTY
FROM authors
LEFT JOIN titleauthor
USING(au_id)
LEFT JOIN titles
USING(title_id)
LEFT JOIN sales
USING(title_id)
GROUP BY authors.au_id, titles.title_id
ORDER BY SALES_ROYALTY DESC;

#Step 2: Aggregate the total royalties for each title for each author
#What I want: Title ID, Author ID, Aggregated royalties of each title for each author
#From where:authors, titleauthor, titles.advance, roysched.royalty, saleees

SELECT ROY_1.title_id AS TITLE_ID, ROY_1.au_id AS Author_ID, SUM(SALES_ROYALTY) AS AGG_ROYALTY
FROM (SELECT titles.title_id, authors.au_id, titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100 AS SALES_ROYALTY
FROM authors
LEFT JOIN titleauthor
USING(au_id)
LEFT JOIN titles
USING(title_id)
LEFT JOIN sales
USING(title_id)
ORDER BY SALES_ROYALTY DESC) as ROY_1
GROUP BY au_id, title_id;

#Step 3: Calculate the total profits of each author
#What I want: Title ID, Author ID, Aggregated royalties of each title for each author
#From where:authors, titleauthor, titles.advance, roysched.royalty, saleees

SELECT ROY_2.au_id, (titles.advance + ROY_2.AGG_ROYALTY) AS PROFITS
FROM (SELECT ROY_1.title_id, ROY_1.au_id, SUM(SALES_ROYALTY) AS AGG_ROYALTY
FROM (SELECT titles.title_id, authors.au_id, titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100 AS SALES_ROYALTY
FROM authors
LEFT JOIN titleauthor
USING(au_id)
LEFT JOIN titles
USING(title_id)
LEFT JOIN sales
USING(title_id)
ORDER BY SALES_ROYALTY DESC) AS ROY_1
GROUP BY au_id, title_id) as ROY_2
JOIN titles
USING(title_id)
ORDER BY PROFITS DESC LIMIT 3;

#CHALLENGE 2 - Most Profiting Authors (TEMPORARY TABLES)

#Step 1: Calculate the royalties of each sales from each author
#What I want: Title ID, Author ID, Royalty sale for each author
#From where:authors, titleauthor, titles.advance, roysched.royalty, saleees

DROP TEMPORARY TABLE sales_roy;

CREATE TEMPORARY TABLE sales_roy
SELECT titles.title_id, authors.au_id, titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100 AS SALES_ROYALTY
FROM authors
LEFT JOIN titleauthor
USING(au_id)
LEFT JOIN titles
USING(title_id)
LEFT JOIN sales
USING(title_id)
GROUP BY authors.au_id, titles.title_id
ORDER BY SALES_ROYALTY DESC;

#Step 2: Aggregate the total royalties for each title for each author
#What I want: Title ID, Author ID, Aggregated royalties of each title for each author
#From where:authors, titleauthor, titles.advance, roysched.royalty, saleees

DROP TEMPORARY TABLE agg_roy;

CREATE TEMPORARY TABLE agg_roy
SELECT title_id, au_id, SUM(SALES_ROYALTY) AS AGG_ROYALTY
FROM sales_roy
GROUP BY au_id, title_id;

#Step 3: Calculate the total profits of each author
#What I want: Title ID, Author ID, Aggregated royalties of each title for each author
#From where:authors, titleauthor, titles.advance, roysched.royalty, saleees

SELECT agg_roy.au_id, (titles.advance + agg_roy.AGG_ROYALTY) AS PROFITS
FROM agg_roy
JOIN titles
USING(title_id)
ORDER BY PROFITS DESC LIMIT 3;

#CHALLENGE 3 - CREATE A PERMANENT TABLE

CREATE TABLE most_profiting_authors
SELECT agg_roy.au_id, (titles.advance + agg_roy.AGG_ROYALTY) AS PROFITS
FROM agg_roy
JOIN titles
USING(title_id)
ORDER BY PROFITS DESC LIMIT 3;

SELECT * FROM most_profiting_authors;
