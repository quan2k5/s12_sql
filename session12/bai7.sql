create database ss10_7;
use ss10_7;
-- 1
create table departments (
    dept_id int primary key auto_increment, 
    name varchar(100) not null, 
    manager varchar(100) not null, 
    budget decimal(10, 2) not null
);
create table employees (
    emp_id int primary key auto_increment, 
    name varchar(100) not null,
    dept_id int,
    salary decimal(10, 2) not null, 
    hire_date date not null, 
    foreign key (dept_id) references departments(dept_id) 
);

create table projects (
    project_id int primary key auto_increment, 
    name varchar(100) not null,
    emp_id int, 
    start_date date not null, 
    end_date date not null, 
    status varchar(50) not null, 
    foreign key (emp_id) references employees(emp_id) 
);
-- 2
delimiter //
create trigger before_insert_employee
before insert on employees
for each row
begin
    if new.salary < 500 then
        signal sqlstate '45000'
        set message_text = 'lương nhân viên không được thấp hơn 500.';
    end if;
    if not exists (select 1 from departments where dept_id = new.dept_id) then
        signal sqlstate '45000'
        set message_text = 'phòng ban không tồn tại.';
    end if;
    if (select count(*) from projects p 
        join employees e on p.emp_id = e.emp_id
        where e.dept_id = new.dept_id and p.status <> 'Completed') = 0 then
        signal sqlstate '45000'
        set message_text = 'Tất cả dự án đã hoàn thành, không thể thêm nhân viên';
    end if;
end //
delimiter ;
-- 3
create table project_warnings (
    warning_id int auto_increment primary key,
    project_id int not null,
    warning_message varchar(255) not null,
    created_at date default (curdate()),
    foreign key (project_id) references project(project_id)
);

create table dept_warnings (
    warning_id int auto_increment primary key,
    dept_id int not null,
    warning_message varchar(255) not null,
    created_at date  default (curdate()),
    foreign key (dept_id) references departments(dept_id)
)
delimiter //

create trigger after_update_project_status
after update on projects
for each row
begin
    declare dept_budget decimal(10,2);
    declare total_salary decimal(10,2);
    declare dept_id_int int;
    if new.status = 'delayed' then
        insert into project_warnings (project_id, warning_message)
        values (new.project_id, 'dự án bị trì hoãn.');
    end if;
    if new.status = 'completed' then
        if new.end_date is null then
            set new.end_date = curdate();
        end if;
        select dept_id into dept_id_int from employees where emp_id = new.emp_id limit 1;
        select sum(salary) into total_salary from employees where dept_id = dept_id_int;
        select budget into dept_budget from departments where dept_id = dept_id_int;
        if total_salary > dept_budget then
            insert into dept_warnings (dept_id, warning_message)
            values (dept_id_int, 'tổng lương nhân viên vượt quá ngân sách của phòng ban.');
        end if;
    end if;
end //
delimiter ;
-- 4
create view fulloverview as
select 
    e.emp_id,e.name as employee_name,d.name as department_name,concat('$', format(e.salary, 2)) as formatted_salary,p.name as project_name,p.status as project_status
from employees e
left join departments d on e.dept_id = d.dept_id
left join project p on e.emp_id = p.emp_id;
-- 5
INSERT INTO employees (name, dept_id, salary, hire_date)

VALUES ('Alice', 1, 400, '2023-07-01'); 

INSERT INTO employees (name, dept_id, salary, hire_date)

VALUES ('Bob', 999, 1000, '2023-07-01'); 

INSERT INTO employees (name, dept_id, salary, hire_date)

VALUES ('Charlie', 2, 1500, '2023-07-01');

INSERT INTO employees (name, dept_id, salary, hire_date)

VALUES ('David', 1, 2000, '2023-07-01');
-- 6
UPDATE projects SET status = 'Delayed' WHERE project_id = 1;

UPDATE projects SET status = 'Completed', end_date = NULL WHERE project_id = 2;

UPDATE projects SET status = 'Completed' WHERE project_id = 3;

UPDATE projects SET status = 'In Progress' WHERE project_id = 4;
-- 7
select * from fulloverview;


