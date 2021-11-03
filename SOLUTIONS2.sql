select *
from publications.titles
LIMIT 2; 


## answer 1

##step 1

CREATE TEMPORARY TABLE tabla1
select t.title_id, t.au_id,(p.price * s.qty * (p.royalty/100) * (t.royaltyper /100)) as royalty1
from publications.titleauthor as t
join publications.sales as s
on t.title_id = s.title_id
join publications.titles as p
on t.title_id = p.title_id
order by t.au_id;

##step 2

CREATE TEMPORARY TABLE tabla2
select title_id, au_id, SUM(royalty1) as Royalty2
from tabla1
group by title_id, au_id;

##step 3

CREATE TEMPORARY TABLE tabla3
select x.au_id, (SUM(x.Royalty2) + SUM(p.advance)) as PROFIT
from tabla2 as x
left join publications.titles as p
on x.title_id = p.title_id
group by x.au_id
order by (SUM(x.Royalty2) + SUM(p.advance)) DESC
LIMIT 3;


## challenge 3

CREATE TABLE most_profiting_authors
select au_id, PROFIT
from tabla3

select *
from most_profiting_authors

