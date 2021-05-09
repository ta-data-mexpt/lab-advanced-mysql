SELECT a.au_id, t.title_id, (ti.price * s.qty * ti.royalty / 100 * t.royaltyper / 100) as Royalty
FROM authors a
INNER JOIN titleauthor t
ON a.au_id = t.au_id
INNER JOIN titles ti
ON t.title_id = ti.title_id
INNER JOIN sales s
ON ti.title_id = s.title_id;