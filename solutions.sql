USE publications;
#Challenge 1
select titleauthor.title_id, authors.au_id, titles.price*sales.qty*(titles.royalty/100)*(titleauthor.royaltyper/100) AS Royalty 
FROM publications.authors
LEFT JOIN publications.titleauthor
ON authors.au_id=titleauthor.au_id
LEFT JOIN publications.sales
ON titleauthor.title_id=sales.title_id
LEFT JOIN publications.titles
ON titleauthor.title_id=titles.title_id;
CREATE TEMPORARY TABLE temp_royalties
select titleauthor.title_id, authors.au_id, titles.price*sales.qty*(titles.royalty/100)*(titleauthor.royaltyper/100) AS Royalty 
FROM publications.authors
LEFT JOIN publications.titleauthor
ON authors.au_id=titleauthor.au_id
LEFT JOIN publications.sales
ON titleauthor.title_id=sales.title_id
LEFT JOIN publications.titles
ON titleauthor.title_id=titles.title_id;
SELECT title_id, au_id, SUM(Royalty) AS sum_royalties
FROM temp_royalties
GROUP BY temp_royalties.title_id, temp_royalties.au_id;
CREATE TEMPORARY TABLE temp_royalties2
SELECT title_id, au_id, SUM(Royalty) AS sum_royalties
FROM temp_royalties
GROUP BY temp_royalties.title_id, temp_royalties.au_id;
SELECT temp_royalties2.au_id, titles.advance*(titleauthor.royaltyper/100)+sum_royalties AS Profits
from temp_royalties2
LEFT JOIN publications.titles
ON titles.title_id=temp_royalties2.title_id
LEFT JOIN publications.titleauthor
ON titleauthor.title_id=temp_royalties2.title_id
ORDER BY Profits DESC
LIMIT 3;
#Challenge 2
SELECT summary2.au_id, titles.advance*(titleauthor.royaltyper/100)+sum_royalties AS Profits
FROM (SELECT title_id, au_id, SUM(Royalty) AS sum_royalties FROM (SELECT titles.title_id, titleauthor.au_id, titles.price*sales.qty*(titles.royalty/100)*(titleauthor.royaltyper/100) AS Royalty FROM publications.authors LEFT JOIN publications.titleauthor ON authors.au_id=titleauthor.au_id LEFT JOIN publications.sales ON titleauthor.title_id=sales.title_id LEFT JOIN publications.titles ON titleauthor.title_id=titles.title_id) as summary GROUP BY summary.title_id, summary.au_id) as summary2
LEFT JOIN publications.titles ON titles.title_id=summary2.title_id
LEFT JOIN publications.titleauthor ON titleauthor.title_id=summary2.title_id
ORDER BY Profits DESC
LIMIT 3;
#Challenge 3
CREATE TABLE most_profiting_authors
SELECT summary2.au_id, titles.advance*(titleauthor.royaltyper/100)+sum_royalties AS Profits
FROM (SELECT title_id, au_id, SUM(Royalty) AS sum_royalties FROM (SELECT titles.title_id, titleauthor.au_id, titles.price*sales.qty*(titles.royalty/100)*(titleauthor.royaltyper/100) AS Royalty FROM publications.authors LEFT JOIN publications.titleauthor ON authors.au_id=titleauthor.au_id LEFT JOIN publications.sales ON titleauthor.title_id=sales.title_id LEFT JOIN publications.titles ON titleauthor.title_id=titles.title_id) as summary GROUP BY summary.title_id, summary.au_id) as summary2
LEFT JOIN publications.titles ON titles.title_id=summary2.title_id
LEFT JOIN publications.titleauthor ON titleauthor.title_id=summary2.title_id
ORDER BY Profits DESC;