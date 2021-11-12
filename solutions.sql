select publications.authors.au_id as 'Author_ID', publications.titles.title_id as 'Title_ID',
titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100 as 'Sales_royalty'
from publications.authors
inner join publications.titleauthor
on publications.titleauthor.au_id = publications.authors.au_id
inner join publications.titles
on publications.titles.title_id = publications.titleauthor.title_id
inner join publications.sales
on publications.sales.title_id = publications.titles.title_id;

select Royalties.Author_ID, Royalties.Title_ID, sum(Royalties.Sales_royalty) from (
select publications.authors.au_id as 'Author_ID', publications.titles.title_id as 'Title_ID',
titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100 as 'Sales_royalty'
from publications.authors
inner join publications.titleauthor
on publications.titleauthor.au_id = publications.authors.au_id
inner join publications.titles
on publications.titles.title_id = publications.titleauthor.title_id
inner join publications.sales
on publications.sales.title_id = publications.titles.title_id) as Royalties
group by Royalties.Author_ID, Royalties.Title_ID;

select * from (
select TotRoyalties.Author_ID, sum((publications.titles.advance*(publications.titleauthor.royaltyper/100))+TotRoyalties.Total_Royalties) as 'Profit' from (
select Royalties.Author_ID as 'Author_ID', Royalties.Title_ID as 'Title_ID', sum(Royalties.Sales_royalty) as 'Total_Royalties' from (
select publications.authors.au_id as 'Author_ID', publications.titles.title_id as 'Title_ID',
titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100 as 'Sales_royalty'
from publications.authors
inner join publications.titleauthor
on publications.titleauthor.au_id = publications.authors.au_id
inner join publications.titles
on publications.titles.title_id = publications.titleauthor.title_id
inner join publications.sales
on publications.sales.title_id = publications.titles.title_id) as Royalties
group by Royalties.Author_ID, Royalties.Title_ID) as TotRoyalties
inner join publications.titles
on publications.titles.title_id = TotRoyalties.Title_ID
inner join publications.titleauthor
on publications.titleauthor.title_id = publications.titles.title_id
group by TotRoyalties.Author_ID) as TotalEarnings
order by TotalEarnings.Profit DESC
LIMIT 3;


Create temporary table Royalties(
select publications.authors.au_id as 'Author_ID', publications.titles.title_id as 'Title_ID',
titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100 as 'Sales_royalty'
from publications.authors
inner join publications.titleauthor
on publications.titleauthor.au_id = publications.authors.au_id
inner join publications.titles
on publications.titles.title_id = publications.titleauthor.title_id
inner join publications.sales
on publications.sales.title_id = publications.titles.title_id);

Create temporary table TotRoyalties(
select Royalties.Author_ID as 'Author_ID', Royalties.Title_ID as 'Title_ID', sum(Royalties.Sales_royalty) as 'Total_Royalties' 
from Royalties
group by Royalties.Author_ID, Royalties.Title_ID);

Create temporary table TotalEarnings(
select TotRoyalties.Author_ID, sum((publications.titles.advance*(publications.titleauthor.royaltyper/100))+TotRoyalties.Total_Royalties) as 'Profit' 
from TotRoyalties
inner join publications.titles
on publications.titles.title_id = TotRoyalties.Title_ID
inner join publications.titleauthor
on publications.titleauthor.title_id = publications.titles.title_id
group by TotRoyalties.Author_ID);

create temporary table Top3 (select * 
from TotalEarnings
order by TotalEarnings.Profit DESC
LIMIT 3);

create table most_profiting_authors(
select * from Top3);