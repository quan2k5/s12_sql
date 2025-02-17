use session12;

-- 2
delimiter //
drop procedure if exists get_doctor_details //
create procedure get_doctor_details(input_doctor_id int)
begin
    select 
        d.name as doctor_name, 
        d.specialization,
        count(distinct a.patient_id) as total_patients,
        sum(d.salary / 100) as total_revenue,
        count(p.prescription_id) as total_medicines_prescribed
    from doctors d
    left join appointments a on d.doctor_id = a.doctor_id and a.status = 'completed'
    left join prescriptions p on a.appointment_id = p.appointment_id
    where d.doctor_id = input_doctor_id
    group by d.doctor_id;
end //
delimiter ;
-- 3
create table cancellation_logs (
    log_id int auto_increment primary key,
    appointment_id int,
    log_message varchar(255),
    log_date datetime,
    foreign key (appointment_id) references appointments(appointment_id) on delete cascade
);
-- 4
create table appointment_logs (
    log_id int auto_increment primary key,
    appointment_id int not null,
    log_message varchar(255) not null,
    log_date datetime not null,
    foreign key (appointment_id) references appointments(appointment_id) on delete cascade
);

-- 	5
delimiter //
create trigger after_delete_appointment
after delete on appointments
for each row
begin
    delete from prescriptions where appointment_id = old.appointment_id;
    if old.status = 'cancelled' then
        insert into cancellation_logs (appointment_id, log_message, log_date)
        values (old.appointment_id, 'Cancelled appointment was deleted', now());
    end if;
    if old.status = 'completed' then
        insert into appointment_logs (appointment_id, log_message, log_date)
        values (old.appointment_id, 'Completed appointment was deleted', now());
    end if;
end //
delimiter ;

-- 6
create view FullRevenueReport as
select 
    d.doctor_id,
    d.name as doctor_name,
    count(a.appointment_id) as total_appointments,
    count(distinct a.patient_id) as total_patients,
    sum(case when a.status = 'completed' then d.salary else 0 end) as total_revenue,
    count(p.prescription_id) as total_medicines
from doctors d
left join appointments a on d.doctor_id = a.doctor_id
left join prescriptions p on a.appointment_id = p.appointment_id
group by d.doctor_id, d.name;
-- 7
call get_doctor_details(1);
-- 8
DELETE FROM appointments WHERE appointment_id = 3;
DELETE FROM appointments WHERE appointment_id = 2;
--  9
select * from FullRevenueReport;