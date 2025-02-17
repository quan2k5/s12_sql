use ss12;
-- 1
CREATE TABLE  projects (
    project_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    budget DECIMAL(15,2) NOT NULL,
    total_salary DECIMAL(15,2) DEFAULT 0
);

CREATE TABLE  workers (
    worker_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    project_id INT,
    salary DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (project_id) REFERENCES projects(project_id)
);
-- 2
INSERT INTO projects (name, budget) VALUES
('Bridge Construction', 10000.00),
('Road Expansion', 15000.00),
('Office Renovation', 8000.00);
-- 3
delimiter //
create trigger insert_worker
after insert on workers
for each row
begin
    update projects
    set total_salary = total_salary + new.salary
    where project_id = new.project_id;
end;
//
delimiter ;

delimiter //
create trigger delete_worker
after delete on workers
for each row
begin
    update projects
    set total_salary = total_salary - old.salary
    where project_id = old.project_id;
end;
//
delimiter ;
-- 4
insert into workers (name, project_id, salary) values
('John', 1, 2500.00),
('Alice', 1, 3000.00),
('Bob', 2, 2000.00),
('Eve', 2, 3500.00),
('Charlie', 3, 1500.00);
select * from projects;
-- 5
delete from workers where worker_id = 2;
select * from projects;
