select titles.title_id as Title_ID, authors.au_id as Author_ID, (titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) as sales_royalty
from authors
	join titleauthor on authors.au_id = titleauthor.au_id
	join titles on titleauthor.title_id = titles.title_id
	join sales on titles.title_id = sales.title_id;
    
    

create temporary table royalties
select titles.title_id as Title_ID, authors.au_id as Author_ID, (titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) as sales_royalty
from authors
	join titleauthor on authors.au_id = titleauthor.au_id
	join titles on titleauthor.title_id = titles.title_id
	join sales on titles.title_id = sales.title_id;
    
---------------------------------------------------------------------------------------------------------

select 	Title_ID, Author_ID, SUM(sales_royalty) as aggre_royalties
from royalties
GROUP BY Title_ID, Author_ID;

create temporary table royalties_aggre
select 	Title_ID, Author_ID, SUM(sales_royalty) as aggre_royalties
from author_royalties
GROUP BY Title_ID, Author_ID;

----------------------------------------------------------------------------------------------------------------

select 	Author_ID, SUM(titles.advance * titleauthor.royaltyper / 100) + SUM(aggre_royalties) as profits
from royalties_aggre
	join titles on royalties_aggre.Title_id = titles.title_id
	join titleauthor on royalties_aggre.Author_ID = titleauthor.au_id and royalties_aggre.Title_ID = titleauthor.title_id 
group by Author_ID
order by Profits desc;

-----------------------------------------------------------------------------------------------------------------

select 	Author_ID, SUM((titles.advance * titleauthor.royaltyper / 100) + aggre_royalties) as profits
from (
	select Title_ID, Author_ID, SUM(royalty) as aggre_royalties
	from ( 
		select	titles.title_id as Title_ID, authors.au_id as Author_ID, (titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) as royalty
		from authors
			join titleauthor on authors.au_id = titleauthor.au_id
			join titles on titleauthor.title_id = titles.title_id
			join sales on titles.title_id = sales.title_id) as author_royalties
		
	group by Title_ID, Author_ID ) as author_royalties_agg
		join titles on author_royalties_agg.Title_id = titles.title_id
		join titleauthor on author_royalties_agg.Author_ID = titleauthor.au_id and author_royalties_agg.Title_ID = titleauthor.title_id
group by Author_ID
order by Profits desc;
--------------------------------------------------------------------------------------------------------------------------

create table most_profiting_authors
select 	Author_ID, SUM((titles.advance * titleauthor.royaltyper / 100) + aggre_royalties) as profits
from (
	select Title_ID, Author_ID, SUM(royalty) as aggre_royalties
	from ( 
		select	titles.title_id as Title_ID, authors.au_id as Author_ID, (titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) as royalty
		from authors
			join titleauthor on authors.au_id = titleauthor.au_id
			join titles on titleauthor.title_id = titles.title_id
			join sales on titles.title_id = sales.title_id) as author_royalties
		
	group by Title_ID, Author_ID ) as author_royalties_agg
		join titles on author_royalties_agg.Title_id = titles.title_id
		join titleauthor on author_royalties_agg.Author_ID = titleauthor.au_id and author_royalties_agg.Title_ID = titleauthor.title_id
group by Author_ID
order by Profits desc;

