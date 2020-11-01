# Step 1: Calculate the royalties of each sales for each author
SELECT titleauthor.title_id, authors.au_id, (titles.price * sales.qty * (titles.royalty / 100) * (titleauthor.royaltyper / 100)) as regalia
FROM world.authors
INNER JOIN titleauthor on authors.au_id = titleauthor.au_id
INNER JOIN titles on titleauthor.title_id = titles.title_id
INNER JOIN sales on titles.title_id = sales.title_id
order by regalia desc;

#Step 2: Aggregate the total royalties for each title for each author
CREATE TABLE world.regalias
SELECT titleauthor.title_id, authors.au_id, (titles.price * sales.qty * (titles.royalty / 100) * (titleauthor.royaltyper / 100)) as regalia
FROM world.authors
INNER JOIN titleauthor on authors.au_id = titleauthor.au_id
INNER JOIN titles on titleauthor.title_id = titles.title_id
INNER JOIN sales on titles.title_id = sales.title_id
order by regalia desc;

SELECT au_id, title_id, sum(regalia) as suma_regalias
FROM world.regalias
group by title_id, au_id
ORDER BY suma_regalias DESC; 

#Step 3: Calculate the total profits of each author
# Perdido