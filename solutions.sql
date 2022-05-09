-- CHALLENGE 1
-- paso 1
select titles.title_id as TITLE_ID, authors.au_id as AUTHOR_ID, (titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) as ROYALTY
from titleauthor
left join authors
using (au_id)
left join titles
using (title_id)
left join sales
using (title_id);

-- paso 2

select TITLE_ID, AUTHOR_ID, sum(ROYALTY) as TOTAL_ROYALTY
from (select titles.title_id as TITLE_ID, authors.au_id as AUTHOR_ID, (titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) as ROYALTY
from titleauthor
left join authors
using (au_id)
left join titles
using (title_id)
left join sales
using (title_id)) as tabla_1
group by AUTHOR_ID,TITLE_ID;

DROP TABLE tabla_2;
-- paso 3

select AUTHOR_ID, sum(TOTAL_ROYALTY) as TOTAL_ROY_AUTOR
from (select TITLE_ID, AUTHOR_ID, sum(ROYALTY) as TOTAL_ROYALTY
from (select titles.title_id as TITLE_ID, authors.au_id as AUTHOR_ID, (titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) as ROYALTY
from titleauthor
left join authors
using (au_id)
left join titles
using (title_id)
left join sales
using (title_id)) as tabla_1
group by AUTHOR_ID,TITLE_ID) as tabla_2
group by AUTHOR_ID
order by TOTAL_ROY_AUTOR DESC
LIMIT 3;

-- CHALLENGE 2
-- paso 1
create temporary table paso_1
select titles.title_id as TITLE_ID, authors.au_id as AUTHOR_ID, (titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) as ROYALTY
from titleauthor
left join authors
using (au_id)
left join titles
using (title_id)
left join sales
using (title_id);

select * from paso_1;

-- paso 2
create temporary table paso_2
select TITLE_ID, AUTHOR_ID, sum(ROYALTY) as TOTAL_ROYALTY
from paso_1
group by AUTHOR_ID,TITLE_ID;

select * from paso_2;

-- paso 3
select AUTHOR_ID, sum(TOTAL_ROYALTY) as TOTAL_ROY_AUTOR
from paso_2
group by AUTHOR_ID
order by TOTAL_ROY_AUTOR DESC
LIMIT 3;

-- CHALLENGE 3

create table most_profiting_authors
select AUTHOR_ID, sum(TOTAL_ROYALTY) as PROFITS
from paso_2
group by AUTHOR_ID
order by PROFITS DESC;

SELECT * FROM most_profiting_authors;