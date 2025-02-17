use sakila;
-- 2
create view view_long_action_movies as
select f.film_id, f.title, f.length, c.name as category_name
from film f join film_category fc on f.film_id = fc.film_id join category c on fc.category_id = c.category_id
where c.name = 'Action' and f.length > 100;
-- 3
create view view_texas_customers as
select c.customer_id, c.first_name, c.last_name, ci.city
from customer c join address a on c.address_id = a.address_id join city ci on a.city_id = ci.city_id join rental r on c.customer_id = r.customer_id
where ci.city = 'Texas' group by c.customer_id, c.first_name, c.last_name, ci.city;
-- 4
create view view_high_value_staff as
select s.staff_id, s.first_name, s.last_name, sum(p.amount) as total_payment
from staff s join payment p on s.staff_id = p.staff_id
group by s.staff_id, s.first_name, s.last_name having sum(p.amount) > 100;
-- 5
create fulltext index idx_film_title_description  on film(title, description);
-- 6
create index idx_rental_inventory_id on rental(inventory_id) using hash;
-- 7
select * from view_long_action_movies where match(title, description) against('War' in natural language mode);
-- 8
DELIMITER $$
create procedure GetRentalByInventory(IN inventory_id INT)
begin
    select * from rental where inventory_id = inventory_id;
end$$
DELIMITER ;
call GetRentalByInventory(1); 
-- 9
drop index idx_film_title_description on film;
drop index idx_rental_inventory_id on rental;
drop procedure GetRentalByInventory;
drop view view_long_action_movies;
drop view view_texas_customers;
drop view view_high_value_staff;







