-- Challenge 1 - Most Profiting Authors
-- Step 1: Calculate the royalties of each sales for each author
SELECT titles.title_id as 'Title', authors.au_id as 'Author Id', (titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) as 'Sales Royalties'
FROM authors
LEFT JOIN titleauthor on authors.au_id = titleauthor.au_id
JOIN titles on titleauthor.title_id = titles.title_id
JOIN publishers on titles.pub_id = publishers.pub_id
JOIN roysched on roysched.title_id = titles.title_id
JOIN sales on sales.title_id = titles.title_id;


SELECT consulta2.Author, sum(consulta2.Sales_Royalties) as sum_sales_royaltes
FROM(
	SELECT consulta1.Title as 'Title', consulta1.Author_id as 'Author', sum(consulta1.Sales_Royalties) as 'Sales_royalties'
        FROM(
            SELECT titles.title_id as 'Title', authors.au_id as 'Author_id', (titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) as 'Sales_Royalties'
            FROM authors
            LEFT JOIN titleauthor on authors.au_id = titleauthor.au_id
            JOIN titles on titleauthor.title_id = titles.title_id
            JOIN publishers on titles.pub_id = publishers.pub_id
            JOIN roysched on roysched.title_id = titles.title_id
            JOIN sales on sales.title_id = titles.title_id
        ) AS consulta1
        GROUP BY consulta1.Title, consulta1.Author_id
) AS consulta2
GROUP BY consulta2.Author
ORDER BY sum_sales_royaltes DESC LIMIT 3;



-- Challenge 2 - Alternative Solution
-- Con tablas temporales

CREATE TEMPORARY TABLE SalesRoyalties
SELECT titles.title_id as 'Title', authors.au_id as 'Author_id', (titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) as 'Sales_royalties'
FROM authors
LEFT JOIN titleauthor on authors.au_id = titleauthor.au_id
JOIN titles on titleauthor.title_id = titles.title_id
JOIN publishers on publishers.pub_id = titles.pub_id
JOIN roysched on roysched.title_id = titles.title_id
JOIN sales on sales.title_id = titles.title_id;

SELECT * FROM SalesRoyalties;

SELECT consulta1.Author_id, sum(consulta1.Sales_royalties) as Sales_royalties
FROM(
	SELECT SalesRoyalties.Title, SalesRoyalties.Author_id, sum(SalesRoyalties.Sales_royalties) as 'Sales_royalties'
	FROM SalesRoyalties
	GROUP BY SalesRoyalties.Title, SalesRoyalties.Author_id
) AS consulta1 
GROUP BY consulta1.Author_id
ORDER BY Sales_royalties DESC LIMIT 3;


-- Challenge 3

CREATE TABLE most_profiting_authors
SELECT consulta1.Author_id, sum(consulta1.Sales_royalties) as Sales_royalties
FROM(
    SELECT SalesRoyalties.Title, SalesRoyalties.Author_id, sum(SalesRoyalties.Sales_Royalties) as 'Sales_royalties'
    FROM SalesRoyalties
    GROUP BY SalesRoyalties.Title, SalesRoyalties.Author_id
) AS consulta1 
GROUP BY consulta1.Author_id
ORDER BY Sales_royalties DESC LIMIT 3;

SELECT * FROM most_profiting_authors;
