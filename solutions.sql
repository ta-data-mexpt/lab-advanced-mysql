
SELECT au_id AS AUTHOR_ID, au_lname AS LAST_NAME, au_fname AS FIRST_NAME
,pub_name AS PUBLISHER, title AS TITLE 
from titleauthor, publishers
INNER JOIN authors USING(au_id)
INNER JOIN titles USING(pub_id);


