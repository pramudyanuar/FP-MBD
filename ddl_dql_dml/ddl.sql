-- Table: Patient
CREATE TABLE Patient (
    patient_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(22) NOT NULL,
    phone_number VARCHAR(15) NOT NULL,
    address VARCHAR(255),
    gender VARCHAR(15)
);

-- Table: Doctors
CREATE TABLE Doctors (
    doctor_id SERIAL PRIMARY KEY,
    name VARCHAR(30) NOT NULL,
    specialization VARCHAR(50),
    fee INT,
    ratings INT,
    str_number VARCHAR(10),
    gender VARCHAR(15)
);

-- Table: Schedule
CREATE TABLE Schedule (
    schedule_id SERIAL PRIMARY KEY,
    day VARCHAR(10),
    hour TIME
);

-- Table: Doctors_sched
CREATE TABLE Doctors_sched (
    doctor_id INT REFERENCES Doctors(doctor_id),
    schedule_id INT REFERENCES Schedule(schedule_id),
    PRIMARY KEY (doctor_id, schedule_id)
);

-- Table: Reviews
CREATE TABLE Reviews (
    reviews_id SERIAL PRIMARY KEY,
    rating INT,
    review_content VARCHAR(255),
    review_date TIMESTAMP,
    patient_id INT REFERENCES Patient(patient_id),
    doctor_id INT REFERENCES Doctors(doctor_id),
    appointment_id INT REFERENCES Appointments(appointment_id)
);

-- Table: Appointments
CREATE TABLE Appointments (
    appointment_id SERIAL PRIMARY KEY,
    appointment_date DATE,
    appointment_time TIME,
    status VARCHAR(50),
    patient_id INT REFERENCES Patient(patient_id),
    doctor_id INT REFERENCES Doctors(doctor_id)
);

-- Table: Payments
CREATE TABLE Payments (
    payment_id SERIAL PRIMARY KEY,
    payment_date DATE,
    amount INT,
    payment_method VARCHAR(50),
    appointment_id INT REFERENCES Appointments(appointment_id)
);

-- Table: Messages
CREATE TABLE Messages (
    message_id SERIAL PRIMARY KEY,
    message_content VARCHAR(255),
    sent_date TIMESTAMP,
    sender VARCHAR(20),
    patient_id INT REFERENCES Patient(patient_id),
    doctor_id INT REFERENCES Doctors(doctor_id)
);
