SELECT au.au_id as Author_ID,
ti.title_id as Title_ID,
tis.price * sa.qty * (tis.royalty / 100) * (ti.royaltyper / 100) as Sales_Royalty
FROM `b'publications'`.authors au
LEFT JOIN `b'publications'`.titleauthor ti
ON au.au_id = ti.au_id
LEFT JOIN `b'publications'`.titles tis
ON tis.title_id = ti.title_id
LEFT JOIN `b'publications'`.sales sa
ON sa.title_id = tis.title_id;

SELECT Author_ID,
Title_ID,
SUM(Sales_Royalty) as Total_Sales_Royalty
FROM 
(SELECT au.au_id as Author_ID,
ti.title_id as Title_ID,
tis.price * sa.qty * (tis.royalty / 100) * (ti.royaltyper / 100) as Sales_Royalty
FROM `b'publications'`.authors au
LEFT JOIN `b'publications'`.titleauthor ti
ON au.au_id = ti.au_id
LEFT JOIN `b'publications'`.titles tis
ON tis.title_id = ti.title_id
LEFT JOIN `b'publications'`.sales sa
ON sa.title_id = tis.title_id) TAB
GROUP BY Author_ID, Title_ID; # suma de las regalias

SELECT Author_ID,
SUM(Total_Sales_Royalty) as Profit
FROM
(SELECT Author_ID,
Title_ID,
SUM(Sales_Royalty) as Total_Sales_Royalty
FROM 
(SELECT au.au_id as Author_ID,
ti.title_id as Title_ID,
tis.price * sa.qty * (tis.royalty / 100) * (ti.royaltyper / 100) as Sales_Royalty
FROM `b'publications'`.authors au
LEFT JOIN `b'publications'`.titleauthor ti
ON au.au_id = ti.au_id
LEFT JOIN `b'publications'`.titles tis
ON tis.title_id = ti.title_id
LEFT JOIN `b'publications'`.sales sa
ON sa.title_id = tis.title_id) TAB
GROUP BY Author_ID, Title_ID) SEGUNDA_TAB
GROUP BY Author_ID
ORDER BY Profit DESC; # autor con mayores ganancias totales

CREATE TABLE `b'publications'`.most_profitable_author
SELECT Author_ID as au_id,
SUM(Total_Sales_Royalty) as profit
FROM
(SELECT Author_ID,
Title_ID,
SUM(Sales_Royalty) as Total_Sales_Royalty
FROM 
(SELECT au.au_id as Author_ID,
ti.title_id as Title_ID,
tis.price * sa.qty * (tis.royalty / 100) * (ti.royaltyper / 100) as Sales_Royalty
FROM `b'publications'`.authors au
LEFT JOIN `b'publications'`.titleauthor ti
ON au.au_id = ti.au_id
LEFT JOIN `b'publications'`.titles tis
ON tis.title_id = ti.title_id
LEFT JOIN `b'publications'`.sales sa
ON sa.title_id = tis.title_id) TAB
GROUP BY Author_ID, Title_ID) SEGUNDA_TAB
GROUP BY Author_ID
ORDER BY Profit DESC; # creacion de tabla a partir de los resultados del ultimo subquery