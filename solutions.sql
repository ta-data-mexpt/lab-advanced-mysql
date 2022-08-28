# FIRST SOLUTION: USING SUBQUERIES

# STEP 1: Calculate the royalties of each sales for each author

SELECT titles.title_id, titles.title, 
titles.advance * (titles.royalty/100) * (titleauthor.royaltyper/100) AS advance_royalties, 
authors.au_id, authors.au_fname, authors.au_lname,
titles.price * sales.qty * (titles.royalty/100) * (titleauthor.royaltyper/100) AS sales_royalty
FROM titles
LEFT JOIN titleauthor ON titles.title_id = titleauthor.title_id
LEFT JOIN authors ON titleauthor.au_id = authors.au_id
LEFT JOIN sales ON titles.title_id = sales.title_id
WHERE titleauthor.au_id;

# STEP 2: Aggregate the total royalties for each title for each author

SELECT title_id, title, au_id, au_fname, au_lname,
SUM(sales_royalty) AS total_sales_royalty, SUM(advance_royalties) AS total_advance_royalties FROM 
	(SELECT titles.title_id, titles.title, 
	titles.advance * (titles.royalty/100) * (titleauthor.royaltyper/100) AS advance_royalties, 
	authors.au_id, authors.au_fname, authors.au_lname,
	titles.price * sales.qty * (titles.royalty/100) * (titleauthor.royaltyper/100) AS sales_royalty
	FROM titles
	LEFT JOIN titleauthor ON titles.title_id = titleauthor.title_id
	LEFT JOIN authors ON titleauthor.au_id = authors.au_id
	LEFT JOIN sales ON titles.title_id = sales.title_id
	WHERE titleauthor.au_id IS NOT NULL) AS royalties
GROUP BY au_id, title_id;

# STEP 3: Calculate the total profits of each author

SELECT au_id, au_fname, au_lname, total_advance_royalties + total_sales_royalty AS total_earnings FROM 
	(SELECT title_id, title, au_id, au_fname, au_lname,
	SUM(sales_royalty) AS total_sales_royalty, SUM(advance_royalties) AS total_advance_royalties FROM 
		(SELECT titles.title_id, titles.title, 
		titles.advance * (titles.royalty/100) * (titleauthor.royaltyper/100) AS advance_royalties, 
		authors.au_id, authors.au_fname, authors.au_lname,
		titles.price * sales.qty * (titles.royalty/100) * (titleauthor.royaltyper/100) as sales_royalty
		FROM titles
		LEFT JOIN titleauthor ON titles.title_id = titleauthor.title_id
		LEFT JOIN authors ON titleauthor.au_id = authors.au_id
		LEFT JOIN sales ON titles.title_id = sales.title_id
		WHERE titleauthor.au_id IS NOT NULL) AS royalties
	GROUP BY au_id, title_id) AS royalties_agg
ORDER BY total_earnings DESC;

# SECOND SOLUTION: USING TEMPORARY TABLES

# STEP 1: Create temporary table with the royalties of each sales for each author

CREATE TEMPORARY TABLE royalties
SELECT titles.title_id, titles.title, 
titles.advance * (titles.royalty/100) * (titleauthor.royaltyper/100) AS advance_royalties, 
authors.au_id, authors.au_fname, authors.au_lname,
titles.price * sales.qty * (titles.royalty/100) * (titleauthor.royaltyper/100) AS sales_royalty
FROM titles
LEFT JOIN titleauthor ON titles.title_id = titleauthor.title_id
LEFT JOIN authors ON titleauthor.au_id = authors.au_id
LEFT JOIN sales ON titles.title_id = sales.title_id
WHERE titleauthor.au_id IS NOT NULL;

# STEP 2: Create temporary table which aggregates the total royalties for each title for each author, using data from previous table

CREATE TEMPORARY TABLE royalties_agg
SELECT title_id, title, au_id, au_fname, au_lname,
SUM(sales_royalty) AS total_sales_royalty, SUM(advance_royalties) AS total_advance_royalties 
FROM royalties
GROUP BY au_id, title_id;

# STEP 3: Calculate the total profits of each author using the data from the previous table

SELECT au_id, au_fname, au_lname, 
total_advance_royalties + total_sales_royalty AS total_earnings 
FROM royalties_agg
ORDER BY total_earnings DESC;

# SECOND CHALLENGE: CREATE PERMANENT TABLE

CREATE TABLE profits
SELECT au_id, au_fname, au_lname, total_advance_royalties + total_sales_royalty AS total_earnings FROM 
	(SELECT title_id, title, au_id, au_fname, au_lname,
	SUM(sales_royalty) AS total_sales_royalty, SUM(advance_royalties) AS total_advance_royalties FROM 
		(SELECT titles.title_id, titles.title, 
		titles.advance * (titles.royalty/100) * (titleauthor.royaltyper/100) AS advance_royalties, 
		authors.au_id, authors.au_fname, authors.au_lname,
		titles.price * sales.qty * (titles.royalty/100) * (titleauthor.royaltyper/100) as sales_royalty
		FROM titles
		LEFT JOIN titleauthor ON titles.title_id = titleauthor.title_id
		LEFT JOIN authors ON titleauthor.au_id = authors.au_id
		LEFT JOIN sales ON titles.title_id = sales.title_id
		WHERE titleauthor.au_id IS NOT NULL) AS royalties
	GROUP BY au_id, title_id) AS royalties_agg
ORDER BY total_earnings DESC;






