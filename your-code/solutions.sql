#lab-advanced-mysql
# Challenge 1
## Step 1

CREATE TEMPORARY TABLE publications.royalties2
SELECT  titles.title_id, titleauthor.au_id,
titles.price, sales.qty, titles.royalty, titleauthor.royaltyper,
titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100 
AS "sales_royalty"
from titles
left join titleauthor
on titles.title_id = titleauthor.title_id
left join sales
on titles.title_id = sales.title_id;

## Step 2
SELECT title_id,au_id,sum(sales_royalty) AS "agg_tit_au_royalties"
FROM royalties2
Group BY au_id, title_id;

## Step 3
SELECT au_id,sum(sales_royalty) AS "agg_au_royalties"
FROM royalties2
Group BY au_id
ORDER by agg_au_royalties DESC;



#CHALLENGE 3 
CREATE TABLE most_profiting_authors
(SELECT au_id,sum(sales_royalty) AS "agg_au_royalties"
FROM royalties
Group BY au_id
ORDER by agg_au_royalties DESC);
