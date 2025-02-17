USE ss12;
-- 2
create table price_changes (
    change_id int auto_increment primary key,
    product varchar(100) not null,
    old_price decimal(10,2) not null,
    new_price decimal(10,2) not null
);
-- 3
delimiter //
create trigger after_orders
after update on orders
for each row
begin
    if old.price != new.price then
        insert into price_changes (product, old_price, new_price)
        values (old.product, old.price, new.price);
    end if;
end;
//
delimiter ;
-- 4
update orders set price = 1400.00 where product = 'laptop';
update orders set price = 800.00 where product = 'smartphone';
-- 5
select * from price_changes;


