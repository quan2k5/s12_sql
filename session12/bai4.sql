use ss12;
-- 2
create table  order_warnings (
    warning_id int auto_increment primary key,
    order_id int not null,
    warning_message varchar(255) not null
);
-- 3
delimiter //
create trigger after_insert_order_warning
after insert on orders
for each row
begin
    if new.quantity * new.price > 5000 then
        insert into order_warnings (order_id, warning_message)
        values (new.order_id, 'Total value exceeds limit');
    end if;
end;
//
delimiter ;
-- 4
insert into orders (customer_name, product, quantity, price, order_date)
values 
('Mark', 'Monitor', 2, 3000.00, '2023-08-01'),
('Paul', 'Mouse', 1, 50.00, '2023-08-02');
 select * from orders;

