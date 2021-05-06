Use publications
;
------------------------------------
-- Challenge 1
------------------------------------
-- Paso 1
------------------------------------
-- Regalias de cada venta por author
------------------------------------
select 
    a.au_id,
	a.au_lname,
	a.au_fname,
	s.title_id,
	s.qty,
    t.price,
	t.price * s.qty as total_sales,
	t.royalty,
	(t.price * s.qty) * (royalty/100) as royalty_sales
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
order by royalty_sales desc
;
------------------------------------
-- Paso 2
------------------------------------
-- Ganancias totales por autor
------------------------------------
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
order by profit desc
;
------------------------------------
-- Challenge 2
------------------------------------
-- Paso 1 - Creando tabla temporal de cantidad de ventas por titulo
------------------------------------
create temporary table qty_sales_temp
select
	title_id,
	sum(qty) as qty
from sales
group by title_id
;
------------------------------------
-- Paso 2 - Uitiliando tablas temporales
------------------------------------
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

------------------------------------
-- Challenge 3
------------------------------------
-- Creaando tabla permantente
------------------------------------
create table most_profiting_authors
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
order by profit desc
;

