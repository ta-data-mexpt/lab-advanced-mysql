
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




select t.title_id,
 t.price,
 t.advance,
 t.royalty,
 s.qty,
 a.au_id,
 au_lname,
 au_fname,
 ta.royaltyper,
 (t.price * s.qty * t.royalty * ta.royaltyper / 10000) as ROYALTIES
from titles t
inner join sales s on s.title_id = t.title_id
inner join titleauthor ta on ta.title_id = s.title_id
inner join authors a on a.au_id = ta.au_id
order by t.title_id, a.au_id;