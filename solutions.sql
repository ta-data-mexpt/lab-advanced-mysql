CREATE TEMPORARY TABLE lab01.royalty_by_sale_author
select
t.title_id as TITLE_ID
, t.au_id as AUTHOR_ID
, s.qty * t2.royalty /100 * t2.price * t.royaltyper / 100 as SALES_ROYALTY
from sales s 
join titleauthor t 
on t.title_id = s.title_id
join titles t2 
on t.title_id = t2.title_id

CREATE TEMPORARY TABLE lab01.royalties_by_title_author
select 
TITLE_ID
, AUTHOR_ID
, sum(SALES_ROYALTY) as ROYALTIES
from lab01.royalty_by_sale_author
group by 
TITLE_ID
, AUTHOR_ID

SELECT 
a.AUTHOR_ID
, sum(a.ROYALTIES) + sum(t2.advance * t.royaltyper/100) as PROFIT
from lab01.royalties_by_title_author a
join titleauthor t 
on a.AUTHOR_ID = t.au_id 
and a.TITLE_ID = t.title_id 
join titles t2 
on a.TITLE_ID = t2.title_id 
group BY 
a.AUTHOR_ID
order by PROFIT desc

# Alternative Solution
select
a.au_id as AUTHOR_ID
, sum((tit.price * tit.royalty/100 * s.qty + tit.advance) * t.royaltyper/100) as PROFIT
from
authors a
left join titleauthor t 
on a.au_id = t.au_id 
left join titles tit	
on tit.title_id = t.title_id 
left join (
select
title_id 
, sum(qty) as qty
from sales 
group by title_id
) s 
on s.title_id  = tit.title_id 
group BY
a.au_id
order by PROFIT desc;

#Create table

CREATE TABLE most_profiting_authors
	select
	a.au_id 
	, sum((tit.price * tit.royalty/100 * s.qty + tit.advance) * t.royaltyper/100) as profits
	from
	authors a
	left join titleauthor t 
	on a.au_id = t.au_id 
	left join titles tit	
	on tit.title_id = t.title_id 
	left join (
	select
	title_id 
	, sum(qty) as qty
	from sales 
	group by title_id
	) s 
	on s.title_id  = tit.title_id 
	group BY
	a.au_id
	order by profits desc;