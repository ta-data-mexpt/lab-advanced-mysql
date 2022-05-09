-- Challenge 1

-- Step 1

select 
ta.title_id, 
ta.au_id, 
(t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100) as sales_royalty, 
(ta.royaltyper/100)*t.advance as advance_profit
from authors as a
left join titleauthor as ta
on a.au_id = ta.au_id
left join titles as t
on ta.title_id = t.title_id
left join sales as s
on s.title_id = ta.title_id;

-- Step 2

CREATE TEMPORARY TABLE step2
SELECT 
au_id, 
SUM(sales_royalty) AS royalty_profit, 
advance_profit
FROM 
(SELECT 
ta.title_id, 
ta.au_id, (t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100) AS sales_royalty, 
(ta.royaltyper/100)*t.advance AS advance_profit
FROM authors AS a
LEFT JOIN titleauthor as ta
ON a.au_id = ta.au_id
LEFT JOIN titles as t
ON ta.title_id = t.title_id
LEFT JOIN sales as s
ON s.title_id = ta.title_id) royalty_bd
GROUP BY au_id, title_id;

-- Step 3

SELECT  
au_id, 
royalty_profit + advance_profit AS profit
FROM step2
GROUP BY au_id
ORDER BY profit DESC
LIMIT 3;


