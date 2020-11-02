#CHALLENGE1
#STEP 1 
CREATE TEMPORARY TABLE publications.royalty
SELECT tit.title_id AS "TITLE_ID",
aut.au_id AS "AUTHOR_ID",
(tit.price * sal.qty * (tit.royalty/100) * (titaut.royaltyper/100)) AS "ROYALTY"

FROM publications.authors as aut
LEFT JOIN publications.titleauthor AS titaut ON aut.au_id = titaut.au_id
LEFT JOIN publications.titles AS tit ON titaut.title_id = tit.title_id
LEFT JOIN publications.sales AS sal ON tit.title_id = sal.title_id 

GROUP BY TITLE_ID, 
AUTHOR_ID, 
ROYALTY

ORDER BY tit.title_id
;


#STEP 2
CREATE TEMPORARY TABLE publications.agregated_royalties
SELECT ro.title_id, AS "TITLE_ID",
ro.au_id AS "AUTHOR_ID", 
SUM(ro.royalty) AS "Agregated_royalties"

FROM publications.royalty AS ro

GROUP BY ro.title_id
;

#STEP 3
SELECT ag.au_id AS "AUTHOR_ID",
tit.advance AS "ADVANCE",
ag.Agregated_royalties AS "TOTAL_ROYALTY"
ADVANCE + TOTAL_ROYALTY AS "PROFIT"

FROM publications.agregated_royalties AS ag
INNER JOIN publications.titles AS tit ON ag.title_id ON tit.title_id

GROUP BY AUTHOR_ID

ORDER BY PROFIT DESC 

LIMIT 3
;


#CHALLENGE2
SELECT subquery.au_id AS "AUTHOR_ID",
subquery.title_id AS "TITLE_ID",
SUM(subquery.royalty) AS "AGREGATED_ROYALTY",

FROM(
SELECT tit.title_id AS "TITLE_ID", 
au.au_id AS "AUTHOR_ID", 
(tit.price * sal.qty * (tit.royalty/100) * (titaut.royaltyper/100)) AS "ROYALTY") 

FROM publications.authors as aut
LEFT JOIN publications.titleauthor AS titaut ON aut.au_id = titaut.au_id
LEFT JOIN publications.titles AS tit ON titaut.title_id = tit.title_id
LEFT JOIN publications.sales AS sal ON tit.title_id = sal.title_id 

GROUP BY TITLE_ID, 
AUTHOR_ID, 
ROYALTY

ORDER BY 
tit.title_id) AS subquery

GROUP BY 
AGREGATED_ROYALTY DESC 
; 

#CHALLENGE 3
CREATE TABLE publications.most_profiting_authors
SELECT ag.au_id AS "AUTHOR_ID",
SUM(ag.agregated_royalties) AS 'TOTAL_PROFIT'

FROM publications.agregated_royalties AS ag

GROUP BY AUTHOR_ID

ORDER BY TOTAL_PROFIT DESC

LIMIT 3
;
