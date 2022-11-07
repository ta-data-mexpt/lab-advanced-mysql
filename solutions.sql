
select titles.title, titles.title_id,
titles.advance * (titles.royalty/100) * (titleauthor.royaltyper/100) as advance_royalties, 
authors.au_id,
titles.price * sales.qty * (titles.royalty/100) * (titleauthor.royaltyper/100) as sales_royalty
from titles
left join titleauthor on titles.title_id = titleauthor.title_id
left join authors on titleauthor.au_id = authors.au_id
left join sales on titles.title_id = sales.title_id
where titleauthor.au_id is not null;

select title_id, title, au_id,
sum(sales_royalty) as total_sales_royalty, sum(advance_royalties) as total_advance_royalties 
from royalties
group by au_id, title_id;