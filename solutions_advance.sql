-- Challenge 1
-- 
-- royalties for each sales for each author
-- 
select
		t.title_id,
        a.au_id,
        t.price * s.qty * (t.royalty / 100) * (ta.royaltyper / 100) sales_royalty
  from titles t
  join titleauthor ta on ta.title_id = t.title_id
  join authors a on a.au_id = ta.au_id
  join sales s on s.title_id = ta.title_id
  order by 2;
  
-- 
-- royalties for each title for each author
-- 
select
		t.title_id,
        a.au_id,
        sum(t.price * s.qty * (t.royalty / 100) * (ta.royaltyper / 100)) sales_royalty
  from titles t
  join titleauthor ta on ta.title_id = t.title_id
  join authors a on a.au_id = ta.au_id
  join sales s on s.title_id = ta.title_id
  group by 1, 2
  order by 1
;
  
-- 
-- royalties and advance
--   
select
		t.title_id,
        a.au_id,
        sum(t.price * s.qty * (t.royalty / 100) * (ta.royaltyper / 100)) sales_royalty,
        t.advance * (ta.royaltyper / 100) advance
  from titles t
  join titleauthor ta on ta.title_id = t.title_id
  join authors a on a.au_id = ta.au_id
  join sales s on s.title_id = ta.title_id
  group by 1, 2
  order by 3 + 4 desc
  limit 3
;

-- 
-- Challenge 2 -- Alternative solution 
-- 
  select
		t.title_id,
		ta.au_id,
        t.price * sum(s.qty) * (t.royalty / 100) * (ta.royaltyper / 100) sales_royalty,
        t.advance * (ta.royaltyper / 100) advance
  from titles t
  join titleauthor ta on ta.title_id = t.title_id
  join sales s on s.title_id = ta.title_id
  group by 1, 2, 4
  order by 4  + 5 desc
  limit 3
  ;


-- 
-- Challene 3 - Create permanent table
-- 
create table most_profiting_authors
 select
		t.title_id,
		ta.au_id,
        t.price * sum(s.qty) * (t.royalty / 100) * (ta.royaltyper / 100) sales_royalty,
        t.advance * (ta.royaltyper / 100) advance
  from titles t
  join titleauthor ta on ta.title_id = t.title_id
  join sales s on s.title_id = ta.title_id
  group by 1, 2, 4
  order by 4  + 5 desc
  ;
  
  select * from most_profiting_authors;
  
-- drop table most_profiting_authors;