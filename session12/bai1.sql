CREATE DATABASE ss12;
USE ss12;
-- Tạo bảng orders
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    product VARCHAR(100) NOT NULL,
    quantity INT DEFAULT 1,
    price DECIMAL(10, 2) NOT NULL CHECK (price > 0),
    order_date DATE NOT NULL
);

-- Thêm dữ liệu vào bảng
INSERT INTO orders (customer_name, product, quantity, price, order_date) VALUES
('Alice', 'Laptop', 2, 1500.00, '2023-01-10'),
('Bob', 'Smartphone', 5, 800.00, '2023-02-15'),
('Carol', 'Laptop', 1, 1500.00, '2023-03-05'),
('Alice', 'Keyboard', 3, 100.00, '2023-01-20'),
('Dave', 'Monitor', NULL, 300.00, '2023-04-10');
-- 2
delimiter //
create trigger before_insert_orders
before insert on orders
for each row
begin
    if new.quantity is null or new.quantity < 1 then
        set new.quantity = 1;
    end if;
    if new.order_date is null then
        set new.order_date = curdate();
    end if;
end //
delimiter ;
-- 3
insert into orders (customer_name, product, quantity, price, order_date) 
values ('alex', 'may tinh bang', 10, 400.00, null);
insert into orders (customer_name, product, quantity, price, order_date) 
values ('quan', 'ban phim co', -1, 120.00, '2024-12-12');
select * from orders;
-- 4
drop trigger  before_insert_orders;





