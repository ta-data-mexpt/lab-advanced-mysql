USE publications;

/*
Challenge 1 - Most Profiting Authors

In this challenge let's have a close look at the bonus challenge of the previous MySQL SELECT lab -- who are the top 3 most profiting authors? 
Even if you have solved or think you have solved that problem in the previous lab, 
please still complete this challenge because the step-by-step guidances are helpful to train your problem-solving thinking.

In order to solve this problem, it is important for you to keep the following points in mind:

    In table sales, a title can appear several times. The royalties need to be calculated for each sale.

    Despite a title can have multiple sales records, the advance must be calculated only once for each title.

    In your eventual solution, you need to sum up the following profits for each individual author:
        All advances which is calculated exactly once for each title.
        All royalties in each sale.

Therefore, you will not be able to achieve the goal with a single SELECT query. Instead, you will need to follow several steps in order to achieve the eventual solution. Below is an overview of the steps:

    Calculate the royalty of each sale for each author.

    Using the output from Step 1 as a temp table, aggregate the total royalties for each title for each author.

    Using the output from Step 2 as a temp table, calculate the total profits of each author by aggregating the advances and total royalties of each title.
*/

CREATE TEMPORARY TABLE RoyaltySales as
SELECT TA.title_id, au_id, T.price * S.qty * T.royalty / 100 * TA.royaltyper / 100 AS sales_royalty
FROM titleauthor TA
INNER JOIN TITLES T ON TA.title_id = T.title_id
INNER JOIN SALES S ON T.title_id = S.title_id;

/*
Step 2: Aggregate the total royalties for each title for each author

Using the output from Step 1, write a query to obtain the following output:

    Title ID
    Author ID
    Aggregated royalties of each title for each author
        Hint: use the SUM subquery and group by both au_id and title_id

In the output of this step, each title should appear only once for each author.
*/

CREATE TEMPORARY TABLE TotalRoyalty as
SELECT title_id, au_id, SUM(sales_royalty) as totalroyalty
FROM RoyaltySales
GROUP BY title_id, au_id;

/*
Step 3: Calculate the total profits of each author

Now that each title has exactly one row for each author where the advance and royalties are available, we are ready to obtain the eventual output. 
Using the output from Step 2, write a query to obtain the following output:

    Author ID
    Profits of each author by aggregating the advance and total royalties of each title

Sort the output based on a total profits from high to low, and limit the number of rows to 3.
*/

CREATE TABLE most_profiting_authors
SELECT au_id, SUM(totalroyalty) AS profits
FROM TotalRoyalty
GROUP BY au_id
ORDER BY profits desc
LIMIT 3;
