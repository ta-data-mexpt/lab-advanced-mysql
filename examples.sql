select stores.stor_name as 'Store',
count(distinct(ord_num)) as 'Orders',
count(title_id) as 'Items',
sum(qty) as 'Qty'
from publications.sales sales
inner join stores on stores.stor_id = sales.stor_id
group by Store;

select * from sales;
select * from 

SELECT stores.stor_name AS Store, COUNT(DISTINCT(ord_num)) AS Orders, COUNT(title_id) AS Items, SUM(qty) AS Qty
FROM publications.sales sales
INNER JOIN publications.stores stores ON stores.stor_id = sales.stor_id
GROUP BY Store;


select store, items/orders as 'AvgItems', Qty/Items as 'AvgQty'
from (
	select
    stores.stor_name as 'Store',
    count(distinct(ord_num)) as 'Orders',
    count(title_id) as 'Items',
    sum(qty) as 'Qty'
		from publications.sales sales
        inner join publications.stores stores on stores.stor_id = sales.stor_id
        group by Store
		)
summary;


