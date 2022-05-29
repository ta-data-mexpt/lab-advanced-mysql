SELECT * FROM publications.authors;

-- CHALLENGE 1 (MOST PROFITING AUTHORS)

-- STEP 1: CALCULATE ROYALTIES OF EACH SALES FOR EACH AUTHOR

SELECT titles.title_id AS TITLE_ID, authors.au_id AS AUTHOR_ID, authors.au_lname, authors.au_fname, titles.price, titles.advance, titleauthor.royaltyper, sales.qty, 
       (titles.price * sales.qty * titles.royalty/100 *titleauthor.royaltyper/100) AS ROYALTIES
FROM titles
INNER JOIN sales ON titles.title_id = sales.title_id
INNER JOIN  titleauthor ON sales.title_id = titleauthor.title_id 
INNER JOIN authors ON titleauthor.au_id = authors.au_id
ORDER BY TITLE_ID, AUTHOR_ID;

-- STEP 2: AGREGATE TOTAL ROYALTIES

SELECT title_id, au_id, au_lname, au_fname, advance, SUM(ROYALTIES) AS ROYALTIES FROM
(
    SELECT titles.title_id, authors.au_id, authors.au_lname, authors.au_fname, titles.price, titles.advance, titleauthor.royaltyper, sales.qty, 
           (titles.price * sales.qty * titles.royalty/100 *titleauthor.royaltyper/100) AS ROYALTIES
    FROM titles
    INNER JOIN sales ON titles.title_id = sales.title_id
    INNER JOIN  titleauthor ON sales.title_id = titleauthor.title_id 
    INNER JOIN authors ON titleauthor.au_id = authors.au_id
) AS summary
GROUP BY au_id, title_id
ORDER BY ROYALTIES desc;

-- STEP 3: CALCULATE TOTAL PROFITS

SELECT au_id AS AUTHOR_ID, au_lname AS LAST_NAME, au_fname AS FIRST_NAME, SUM(advance + ROYALTIES) AS PROFITS FROM
(
    SELECT title_id, au_id, au_lname, au_fname, advance, SUM(ROYALTIES) AS ROYALTIES FROM 
    (
        SELECT titles.title_id, authors.au_id, authors.au_lname, authors.au_fname, titles.price, titles.advance, titleauthor.royaltyper, sales.qty, 
               (titles.price * sales.qty * titles.royalty/100 *titleauthor.royaltyper/100) AS ROYALTIES
        FROM titles
        INNER JOIN sales ON titles.title_id = sales.title_id
        INNER JOIN  titleauthor ON sales.title_id = titleauthor.title_id 
        INNER JOIN authors ON titleauthor.au_id = authors.au_id
    ) AS summary1
    GROUP BY au_id, title_id
) AS summary2
GROUP BY au_id
ORDER BY PROFITS desc
LIMIT 3;


-- CHALLENGE 2 (ALTERNATIVE SOLUTIONS - TEMPORARY TABLES)

CREATE TEMPORARY TABLE temporary1
SELECT titles.title_id, authors.au_id, (titles.price * sales.qty * titles.royalty/100 *titleauthor.royaltyper/100) AS SAL_ROY
FROM titles
INNER JOIN sales ON titles.title_id = sales.title_id
INNER JOIN  titleauthor ON sales.title_id = titleauthor.title_id 
INNER JOIN authors ON titleauthor.au_id = authors.au_id
ORDER BY title_id, au_id;

CREATE TEMPORARY TABLE temporary2
SELECT title_id, au_id, SUM(SAL_ROY) AS ROYALTIES
FROM temporary1
GROUP BY title_id, au_id;


SELECT temporary2.au_id AS AUTHOR_ID, au_lname AS LAST_NAME, au_fname AS FIRST_NAME, SUM(advance + ROYALTIES) AS PROFITS
FROM temporary2
INNER JOIN titles ON titles.title_id = temporary2.title_id
INNER JOIN authors ON authors.au_id = temporary2.au_id
GROUP BY temporary2.au_id
ORDER BY profits DESC
LIMIT 3;

-- CHALLENGE 3 (MOST PROFITING AUTHORS)


CREATE TABLE most_profiting_authors1
SELECT au_id, SUM(SAL_ROY) AS PROFITS FROM temporary3
GROUP BY au_id
ORDER BY PROFITS desc
LIMIT 3;

select * from most_profiting_authors











