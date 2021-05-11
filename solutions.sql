use publications;

select s.title_id as "Title ID", a.au_id as "Author ID", s.qty as "Quantity", t.price as "Price", t.price * s.qty as "Total sales", t.royalty as "Royalty", (t.price * s.qty) * (royalty/100) as "Royalty of each sale"
from
	(
		select
			title_id,
            sum(qty) as qty
		from sales
        group by title_id
	) as s
left join titleauthor ta on s.title_id = ta.title_id
left join authors a on ta.au_id = a.au_id
left join titles t on s.title_id = t.title_id
order by 7 desc;

select s.title_id as "Title ID", a.au_id as "Author ID", s.qty as "Quantity", t.price as "Price", t.price * s.qty as "Total sales", t.royalty as "Royalty", (t.price * s.qty) * (royalty/100) as "Royalty of each sale", t.advance, ((t.price * s.qty) * (royalty/100)) + t.advance as "Profit"
from
	(
		select
			title_id,
            sum(qty) as qty
		from sales
        group by title_id
	) as s
left join titleauthor ta on s.title_id = ta.title_id
left join authors a on ta.au_id = a.au_id
left join titles t on s.title_id = t.title_id
order by 7 desc;