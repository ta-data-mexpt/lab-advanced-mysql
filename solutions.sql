
-- Challenge 1

-- step 1

select title.title_id, a.au_id, title.price * sal.qty * title.royalty / 100 * t.royaltyper / 100
	from authors a
    join titleauthor t
     on a.au_id = t.au_id
	join titles title
     on t.title_id =title.title_id
	join sales sal
     on sal.title_id = title.title_id
order by 1,2;

-- step 2

select title.title_id, a.au_id, sum(title.price * sal.qty * title.royalty / 100 * t.royaltyper / 100)
	from authors a
    join titleauthor t
     on a.au_id = t.au_id
	join titles title
     on t.title_id =title.title_id
	join sales sal
     on sal.title_id = title.title_id
group  by title.title_id, a.au_id;

-- step 3

select sub.title_id, sum(summ) total
	from(
		select title.title_id, a.au_id, sum(title.price * sal.qty * title.royalty / 100 * t.royaltyper / 100) summ
			from authors a
			join titleauthor t
			 on a.au_id = t.au_id
			join titles title
			 on t.title_id =title.title_id
			join sales sal
			 on sal.title_id = title.title_id
		group  by title.title_id, a.au_id
) sub
group by sub.title_id
order by 2 desc
limit 3
;

-- Challenge 2

create temporary table if not exists result  as
select title.title_id, a.au_id, sum(title.price * sal.qty * title.royalty / 100 * t.royaltyper / 100) summ
			from authors a
			join titleauthor t
			 on a.au_id = t.au_id
			join titles title
			 on t.title_id =title.title_id
			join sales sal
			 on sal.title_id = title.title_id
		group  by title.title_id, a.au_id;

select sub.title_id, sum(summ) total
	from result sub
group by sub.title_id
order by 2 desc
limit 3
;

-- Challenge 3

create table most_profiting_authors as
select sub.title_id, sum(summ) profits
	from(
		select title.title_id, a.au_id, sum(title.price * sal.qty * title.royalty / 100 * t.royaltyper / 100) summ
			from authors a
			join titleauthor t
			 on a.au_id = t.au_id
			join titles title
			 on t.title_id =title.title_id
			join sales sal
			 on sal.title_id = title.title_id
		group  by title.title_id, a.au_id
) sub
group by sub.title_id
order by 2 desc
limit 3
;

