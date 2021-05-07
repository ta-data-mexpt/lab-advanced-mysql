
select * from titles;
select * from titleauthor;


select 
		titles.title_id 'Title ID',
        titleauthor.au_id 'Author ID',
        titles.price * sales.qty * (titles.royalty/100) * (titleauthor.royaltyper/100)'Qty'
from titles
inner join titleauthor on titleauthor.title_id = titles.title_id
inner join sales on sales.title_id = titles.title_id
group by titleauthor.au_id
;


select * from authors;


