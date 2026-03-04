.open fittrackpro.db
.mode column 

PRAGMA foreign_keys = OFF;

DROP TABLE IF EXISTS equipment_maintenance_log;
DROP TABLE IF EXISTS member_health_metrics;
DROP TABLE IF EXISTS personal_training_sessions;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS class_attendance;
DROP TABLE IF EXISTS attendance;
DROP TABLE IF EXISTS memberships;
DROP TABLE IF EXISTS class_schedule;
DROP TABLE IF EXISTS classes;
DROP TABLE IF EXISTS equipment;
DROP TABLE IF EXISTS staff;
DROP TABLE IF EXISTS members;
DROP TABLE IF EXISTS locations;

PRAGMA foreign_keys = ON;

CREATE TABLE locations (
    location_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    address TEXT NOT NULL,
    phone_number TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL
        CHECK (email LIKE '%@%.%'),   -- forces email to contain @ symbol and a . so email is valid address
    opening_hours TEXT NOT NULL
);

CREATE TABLE members (
    member_id INTEGER PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL
        CHECK (email LIKE '%@%.%'),
    phone_number TEXT NOT NULL,
    date_of_birth DATE NOT NULL,
    join_date DATE DEFAULT CURRENT_DATE,
    emergency_contact_name TEXT,
    emergency_contact_phone TEXT
);

CREATE TABLE staff (
    staff_id INTEGER PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL
            CHECK (email LIKE '%@%.%'),
    phone_number TEXT NOT NULL,
    position TEXT NOT NULL 
        CHECK (position IN ('Trainer','Manager','Receptionist','Maintenance')),
    hire_date DATE NOT NULL,
    location_id INTEGER NOT NULL,
    FOREIGN KEY (location_id) 
        REFERENCES locations(location_id)
);

CREATE TABLE equipment (
    equipment_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    type TEXT NOT NULL 
        CHECK (type IN ('Cardio','Strength')),
    purchase_date DATE NOT NULL,
    last_maintenance_date DATE,
    next_maintenance_date DATE,
    location_id INTEGER NOT NULL,
    FOREIGN KEY (location_id) 
        REFERENCES locations(location_id)
);

CREATE TABLE classes (
    class_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    capacity INTEGER NOT NULL 
        CHECK (capacity > 0),
    duration INTEGER NOT NULL 
        CHECK (duration > 0),
    location_id INTEGER NOT NULL,
    FOREIGN KEY (location_id) 
        REFERENCES locations(location_id)
);

CREATE TABLE class_schedule (
    schedule_id INTEGER PRIMARY KEY,
    class_id INTEGER NOT NULL,
    staff_id INTEGER NOT NULL,
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,
    FOREIGN KEY (class_id) 
        REFERENCES classes(class_id),
    FOREIGN KEY (staff_id) 
        REFERENCES staff(staff_id)
);

CREATE TABLE memberships (
    membership_id INTEGER PRIMARY KEY,
    member_id INTEGER NOT NULL,
    type TEXT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status TEXT NOT NULL 
        CHECK (status IN ('Active', 'Inactive')),
    FOREIGN KEY (member_id) 
        REFERENCES members(member_id)
);

CREATE TABLE attendance (
    attendance_id INTEGER PRIMARY KEY,
    member_id INTEGER NOT NULL,
    location_id INTEGER NOT NULL,
    check_in_time DATETIME NOT NULL,
    check_out_time DATETIME,
    FOREIGN KEY (member_id) 
        REFERENCES members(member_id),
    FOREIGN KEY (location_id) 
        REFERENCES locations(location_id)
);

CREATE TABLE class_attendance (
    class_attendance_id INTEGER PRIMARY KEY,
    schedule_id INTEGER NOT NULL,
    member_id INTEGER NOT NULL,
    attendance_status TEXT NOT NULL 
        CHECK (attendance_status IN ('Registered', 'Attended', 'Unattended')),
    FOREIGN KEY (schedule_id) 
        REFERENCES class_schedule(schedule_id),
    FOREIGN KEY (member_id) 
        REFERENCES members(member_id)
);

CREATE TABLE payments (
    payment_id INTEGER PRIMARY KEY,
    member_id INTEGER NOT NULL,
    amount FLOAT NOT NULL 
        CHECK (amount > 0),
    payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,    -- by default the payment is recorded as the current date and time
    payment_method TEXT NOT NULL 
        CHECK (payment_method IN ('Credit Card', 'Bank Transfer', 'PayPal', 'Cash')),   -- Cash added to schema as cash was one of the values in the data set not included in read.md
    payment_type TEXT NOT NULL 
        CHECK (payment_type IN ('Monthly membership fee', 'Day pass')),
    FOREIGN KEY (member_id) 
        REFERENCES members(member_id)
);

CREATE TABLE personal_training_sessions (
    session_id INTEGER PRIMARY KEY,
    member_id INTEGER NOT NULL,
    staff_id INTEGER NOT NULL,
    session_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    notes TEXT,
    FOREIGN KEY (member_id) 
        REFERENCES members(member_id),
    FOREIGN KEY (staff_id) 
        REFERENCES staff(staff_id)
);

CREATE TABLE member_health_metrics (
    metric_id INTEGER PRIMARY KEY,
    member_id INTEGER NOT NULL,
    measurement_date DATE NOT NULL,
    weight FLOAT,
    body_fat_percentage DECIMAL(4,2),
    muscle_mass FLOAT,
    bmi FLOAT,
    FOREIGN KEY (member_id) 
        REFERENCES members(member_id)
);

CREATE TABLE equipment_maintenance_log (
    log_id INTEGER PRIMARY KEY,
    equipment_id INTEGER NOT NULL,
    maintenance_date DATE NOT NULL,
    description TEXT,
    staff_id INTEGER NOT NULL,
    FOREIGN KEY (equipment_id) 
        REFERENCES equipment(equipment_id),
    FOREIGN KEY (staff_id) 
        REFERENCES staff(staff_id)
);