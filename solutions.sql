USE publications;

CREATE TEMPORARY TABLE step1
SELECT	titleauthor.title_id AS TitleID,
		titleauthor.au_id AS AuthorID,
        titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100 AS Royalty
FROM titleauthor
INNER JOIN titles
ON titleauthor.title_id = titles.title_id
INNER JOIN sales
ON titles.title_id = sales.title_id;

-- SELECT * FROM step1;

CREATE TEMPORARY TABLE step2
SELECT	TitleID,
		AuthorID,
        SUM(Royalty) AS AGG
FROM step1
GROUP BY AuthorID, TitleID;

-- SELECT * FROM step2;

CREATE TEMPORARY TABLE step3
SELECT AuthorID, SUM(AGG) AS TotalRoyalty
FROM step2
GROUP BY AuthorID;

SELECT * FROM step3
ORDER BY TotalRoyalty DESC
LIMIT 3;

CREATE TABLE most_profiting_authors
SELECT * FROM step3
ORDER BY TotalRoyalty DESC
LIMIT 3;