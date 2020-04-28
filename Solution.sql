SELECT tt.advance, tt.title_id ,au.au_id,sum(tt.price * sa.qty * tt.royalty / 100 * tau.royaltyper / 100) as sales_royalty
from authors au
inner join titleauthor tau on tau.au_id = au.au_id
inner join titles tt on tt.title_id = tau.title_id
inner join sales sa on sa.title_id = tt.title_id
group by tt.title , au.au_id;

SELECT a.title_id,a.au_id,(sales_royalty+a.advance) as profit  FROM (
SELECT tt.advance, tt.title_id ,au.au_id,sum(tt.price * sa.qty * tt.royalty / 100 * tau.royaltyper / 100) as sales_royalty
from authors au
inner join titleauthor tau on tau.au_id = au.au_id
inner join titles tt on tt.title_id = tau.title_id
inner join sales sa on sa.title_id = tt.title_id
group by tt.title , au.au_id
)
as a 
order by profit desc
limit 3;

Create table most_profiting_author as (
SELECT a.title_id,a.au_id,(sales_royalty+a.advance) as profit  FROM (
SELECT tt.advance, tt.title_id ,au.au_id,sum(tt.price * sa.qty * tt.royalty / 100 * tau.royaltyper / 100) as sales_royalty
from authors au
inner join titleauthor tau on tau.au_id = au.au_id
inner join titles tt on tt.title_id = tau.title_id
inner join sales sa on sa.title_id = tt.title_id
group by tt.title , au.au_id
)
as a 
order by profit desc
limit 3
);

select * from most_profiting_author;
