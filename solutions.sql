USE publications;

-- STEP 1
SELECT titles.title_id as TITLE_ID, authors.au_id as AUTHOR_ID, (titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) as ROYALTY
FROM titleauthor
LEFT JOIN authors
USING (au_id)
LEFT JOIN titles
USING (title_id)
LEFT JOIN sales
USING (title_id);

-- STEP 2
SELECT TITLE_ID, AUTHOR_ID, sum(ROYALTY) AS TOTAL_ROYALTY
FROM (SELECT titles.title_id as TITLE_ID, authors.au_id as AUTHOR_ID, (titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) as ROYALTY
FROM titleauthor
LEFT JOIN authors
USING (au_id)
LEFT JOIN titles
USING (title_id)
LEFT JOIN sales
USING (title_id)) as tabla_1
GROUP BY AUTHOR_ID,TITLE_ID
ORDER BY TITLE_ID,AUTHOR_ID;

-- STEP 3
SELECT AUTHOR_ID, sum(TOTAL_ROYALTY) AS TOTAL_AUTHOR
FROM (select TITLE_ID, AUTHOR_ID, sum(ROYALTY) as TOTAL_ROYALTY
FROM (select titles.title_id as TITLE_ID, authors.au_id as AUTHOR_ID, (titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) as ROYALTY
FROM titleauthor
LEFT JOIN authors
USING (au_id)
LEFT JOIN titles
USING (title_id)
LEFT JOIN sales
USING (title_id)) as tabla_1
GROUP BY AUTHOR_ID,TITLE_ID) as tabla_2
GROUP BY AUTHOR_ID
ORDER BY TOTAL_AUTHOR DESC
LIMIT 3;

-- Challenge 2
-- STEP 1
CREATE TEMPORARY TABLE CH1
SELECT titles.title_id as TITLE_ID, authors.au_id as AUTHOR_ID, (titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) as ROYALTY
FROM titleauthor
LEFT JOIN authors
USING (au_id)
LEFT JOIN titles
USING (title_id)
LEFT JOIN sales
USING (title_id);

-- STEP 2
CREATE TEMPORARY TABLE CH2
SELECT TITLE_ID, AUTHOR_ID, sum(ROYALTY) AS TOTAL_ROYALTY
FROM CH1
GROUP BY AUTHOR_ID,TITLE_ID;

-- STEP 3
SELECT AUTHOR_ID, sum(TOTAL_ROYALTY) AS TOTAL_AUTHOR
FROM CH2
GROUP BY AUTHOR_ID
ORDER BY TOTAL_AUTHOR DESC
LIMIT 3;

-- Challenge 3 
CREATE TABLE AUTHOR_PROFIT
SELECT AUTHOR_ID, sum(TOTAL_ROYALTY) AS PROFIT
FROM CH2
GROUP BY AUTHOR_ID
ORDER BY PROFIT DESC;

















