# Challenge 1
# Step 1 Calculate the royalties of each sales for each author
SELECT t.title_id AS 'Title_ID', ta.au_id AS 'Author_ID', (t.price*s.qty*t.royalty/100*ta.royaltyper/100) AS 'Royalties'
FROM titles t
INNER JOIN sales s ON t.title_id = s.title_id
INNER JOIN titleauthor ta ON t.title_id = ta.title_id;

#Step 2 Aggregate the total royalties for each title for each author
SELECT Title_ID, Author_ID, SUM(Royalties) AS 'Agg_Royalties'
FROM (SELECT t.title_id AS 'Title_ID', ta.au_id AS 'Author_ID', (t.price*s.qty*t.royalty/100*ta.royaltyper/100) AS 'Royalties'
FROM titles t
INNER JOIN sales s ON t.title_id = s.title_id
INNER JOIN titleauthor ta ON t.title_id = ta.title_id)
GROUP BY Title_ID, Author_ID;

# Step 3 Calculate the total profits of each author
SELECT Author_ID, (Agg_Royalties + Advance) AS 'Profits'
FROM (SELECT Title_ID, Author_ID, SUM(Royalties) AS 'Agg_Royalties'
FROM (SELECT t.title_id AS 'Title_ID', ta.au_id AS 'Author_ID', (t.price*s.qty*t.royalty/100*ta.royaltyper/100) AS 'Royalties'
FROM titles t
INNER JOIN sales s ON t.title_id = s.title_id
INNER JOIN titleauthor ta ON t.title_id = ta.title_id)
GROUP BY Title_ID, Author_ID)
GROUP BY Author_ID, Profits
ORDER BY Profits DESC
LIMIT 3;

# Challenge 2

CREATE TEMPORARY TABLE STEP_1_1
SELECT t.title_id AS 'Title_ID', ta.au_id AS 'Author_ID', (t.price*s.qty*t.royalty/100*ta.royaltyper/100) AS 'Royalties', t.advance AS 'Advance'
FROM titles t
INNER JOIN sales s ON t.title_id = s.title_id
INNER JOIN titleauthor ta ON t.title_id = ta.title_id;

SELECT * FROM STEP_1_1

CREATE TEMPORARY TABLE STEP_2_2
SELECT Title_ID, Author_ID, SUM(Royalties) AS 'Agg_Royalties', Advance
FROM STEP_1_1
GROUP BY Title_ID, Author_ID;

SELECT * FROM STEP_2_2;

CREATE TEMPORARY TABLE STEP_3_3
SELECT Author_ID, (Agg_Royalties + Advance) AS 'Profits'
FROM STEP_2_2
GROUP BY Author_ID, Profits
ORDER BY Profits DESC
LIMIT 3;

SELECT * FROM STEP_3_3;

# Challenge 3

DROP TABLE IF EXISTS most_profiting_authors;

CREATE TABLE most_profiting_authors
SELECT Author_ID, round((Agg_Royalties + Advance),2) AS 'Profits'
FROM STEP_2_2
GROUP BY Author_ID, Profits
ORDER BY Profits DESC;

SELECT * FROM most_profiting_authors;