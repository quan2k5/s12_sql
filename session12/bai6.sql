use session12;
-- 2
create table budget_warnings (
    warning_id int auto_increment primary key,
    project_id int not null,
    warning_message varchar(255) not null,
    unique (project_id), 
    foreign key (project_id) references projects(project_id) on delete cascade
);
-- 3
delimiter //
create trigger after_update_total_salary
after update on projects
for each row
begin
    if new.total_salary > new.budget then
        if not exists (select 1 from budget_warnings where project_id = new.project_id) then
            insert into budget_warnings (project_id, warning_message)
            values (new.project_id, 'budget exceeded due to high salary');
        end if;
    else
        delete from budget_warnings where project_id = new.project_id;
    end if;
end //
delimiter ;
-- 4
create view project_overview as
select 
    p.project_id,p.name as project_name,p.budget,p.total_salary,bw.warning_message as warning
from 
    projects p
left join 
    budget_warnings bw on p.project_id = bw.project_id;
-- 5
INSERT INTO workers (name, project_id, salary) VALUES ('Michael', 1, 6000.00);
INSERT INTO workers (name, project_id, salary) VALUES ('Sarah', 2, 10000.00);
INSERT INTO workers (name, project_id, salary) VALUES ('David', 3, 1000.00);
-- 6
select * from project_overview;
select * from budget_warnings;
select * from workers;



