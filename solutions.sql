-- Challenge 1 -- 

SELECT (Sales_Royalty + INCOME_ADVANCE) as Profits
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
 ) income;

-- Royalty for authors  -- 
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
GROUP BY title, au_id;