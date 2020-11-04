SELECT DISTINCT au.au_id, sa.title_id, ti.price * sa.qty * ti.royalty / 100 * ti_au.royaltyper / 100 AS "sales_royalty"
FROM publications.authors AS au
LEFT JOIN publications.titleauthor AS ti_au ON au.au_id=ti_au.au_id
LEFT JOIN publications.titles AS ti ON ti_au.title_id=ti.title_id
LEFT JOIN publications.sales AS sa ON ti.title_id = sa.title_id
GROUP BY au.au_id;

SELECT DISTINCT sub_q.au_id, sub_q.title_id, SUM(sub_q.sales_royalty)
FROM (
SELECT DISTINCT au.au_id, sa.title_id, ti.price * sa.qty * ti.royalty / 100 * ti_au.royaltyper / 100 AS "sales_royalty"
FROM publications.authors AS au
LEFT JOIN publications.titleauthor AS ti_au ON au.au_id=ti_au.au_id
LEFT JOIN publications.titles AS ti ON ti_au.title_id=ti.title_id
LEFT JOIN publications.sales AS sa ON ti.title_id = sa.title_id
GROUP BY au.au_id,sa.title_id) as sub_q
GROUP BY sub_q.au_id;

SELECT sub_q_2.au_id, SUM(sub_q_2.sales_royalty_per_author) 
FROM(
SELECT DISTINCT sub_q.au_id, sub_q.title_id, SUM(sub_q.sales_royalty) AS "sales_royalty_per_author"
FROM (
SELECT DISTINCT au.au_id, sa.title_id, ti.price * sa.qty * ti.royalty / 100 * ti_au.royaltyper / 100 AS "sales_royalty"
FROM publications.authors AS au
LEFT JOIN publications.titleauthor AS ti_au ON au.au_id=ti_au.au_id
LEFT JOIN publications.titles AS ti ON ti_au.title_id=ti.title_id
LEFT JOIN publications.sales AS sa ON ti.title_id = sa.title_id
GROUP BY au.au_id,sa.title_id) as sub_q
GROUP BY sub_q.au_id) AS sub_q_2
GROUP BY sub_q_2.au_id
ORDER BY "sales_royalty_per_author" ASC
LIMIT 3;



