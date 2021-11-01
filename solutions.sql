#Challenge 1

USE publications;

select 
    a.au_id,
	a.au_lname,
	a.au_fname,
	s.title_id,
	s.qty,
    t.price,
	t.price * s.qty as venta_total,
	t.royalty,
	(t.price * s.qty) * (royalty/100) as venta_royalty
from
	(
		select
			title_id,
            sum(qty) as qty
		from sales
        group by title_id
	) as s
left join titleauthor ta
	on s.title_id = ta.title_id
left join authors a
	on ta.au_id = a.au_id
left join titles t
	on s.title_id = t.title_id
order by venta_royalty desc;

select 
    a.au_id,
	a.au_lname,
	a.au_fname,
	s.title_id,
	s.qty,
    t.price,
	t.price * s.qty as total_sales,
	t.royalty,
	(t.price * s.qty) * (royalty/100) as royalty_sales,
	t.advance,
	((t.price * s.qty) * (royalty/100)) + t.advance as profit
from
	(
		select
			title_id,
            sum(qty) as qty
		from sales
        group by title_id
	) as s
left join titleauthor ta
	on s.title_id = ta.title_id
left join authors a
	on ta.au_id = a.au_id
left join titles t
	on s.title_id = t.title_id
order by profit desc;

#Challenge 2

create temporary table qty_sales_temp
select
	title_id,
	sum(qty) as qty
from sales
group by title_id;


select 
    a.au_id,
	a.au_lname,
	a.au_fname,
	s.title_id,
	s.qty,
    t.price,
	t.price * s.qty as total_sales,
	t.royalty,
	(t.price * s.qty) * (royalty/100) as royalty_sales,
	t.advance,
	((t.price * s.qty) * (royalty/100)) + t.advance as profit
from qty_sales_temp s
left join titleauthor ta
	on s.title_id = ta.title_id
left join authors a
	on ta.au_id = a.au_id
left join titles t
	on s.title_id = t.title_id
order by profit desc
;

#Challenge 3

create table mas_ganancias_autor
select 
    a.au_id,
	((t.price * s.qty) * (royalty/100)) + t.advance as profit
from qty_sales_temp s
left join titleauthor ta
	on s.title_id = ta.title_id
left join authors a
	on ta.au_id = a.au_id
left join titles t
	on s.title_id = t.title_id
order by profit desc;