USE publications;

/*Step 1: Calculate the royalties of each sales for each author*/

CREATE TEMPORARY TABLE publications.sales_royalty
SELECT ti.title_id,  titleauthor.au_id, ti.price*sa.qty*ti.royalty/100*titleauthor.royaltyper/100 AS sales_royalty
FROM publications.titles ti
INNER JOIN publications.titleauthor 
ON ti.title_id =titleauthor.title_id
LEFT JOIN publications.sales sa
ON ti.title_id=sa.title_id;
/*Step 2: Aggregate the total royalties for each title for each author*/
CREATE TEMPORARY TABLE publications.sales_royalty_sum
SELECT sales_royalty.title_id, sales_royalty.au_id,SUM(sales_royalty) AS tot_sales_royalty
FROM publications.sales_royalty
GROUP BY sales_royalty.title_id,sales_royalty.au_id;

/*Step 3: Calculate the total profits of each author*/
/*Not sure if correct*/
SELECT sales_royalty_sum.au_id, tot_sales_royalty+ti.advance*titleauthor.royaltyper/100 AS profit
FROM publications.sales_royalty_sum
LEFT JOIN publications.titles ti
ON ti.title_id=sales_royalty_sum.title_id
LEFT JOIN publications.titleauthor
ON ti.title_id =titleauthor.title_id
ORDER BY profit DESC
LIMIT 3;

/*Challenge 2 - Alternative Solution*/
/*Not sure if correct*/

SELECT sales_royalty_sum.au_id, tot_sales_royalty+ti.advance*titleauthor.royaltyper/100 AS profit
FROM (SELECT sales_royalty_data.title_id, sales_royalty_data.au_id,SUM(sales_royalty) AS tot_sales_royalty
	  FROM (SELECT ti.title_id,  titleauthor.au_id, ti.price*sa.qty*ti.royalty/100*titleauthor.royaltyper/100 AS sales_royalty
			FROM publications.titles ti
			INNER JOIN publications.titleauthor 
			ON ti.title_id =titleauthor.title_id
			LEFT JOIN publications.sales sa
			ON ti.title_id=sa.title_id
			) AS sales_royalty_data
		GROUP BY sales_royalty_data.title_id,sales_royalty_data.au_id
		) AS sales_royalty_sum
LEFT JOIN publications.titles ti
ON ti.title_id=sales_royalty_sum.title_id
LEFT JOIN publications.titleauthor
ON ti.title_id =titleauthor.title_id
ORDER BY profit DESC
LIMIT 3;

/* Challenge 3*/
/*NOT SURE IF CORRECT*/
CREATE TABLE publications.most_profiting_authors
SELECT sales_royalty_sum.au_id, tot_sales_royalty+ti.advance*titleauthor.royaltyper/100 AS profit
FROM publications.sales_royalty_sum
LEFT JOIN publications.titles ti
ON ti.title_id=sales_royalty_sum.title_id
LEFT JOIN publications.titleauthor
ON ti.title_id =titleauthor.title_id
ORDER BY profit DESC
LIMIT 3;



