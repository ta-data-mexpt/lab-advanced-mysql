# STEP 1
SELECT publications.titles.title_id AS ID_TITULO, 
publications.titleauthor.au_id AS ID_AUTOR,
sum(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) AS PROFIT
FROM publications.authors
INNER JOIN publications.titleauthor
ON titleauthor.au_id= authors.au_id
INNER JOIN publications.titles
ON titles.title_id= titleauthor.title_id
INNER JOIN publications.sales
ON sales.title_id = titles.title_id
GROUP BY publications.titleauthor.au_id
ORDER BY PROFIT DESC;

# STEP 2
SELECT publications.titles.title_id AS ID_TITULO, 
publications.titleauthor.au_id AS ID_AUTOR,
sum(titles.price * sales.qty * titles.royalty / 100) AS ROYALTIES_OF_TITLE
FROM publications.authors
INNER JOIN publications.titleauthor
ON titleauthor.au_id= authors.au_id
INNER JOIN publications.titles
ON titles.title_id= titleauthor.title_id
INNER JOIN publications.sales
ON sales.title_id = titles.title_id
GROUP BY publications.titleauthor.au_id, publications.titleauthor.title_id;

# STEP 3
SELECT publications.titleauthor.au_id AS ID_AUTOR,
sum((titles.price * sales.qty * titles.royalty / 100) + titles.advance * (titles.royalty/100)) AS PROFITS_PER_AUTHOR
FROM publications.authors
INNER JOIN publications.titleauthor
ON titleauthor.au_id= authors.au_id
INNER JOIN publications.titles
ON titles.title_id= titleauthor.title_id
INNER JOIN publications.sales
ON sales.title_id = titles.title_id
GROUP BY publications.titleauthor.au_id
ORDER BY PROFITS_PER_AUTHOR DESC;

# Challenge 2
# STEP 1 y 2
CREATE TEMPORARY TABLE step1_2
SELECT publications.titles.title_id AS ID_TITULO,
publications.titleauthor.au_id AS ID_AUTOR,
sum((titles.price * sales.qty * titles.royalty / 100) + titles.advance * (titles.royalty/100)) AS PROFITS_PER_AUTHOR
FROM publications.authors
INNER JOIN publications.titleauthor
ON titleauthor.au_id= authors.au_id
INNER JOIN publications.titles
ON titles.title_id= titleauthor.title_id
INNER JOIN publications.sales
ON sales.title_id = titles.title_id
GROUP BY publications.titleauthor.au_id, publications.titleauthor.title_id
ORDER BY PROFITS_PER_AUTHOR DESC;

# STEP 3
SELECT step1_2.ID_AUTOR AS ID_AUTOR,
sum(PROFITS_PER_AUTHOR)
FROM step1_2
GROUP BY step1_2.ID_AUTOR
ORDER BY PROFITS_PER_AUTHOR DESC;

# Challenge 3
CREATE TABLE publications.most_profiting_authors
SELECT publications.titleauthor.au_id AS ID_AUTOR,
sum((titles.price * sales.qty * titles.royalty / 100) + titles.advance * (titles.royalty/100)) AS PROFITS_PER_AUTHOR
FROM publications.authors
INNER JOIN publications.titleauthor
ON titleauthor.au_id= authors.au_id
INNER JOIN publications.titles
ON titles.title_id= titleauthor.title_id
INNER JOIN publications.sales
ON sales.title_id = titles.title_id
GROUP BY publications.titleauthor.au_id
ORDER BY PROFITS_PER_AUTHOR DESC;