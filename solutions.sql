select titles.title_id,titleauthor.au_id, (titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) as 'Sales_Royalty'
from publications.titles
left join titleauthor 
on titles.title_id=titleauthor.title_id
join sales
on titles.title_id=sales.title_id;


select a.title_id, a.au_id, sum(Sales_Royalty) as Agregated_royalties
From (
select titles.title_id, titleauthor.au_id, (titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) as Sales_Royalty
from publications.titles
left join titleauthor 
on titles.title_id=titleauthor.title_id
join sales
on titles.title_id=sales.title_id) as a
Group by a.title_id, a.au_id;

Select b.au_id, round(sum(Agregated_royalties+b.advance),2) as Total_profit
From(
select a.title_id, a.au_id, a.advance, sum(Sales_Royalty) as Agregated_royalties
From (
select titles.title_id, titleauthor.au_id, titles.advance, (titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) as Sales_Royalty
from publications.titles
left join titleauthor 
on titles.title_id=titleauthor.title_id
join sales
on titles.title_id=sales.title_id) as a
Group by a.title_id, a.au_id) as b
GROUP BY b.au_id
order by Total_profit desc limit 3;


create temporary table publications.TTable1
select titles.title_id,titleauthor.au_id, (titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) as 'Sales_Royalty'
from publications.titles
left join titleauthor 
on titles.title_id=titleauthor.title_id
join sales
on titles.title_id=sales.title_id;

select* 
from ttable1;

select TTable1.title_id, TTable1.au_id, sum(Sales_Royalty) as Agregated_royalties
From TTable1
Group by TTable1.title_id, TTable1.au_id;

select a.au_id, round(sum(a.advance+Agregated_Royalties),2) as Author_Profit
From(
select TTable1.title_id, TTable1.au_id, titles.advance, sum(Sales_Royalty) as Agregated_royalties
From TTable1
join titles on titles.title_id = TTable1.title_id
Group by TTable1.title_id, TTable1.au_id) as a
Group by a.au_id
order by Author_Profit desc limit 3;

Create table publications.most_profiting_authors
select a.au_id, round(sum(a.advance+Agregated_Royalties),2) as profits
From(
select TTable1.title_id, TTable1.au_id, titles.advance, sum(Sales_Royalty) as Agregated_royalties
From TTable1
join titles on titles.title_id = TTable1.title_id
Group by TTable1.title_id, TTable1.au_id) as a
Group by a.au_id
order by profits desc limit 3;

select *
from publications.most_profiting_authors;