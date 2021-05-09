-- Challenge 1 -- 

SELECT (Sales_Royalty + INCOME_ADVANCE) as PROFIT
FROM 
	(SELECT a.au_id as AUTHOR_ID, t.title_id, SUM((ti.price * s.qty * ti.royalty / 100) * (t.royaltyper / 100)) as Sales_Royalty, ti.title, ti.advance as INCOME_ADVANCE
	FROM authors a
	INNER JOIN titleauthor t
	ON a.au_id = t.au_id
	INNER JOIN titles ti
	ON t.title_id = ti.title_id
	INNER JOIN sales s
	ON ti.title_id = s.title_id
	GROUP BY title, a.au_id
 ) income 
 ORDER BY PROFIT DESC;

/* Royalty for authors 
SELECT a.au_id, t.title_id, SUM((ti.price * s.qty * ti.royalty / 100) * (t.royaltyper / 100)) as Sales_Royalty, ti.title
FROM authors a
INNER JOIN titleauthor t
ON a.au_id = t.au_id
INNER JOIN titles ti
ON t.title_id = ti.title_id
INNER JOIN sales s
ON ti.title_id = s.title_id
GROUP BY title, au_id;

-- Advance income for authors --

SELECT a.au_id, ti.title, ti.advance as INCOME_ADVANCE
FROM authors a
INNER JOIN titleauthor t
ON a.au_id = t.au_id
INNER JOIN titles ti
ON t.title_id = ti.title_id
GROUP BY title, au_id; */

-- Challenge 2 [Alternative Solution] -- 

SELECT Royalty_for_authors.Sales_Royalty + Advance_income_for_authors.INCOME_ADVANCE as Total_Income
FROM Royalty_for_authors, Advance_income_for_authors
ORDER BY Total_Income DESC;

CREATE TEMPORARY TABLE Royalty_for_authors
SELECT a.au_id, t.title_id, SUM((ti.price * s.qty * ti.royalty / 100) * (t.royaltyper / 100)) as Sales_Royalty, ti.title
FROM authors a
INNER JOIN titleauthor t
ON a.au_id = t.au_id
INNER JOIN titles ti
ON t.title_id = ti.title_id
INNER JOIN sales s
ON ti.title_id = s.title_id
GROUP BY title, au_id;

CREATE TEMPORARY TABLE Advance_income_for_authors
SELECT a.au_id, ti.title, ti.advance as INCOME_ADVANCE
FROM authors a
INNER JOIN titleauthor t
ON a.au_id = t.au_id
INNER JOIN titles ti
ON t.title_id = ti.title_id
GROUP BY title, au_id;


-- Challenge 3 -- 

CREATE TABLE most_profiting_authors
SELECT (Sales_Royalty + INCOME_ADVANCE) as PROFIT
FROM 
	(SELECT a.au_id as AUTHOR_ID, t.title_id, SUM((ti.price * s.qty * ti.royalty / 100) * (t.royaltyper / 100)) as Sales_Royalty, ti.title, ti.advance as INCOME_ADVANCE
	FROM authors a
	INNER JOIN titleauthor t
	ON a.au_id = t.au_id
	INNER JOIN titles ti
	ON t.title_id = ti.title_id
	INNER JOIN sales s
	ON ti.title_id = s.title_id
	GROUP BY title, a.au_id
 ) income 
 ORDER BY PROFIT DESC;

-- Royalty for authors -- 
/* SELECT a.au_id, t.title_id, SUM((ti.price * s.qty * ti.royalty / 100) * (t.royaltyper / 100)) as Sales_Royalty, ti.title
FROM authors a
INNER JOIN titleauthor t
ON a.au_id = t.au_id
INNER JOIN titles ti
ON t.title_id = ti.title_id
INNER JOIN sales s
ON ti.title_id = s.title_id
GROUP BY title, au_id;

-- Advance income for authors --

SELECT a.au_id, ti.title, ti.advance as INCOME_ADVANCE
FROM authors a
INNER JOIN titleauthor t
ON a.au_id = t.au_id
INNER JOIN titles ti
ON t.title_id = ti.title_id
GROUP BY title, au_id; /* 