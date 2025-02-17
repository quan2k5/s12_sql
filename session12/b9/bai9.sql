use session12;
-- 1
create table patients (
    patient_id int auto_increment primary key,
    name varchar(100) not null,
    dob date not null,
    gender enum('male', 'female') not null,
    phone varchar(15) not null unique
);
create table doctors (
    doctor_id int auto_increment primary key,
    name varchar(100) not null,
    specialization varchar(100) not null,
    phone varchar(15) not null unique,
    salary decimal(10, 2) not null
);
create table appointments (
    appointment_id int auto_increment primary key,
    patient_id int not null,
    doctor_id int not null,
    appointment_date datetime not null,
    status enum('scheduled', 'completed', 'cancelled') not null,
    foreign key (patient_id) references patients(patient_id),
    foreign key (doctor_id) references doctors(doctor_id)
);
create table prescriptions (
    prescription_id int auto_increment primary key,
    appointment_id int not null,
    medicine_name varchar(100) not null,
    dosage varchar(50) not null,
    duration varchar(50) not null,
    notes varchar(255) null,
    foreign key (appointment_id) references appointments(appointment_id)
);
-- 2
CREATE TABLE patient_error_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_name VARCHAR(100),
    phone_number VARCHAR(15),
    error_message VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3 
delimiter //
create trigger before_insert_patient1
before insert on patients
for each row
begin
    declare patient_exists int;
    select count(*) into patient_exists 
    from patients 
    where name = new.name and dob = new.dob;
    if patient_exists > 0 then
        insert into patient_error_log (patient_name, phone_number, error_message)
        values (new.name, new.phone, 'bệnh nhân đã tồn tại');
        signal sqlstate '45000'
        set message_text = 'bệnh nhân đã tồn tại trong hệ thống!';
    end if;
end //
delimiter ;

-- 4
-- Thêm bệnh nhân hợp lệ
INSERT INTO patients (name, dob, gender, phone) VALUES ('John Doe', '1990-01-01', 'Male', '1234567890');
-- Thêm bệnh nhân trùng thông tin
INSERT INTO patients (name, dob, gender, phone) VALUES ('John Doe', '1990-01-01', 'Male', '0987654321');

-- 5
delimiter //
create trigger check_phone_number_format
before insert on patients
for each row
begin
    if new.phone not regexp '^[0-9]{10}$' then
        insert into patient_error_log (patient_name, phone_number, error_message)
        values (new.name, new.phone, 'số điện thoại không hợp lệ!');
        signal sqlstate '45000'
        set message_text = 'số điện thoại không hợp lệ!';
    end if;
end // 

delimiter ;
-- 6
INSERT INTO patients (name, dob, gender, phone) VALUES
('Alice Smith', '1985-06-15', 'Female', '1234567895'),
('Bob Johnson', '1990-02-25', 'Male', '2345678901'),
('Carol Williams', '1975-03-10', 'Female', '3456789012'),
('Dave Brown', '1992-09-05', 'Male', '4567890abc'),
('Eve Davis', '1980-12-30', 'Female', '56789xyz'),      
('Eve', '1980-12-13', 'Female', '56789');
-- 7
select * from patient_error_log;
-- 8
DELIMITER //
CREATE PROCEDURE UpdateAppointmentStatus(IN appointmentId INT, IN newStatus ENUM('Scheduled', 'Completed', 'Cancelled'))
BEGIN
    UPDATE appointments
    SET status = newStatus
    WHERE appointment_id = appointmentId;
END;
// DELIMITER ;
-- 9
delimiter //
create trigger update_status_after_prescription_insert
after insert on prescriptions
for each row
begin
    call update_appointment_status(new.appointment_id, 'completed');
end //

delimiter ;

-- 10
-- Them bac si
INSERT INTO doctors (name, specialization, phone, salary) 
VALUES ('Dr. John Smith', 'Cardiology', '1234567890', 5000.00);
INSERT INTO doctors (name, specialization, phone, salary) 
VALUES ('Dr. Alice Brown', 'Neurology', '0987654321', 6000.00);
-- Thêm cuộc hẹn 
INSERT INTO appointments (patient_id, doctor_id, appointment_date, status) 
VALUES (1, 1, '2025-02-15 09:00:00', 'Scheduled');
INSERT INTO appointments (patient_id, doctor_id, appointment_date, status) 
VALUES (1, 2, '2025-02-16 10:00:00', 'Scheduled');
INSERT INTO appointments (patient_id, doctor_id, appointment_date, status) 
VALUES (1, 1, '2025-02-17 14:00:00', 'Scheduled');

-- 11
SELECT * FROM appointments;
INSERT INTO prescriptions (appointment_id, medicine_name, dosage, duration, notes) 
VALUES (1, 'Paracetamol', '500mg', '5 days', 'Take one tablet every 6 hours');
SELECT * FROM appointments;