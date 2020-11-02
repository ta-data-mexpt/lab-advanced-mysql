USE publications;
#Challenge 1: Most Profiting Authors, Step 1
CREATE TEMPORARY TABLE Royalty_advance
select ti.title_id, au.au_id, ti.advance, ta.royaltyper, ti.price * sa.qty * ti.royalty / 100 * ta.royaltyper / 100 sales_royalty
from authors AU
left join titleauthor TA
on AU.au_id =  TA.au_id
left join titles TI
on ta.title_id = TI.title_id
left join sales SA
on TI.title_id=sa.title_id;

#Challenge 1: Most Profiting Authors, Step 2
CREATE TABLE summary
select title_id,au_id,advance, royaltyper,sum(sales_royalty) royalty
from royalty_advance
group by title_id,au_id;


#Challenge 1: Most Profiting Authors, Step 3
select au_id, royalty + advance*royaltyper/100 PROFIT
from summary
order by PROFIT DESC
LIMIT 3;

#Challenge 2: Alternative Solution
select RO_AD.au_id, sum(RO_AD.sales_royalty) + RO_AD.advance* RO_AD.royaltyper / 100 PROFIT
from (select ti.title_id, au.au_id, ti.advance, ta.royaltyper, ti.price * sa.qty * ti.royalty / 100 * ta.royaltyper / 100 sales_royalty
from authors AU
left join titleauthor TA
on AU.au_id =  TA.au_id
left join titles TI
on ta.title_id = TI.title_id
left join sales SA
on TI.title_id=sa.title_id) RO_AD
group by RO_AD.title_id, RO_AD.au_id
order by PROFIT DESC
LIMIT 3;

#Challenge 3
CREATE TABLE most_profiting_authors
select RO_AD.au_id, sum(RO_AD.sales_royalty) + RO_AD.advance* RO_AD.royaltyper / 100 PROFIT
from (select ti.title_id, au.au_id, ti.advance, ta.royaltyper, ti.price * sa.qty * ti.royalty / 100 * ta.royaltyper / 100 sales_royalty
from authors AU
left join titleauthor TA
on AU.au_id =  TA.au_id
left join titles TI
on ta.title_id = TI.title_id
left join sales SA
on TI.title_id=sa.title_id) RO_AD
group by RO_AD.title_id, RO_AD.au_id
order by PROFIT DESC
LIMIT 3;

SELECT * FROM MOST_PROFITING_AUTHORS;