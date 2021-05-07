use publications;

-- Initial solution: Challenge 1 --

SELECT sub2.Author, sum(sub2.Sales_Royalties)
FROM(
SELECT sub.Title as 'Title', sub.Author_ID as 'Author', sum(sub.Sales_Royalties) as 'Sales_Royalties'
FROM(
SELECT t.title_id as 'Title', a.au_id as 'Author_ID', (t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100) as 'Sales_Royalties'
FROM authors a
LEFT JOIN titleauthor ta on a.au_id = ta.au_id
JOIN titles t on ta.title_id = t.title_id
JOIN publishers p on t.pub_id = p.pub_id
JOIN roysched roy on roy.title_id = t.title_id
JOIN sales s on s.title_id = t.title_id
) AS sub
GROUP BY 1, 2
) AS sub2
GROUP BY 1
ORDER BY 2 DESC
LIMIT 3;


-- Alternative solution: TChallenge 2 --

CREATE TEMPORARY TABLE subset
SELECT t.title_id as 'Title', a.au_id as 'Author_ID', (t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100) as 'Sales_Royalties'
FROM authors a
LEFT JOIN titleauthor ta on a.au_id = ta.au_id
JOIN titles t on ta.title_id = t.title_id
JOIN publishers p on t.pub_id = p.pub_id
JOIN roysched roy on roy.title_id = t.title_id
JOIN sales s on s.title_id = t.title_id;

SELECT sub2.Author, sum(sub2.Sales_Royalties)
FROM(
SELECT subset.Title as 'Title', subset.Author_ID as 'Author', sum(subset.Sales_Royalties) as 'Sales_Royalties'
FROM subset
GROUP BY 1, 2
) AS sub2 
GROUP BY 1
ORDER BY 2 DESC
LIMIT 3;

-- Challenge 3: Challenge 3 --

CREATE TABLE most_profiting_authors
SELECT sub2.Author, sum(sub2.Sales_Royalties)
FROM(
SELECT subset.Title as 'Title', subset.Author_ID as 'Author', sum(subset.Sales_Royalties) as 'Sales_Royalties'
FROM subset
GROUP BY 1, 2
) AS sub2 
GROUP BY 1
ORDER BY 2 DESC
LIMIT 3;