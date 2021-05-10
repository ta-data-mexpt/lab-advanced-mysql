/* CHALLENGE 1 STEP 1 */
use publications;
Select 
au.au_id 'AUTHOR ID',
au.au_lname 'LAST NAME',
au.au_fname 'FIRST NAME',
tau.title_id 'TITLE ID',
s.qty as TOTAL,
/*tau.royaltyper ROYALTY,
t.price PRICE,
t.advance,
((sum(s.qty) * tau.royaltyper) / 100 )* t.price as 'FINAL ROYALTY',
(t.advance * tau.royaltyper) / 100 as 'FINAL ADVANCE',
 ifnull(((((sum(s.qty) * tau.royaltyper) / 100 )* t.price) + ((t.advance * tau.royaltyper) / 100)),0) as PROFIT,*/
ifnull((t.price * s.qty * t.royalty / 100 * tau.royaltyper / 100),0) as 'FINAL ROYALTY'
from 
	authors au
left join
	titleauthor tau
    on au.au_id = tau.au_id
left join
	sales s
    on tau.title_id = s.title_id
left join
	titles t
    on s.title_id = t.title_id
group by 1,4,5
order by 1 desc;

/* CHALLENGE 1 STEP 2*/

/* prueba fallida, quiero saber porqué no funcionó
Select 
au.au_id,
au.au_lname,
au.au_fname,
tau.title_id,
SUM('FINAL ROYALTY')
from (Select 
au.au_id 'AUTHOR ID',
au.au_lname 'LAST NAME',
au.au_fname 'FIRST NAME',
tau.title_id 'TITLE ID',
s.qty as TOTAL,
t.price * s.qty * t.royalty / 100 * tau.royaltyper / 100 as 'FINAL ROYALTY'
from 
	authors au
left join
	titleauthor tau
    on au.au_id = tau.au_id
left join
	sales s
    on tau.title_id = s.title_id
left join
	titles t
    on s.title_id = t.title_id
group by 1,4,5) su
left join authors au
on su.au_id = au.au_id
left join titleauthor tau
on au.au_id = tau.au_id
group by 1,4;*/

WITH tablabase as (Select 
au.au_id,
au.au_lname,
au.au_fname,
tau.title_id,
s.qty as TOTAL,
ifnull((t.price * s.qty * t.royalty / 100 * tau.royaltyper / 100),0) as final_royalty
from 
	authors au
left join
	titleauthor tau
    on au.au_id = tau.au_id
left join
	sales s
    on tau.title_id = s.title_id
left join
	titles t
    on s.title_id = t.title_id
group by 1,4,5)
select
tablabase.au_id,
tablabase.au_lname,
tablabase.au_fname,
tablabase.title_id,
sum(tablabase.final_royalty)
from tablabase
group by 1,2,3,4;

/* CHALLENGE 1 STEP 3 */

WITH tablabase as (Select 
au.au_id,
au.au_lname,
au.au_fname,
tau.title_id,
s.qty as TOTAL,
ifnull((t.price * s.qty * t.royalty / 100 * tau.royaltyper / 100),0) as final_royalty
from 
	authors au
left join
	titleauthor tau
    on au.au_id = tau.au_id
left join
	sales s
    on tau.title_id = s.title_id
left join
	titles t
    on s.title_id = t.title_id
group by 1,4,5)
select 
a.au_id, (a.resultado +  t.advance) as profit 
from (select au_id,
au_lname,
au_fname,
title_id,
ifnull(sum(tablabase.final_royalty),0) resultado
from tablabase
group by 1,2,3,4) a
left join titles t
on a.title_id = t.title_id
group by 1
order by 2 desc
limit 3;

/* CHALLENGE 2: Did a little bit of both in my solution*/

/* Challenge 3 */

CREATE TABLE most_profiting_authors
(WITH tablabase as (Select 
au.au_id,
au.au_lname,
au.au_fname,
tau.title_id,
s.qty as TOTAL,
ifnull((t.price * s.qty * t.royalty / 100 * tau.royaltyper / 100),0) as final_royalty
from 
	authors au
left join
	titleauthor tau
    on au.au_id = tau.au_id
left join
	sales s
    on tau.title_id = s.title_id
left join
	titles t
    on s.title_id = t.title_id
group by 1,4,5)
select 
a.au_id, (a.resultado +  t.advance) as profit 
from (select au_id,
au_lname,
au_fname,
title_id,
ifnull(sum(tablabase.final_royalty),0) resultado
from tablabase
group by 1,2,3,4) a
left join titles t
on a.title_id = t.title_id
group by 1
order by 2 desc
limit 3);

select * from most_profiting_authors;
