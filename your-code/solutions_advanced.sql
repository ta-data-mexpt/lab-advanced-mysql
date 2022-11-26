USE publi;

------------------------------------------
-- CHALLENGE 1 --

-- Step 1 --
SELECT title_id as TITLE_ID, au_id AS AUTHOR_ID, t.price * s.qty * (t.royalty / 100) * (ta.royaltyper /100) AS Sales_Royalty
FROM titles AS t
JOIN titleauthor AS ta USING (title_id)
JOIN sales AS s USING (title_id);

-- Step 2 --
SELECT TITLE_ID, AUTHOR_ID, SUM(Sales_Royalty) AS Sales_Royalty_Total
FROM (
SELECT title_id as TITLE_ID, au_id AS AUTHOR_ID, t.price * s.qty * (t.royalty / 100) * (ta.royaltyper /100) AS Sales_Royalty
FROM titles AS t
LEFT JOIN titleauthor AS ta USING (title_id)
LEFT JOIN sales AS s USING (title_id)
) step1
GROUP BY  AUTHOR_ID, TITLE_ID;

-- Step 3 --
SELECT AUTHOR_ID, round((Sales_Royalty_Total + Advance),2) AS PROFITS
FROM (
SELECT TITLE_ID, AUTHOR_ID, SUM(Sales_Royalty) AS Sales_Royalty_Total, Advance
	FROM (
	SELECT title_id as TITLE_ID, au_id AS AUTHOR_ID, t.price * s.qty * (t.royalty / 100) * (ta.royaltyper /100) AS Sales_Royalty, t.advance AS Advance
	FROM titles AS t
	LEFT JOIN titleauthor AS ta USING (title_id)
	LEFT JOIN sales AS s USING (title_id)
	) step1
    GROUP BY  AUTHOR_ID, TITLE_ID
) step2
GROUP BY  AUTHOR_ID, TITLE_ID
ORDER BY PROFITS DESC
LIMIT 3;


-- CHALLENGE 2 WITH TEMPORARY TABLES --
-- Step 1 --
CREATE TEMPORARY TABLE Step_1
SELECT title_id as TITLE_ID, au_id AS AUTHOR_ID, t.price * s.qty * (t.royalty / 100) * (ta.royaltyper /100) AS Sales_Royalty, t.advance AS Advance
FROM titles AS t
JOIN titleauthor AS ta USING (title_id)
JOIN sales AS s USING (title_id);

SELECT * FROM Step_1;

-- Step 2 --
CREATE TEMPORARY TABLE Step_2
SELECT TITLE_ID, AUTHOR_ID, SUM(Sales_Royalty) AS Sales_Royalty_Total,  Advance
FROM Step_1
GROUP BY  AUTHOR_ID, TITLE_ID;

SELECT * FROM Step_2;

-- Step 3 --

CREATE TEMPORARY TABLE Step_3
SELECT AUTHOR_ID, round((Sales_Royalty_Total + SUM(advance)),2) AS PROFITS
FROM Step_2
GROUP BY  AUTHOR_ID, TITLE_ID
ORDER BY PROFITS DESC
LIMIT 3;

SELECT * FROM Step_3;

-- CHALLENGE 3 ---
CREATE TABLE Most_profiting_authors
SELECT AUTHOR_ID, round((Sales_Royalty_Total + SUM(advance)),2) AS PROFITS
FROM Step_2
GROUP BY  AUTHOR_ID, TITLE_ID
ORDER BY PROFITS DESC;

SELECT * FROM Most_profiting_authors;

