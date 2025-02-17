USE `Chinook`;
-- 2
create view view_high_value_customers as
select c.customerid,concat(c.firstname, ' ', c.lastname) as fullname,c.email,sum(i.total) as total_spending
from customer c
join invoice i on c.customerid = i.customerid
where i.invoicedate >= '2010-01-01'and c.country != 'brazil'
group by c.customerid, c.firstname, c.lastname, c.email
having sum(i.total) > 200;
-- 3
create view view_popular_tracks as
select t.trackid,t.name as track_name,sum(il.quantity) as total_sales
from track t
join invoiceline il on t.trackid = il.trackid
where il.unitprice > 1.00
group by t.trackid, t.name having sum(il.quantity) > 15;
-- 4
create index idx_customer_country on customer(country);
select * from customer where country = 'Cuba';
explain select * from customer where country = 'Cuba';
-- 5
create fulltext index idx_track_name_ft on track(name);
select * from track where match(name) against ('Love');
explain select * from track where match(name) against ('Love');
-- 6
select v.customerid, v.fullname, v.email, v.total_spending from view_high_value_customers v join customer c on v.customerid = c.customerid where c.country = 'Cuba';






