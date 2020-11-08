#Paso 1

SELECT tiau.title_id 'Titulo', tiau.au_id 'AUTOR',
(ti.price * sa.qty * ti.royalty / 100 * tiau.royaltyper / 100) 'Venta royalty'
FROM titleauthor tiau 
INNER JOIN titles ti ON tiau.title_id = ti.title_id
INNER JOIN sales  sa ON ti.title_id = sa.title_id
ORDER BY tiau.title_id desc;

#paso 2

SELECT calculo.title_id 'Titulo', calculo.au_id 'Autor', SUM(Ve) AS 'Total royalty'
FROM (
SELECT tiau.title_id, tiau.au_id,
(ti.price * sa.qty * ti.royalty / 100 * tiau.royaltyper / 100) 'Ve'
FROM titleauthor tiau 
INNER JOIN titles ti ON tiau.title_id = ti.title_id
INNER JOIN sales  sa ON ti.title_id = sa.title_id) AS calculo
GROUP BY calculo.au_id, calculo.title_id
ORDER BY calculo.title_id desc;

#paso 3

SELECT AuthorID, ti.title_id, SUM(ti.advance*(tiau.royaltyper/100)+Royalties) AS 'ganancia'
FROM ( SELECT TitleID, AuthorID,
				SUM(Ve) AS Royalties
				FROM ( SELECT titleauthor.title_id 'TitleID', titleauthor.au_id 'AuthorID',
				(titles.price * sa.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) 'Ve'
				FROM titleauthor 
				INNER JOIN titles ON titleauthor.title_id = titles.title_id
				INNER JOIN sales  sa ON titles.title_id = sa.title_id) AS calculo
		GROUP BY calculo.TitleID, calculo.AuthorID) AS royal_au_tit
		JOIN titles ti ON royal_au_tit.TitleID = ti.title_id
JOIN titleauthor tiau ON ti.title_id = tiau.title_id AND AuthorID = tiau.au_id 
GROUP BY AuthorID, ti.title_id 
LIMIT 3;

#DESAFIO2

CREATE TEMPORARY TABLE temp_royalty_table
SELECT AuthorID, ti.title_id, SUM(ti.advance*(tiau.royaltyper/100)+Royalties) AS 'ganancia'
FROM ( SELECT TitleID, AuthorID,
				SUM(Ve) AS Royalties
				FROM ( SELECT titleauthor.title_id 'TitleID', titleauthor.au_id 'AuthorID',
				(titles.price * sa.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) 'Ve'
				FROM titleauthor 
				INNER JOIN titles ON titleauthor.title_id = titles.title_id
				INNER JOIN sales  sa ON titles.title_id = sa.title_id) AS calculo
		GROUP BY calculo.TitleID, calculo.AuthorID) AS royal_au_tit
		JOIN titles ti ON royal_au_tit.TitleID = ti.title_id
JOIN titleauthor tiau ON ti.title_id = tiau.title_id AND AuthorID = tiau.au_id 
GROUP BY AuthorID, ti.title_id;

SELECT *
FROM temp_royalty_table

CREATE	TEMPORARY TABLE tabla2
SELECT AuthorID, title_id, SUM(ganancia) 'ganancia_total'
FROM temp_royalty_table
GROUP BY AuthorID
LIMIT 3;






SELECT *
FROM titles
