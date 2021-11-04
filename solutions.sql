-- Challenge 1
SELECT ta.title_id, ta.au_id, (t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100) AS sales_royalty, (ta.royaltyper/100)*t.advance AS advance_profit
FROM authors AS a
INNER JOIN titleauthor as ta
ON a.au_id = ta.au_id
LEFT JOIN titles as t
ON ta.title_id = t.title_id
LEFT JOIN sales as s
ON s.title_id = ta.title_id;

CREATE TEMPORARY TABLE royalty_advance_title_authors
SELECT title_id, au_id, SUM(sales_royalty) AS royalty_profit, advance_profit
FROM (
SELECT ta.title_id, ta.au_id, (t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100) AS sales_royalty, (ta.royaltyper/100)*t.advance AS advance_profit
FROM authors AS a
INNER JOIN titleauthor as ta
ON a.au_id = ta.au_id
LEFT JOIN titles as t
ON ta.title_id = t.title_id
LEFT JOIN sales as s
ON s.title_id = ta.title_id
) royalty_bd
GROUP BY au_id, title_id;


SELECT  title_id, au_id, royalty_profit+advance_profit AS profit  -- Challenge 1 answer
FROM royalty_advance_title_authors AS rta
GROUP BY au_id
ORDER BY profit DESC
LIMIT 3;

-- Challenge 2



