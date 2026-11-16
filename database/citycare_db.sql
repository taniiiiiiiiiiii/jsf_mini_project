-- =======================================================
-- CityCare: Smart City Complaint Management System
-- Database Setup and Seed Data Script
-- Compatible with MySQL 8.0+
-- =======================================================

DROP DATABASE IF EXISTS citycare_db;
CREATE DATABASE citycare_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE citycare_db;

-- -------------------------------------------------------
-- 1. Departments Table
-- -------------------------------------------------------
CREATE TABLE departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL UNIQUE,
    description VARCHAR(255) NOT NULL,
    contact_email VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- -------------------------------------------------------
-- 2. Users Table (Citizens, Officers, Admins)
-- -------------------------------------------------------
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20) NOT NULL,
    address VARCHAR(255) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('CITIZEN', 'OFFICER', 'ADMIN') NOT NULL DEFAULT 'CITIZEN',
    status ENUM('ACTIVE', 'INACTIVE') NOT NULL DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- -------------------------------------------------------
-- 3. Officers Table (Mapping officers to departments)
-- -------------------------------------------------------
CREATE TABLE officers (
    officer_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL UNIQUE,
    department_id INT NOT NULL,
    designation VARCHAR(100) DEFAULT 'Municipal Officer',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (department_id) REFERENCES departments(department_id) ON DELETE RESTRICT
) ENGINE=InnoDB;

-- -------------------------------------------------------
-- 4. Complaints Table
-- -------------------------------------------------------
CREATE TABLE complaints (
    complaint_id INT AUTO_INCREMENT PRIMARY KEY,
    tracking_id VARCHAR(30) NOT NULL UNIQUE,
    citizen_id INT NOT NULL,
    title VARCHAR(150) NOT NULL,
    category VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    location VARCHAR(255) NOT NULL,
    image_path VARCHAR(255) DEFAULT NULL,
    status ENUM('Submitted', 'Under Review', 'Assigned', 'In Progress', 'Resolved', 'Rejected') NOT NULL DEFAULT 'Submitted',
    priority ENUM('Low', 'Medium', 'High', 'Urgent') NOT NULL DEFAULT 'Medium',
    department_id INT DEFAULT NULL,
    assigned_officer_id INT DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (citizen_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (department_id) REFERENCES departments(department_id) ON DELETE SET NULL,
    FOREIGN KEY (assigned_officer_id) REFERENCES users(user_id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- -------------------------------------------------------
-- 5. Complaint History / Audit Trail
-- -------------------------------------------------------
CREATE TABLE complaint_history (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    complaint_id INT NOT NULL,
    updated_by INT NOT NULL,
    old_status VARCHAR(50) DEFAULT NULL,
    new_status VARCHAR(50) NOT NULL,
    remarks TEXT,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (complaint_id) REFERENCES complaints(complaint_id) ON DELETE CASCADE,
    FOREIGN KEY (updated_by) REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- =======================================================
-- INITIAL SEED DATA
-- Default Passwords (SHA-256 hashed):
-- Admin@123    -> e86f78a8a3caf0b60d8e74e5942aa6d86dc150cd3c03338aef25b7d2d7e3acc7
-- Officer@123  -> b3d8eb159de738ce469ded2b79f1564256ca6650db44be6fe868c9a3287826d2
-- Citizen@123  -> 2de7e52a7a2095efc4f44de114542e045912e3711d286ee64943c95afeae82ab
-- =======================================================

-- Seed Departments
INSERT INTO departments (department_id, department_name, description, contact_email) VALUES
(1, 'Roads and Infrastructure', 'Maintenance of roads, bridges, pavements, and traffic infrastructure', 'roads@citycare.gov'),
(2, 'Sanitation', 'Solid waste management, garbage clearance, and street cleanliness', 'sanitation@citycare.gov'),
(3, 'Water Supply', 'Potable water supply, pipe leakage repairs, and pipeline maintenance', 'water@citycare.gov'),
(4, 'Electricity', 'Streetlights maintenance, civic electrical poles, and public power safety', 'electricity@citycare.gov'),
(5, 'Drainage and Sewage', 'Stormwater drains, underground sewerage, and flood prevention', 'drainage@citycare.gov');

-- Seed Users
-- 1: Admin
INSERT INTO users (user_id, full_name, email, phone, address, password_hash, role, status) VALUES
(1, 'CityCare Administrator', 'admin@citycare.gov', '9876543210', 'Municipal Corporation Central Headquarters, Civic Center', 'e86f78a8a3caf0b60d8e74e5942aa6d86dc150cd3c03338aef25b7d2d7e3acc7', 'ADMIN', 'ACTIVE');

-- 2-6: Municipal Officers
INSERT INTO users (user_id, full_name, email, phone, address, password_hash, role, status) VALUES
(2, 'Rajesh Varma (Roads)', 'officer.roads@citycare.gov', '9876500001', 'Ward 12 Engineering Division', 'b3d8eb159de738ce469ded2b79f1564256ca6650db44be6fe868c9a3287826d2', 'OFFICER', 'ACTIVE'),
(3, 'Sunita Deshmukh (Sanitation)', 'officer.sanitation@citycare.gov', '9876500002', 'Health & Sanitation Wing, Zone 3', 'b3d8eb159de738ce469ded2b79f1564256ca6650db44be6fe868c9a3287826d2', 'OFFICER', 'ACTIVE'),
(4, 'Arun Nair (Water)', 'officer.water@citycare.gov', '9876500003', 'Public Water Works Dept, Division B', 'b3d8eb159de738ce469ded2b79f1564256ca6650db44be6fe868c9a3287826d2', 'OFFICER', 'ACTIVE'),
(5, 'Kavita Iyer (Electricity)', 'officer.electricity@citycare.gov', '9876500004', 'City Power & Illumination Division', 'b3d8eb159de738ce469ded2b79f1564256ca6650db44be6fe868c9a3287826d2', 'OFFICER', 'ACTIVE'),
(6, 'Manoj Kulkarni (Drainage)', 'officer.drainage@citycare.gov', '9876500005', 'Sewerage Operations Command, Zone 1', 'b3d8eb159de738ce469ded2b79f1564256ca6650db44be6fe868c9a3287826d2', 'OFFICER', 'ACTIVE');

-- 7-8: Citizens
INSERT INTO users (user_id, full_name, email, phone, address, password_hash, role, status) VALUES
(7, 'Tanisha Rao', 'citizen@citycare.gov', '9812345678', 'Flat 402, Green Valley Enclave, MG Road', '2de7e52a7a2095efc4f44de114542e045912e3711d286ee64943c95afeae82ab', 'CITIZEN', 'ACTIVE'),
(8, 'Rahul Sharma', 'rahul.sharma@example.com', '9823456789', 'House 14, Sector 7, Outer Ring Road', '2de7e52a7a2095efc4f44de114542e045912e3711d286ee64943c95afeae82ab', 'CITIZEN', 'ACTIVE');

-- Link Officers to Departments
INSERT INTO officers (officer_id, user_id, department_id, designation) VALUES
(1, 2, 1, 'Senior Infrastructure Engineer'),
(2, 3, 2, 'Chief Sanitary Inspector'),
(3, 4, 3, 'Water Supply Officer'),
(4, 5, 4, 'Electrical Works Inspector'),
(5, 6, 5, 'Drainage & Sewage Superintendent');

-- Seed Realistic Initial Complaints
INSERT INTO complaints (complaint_id, tracking_id, citizen_id, title, category, description, location, status, priority, department_id, assigned_officer_id, created_at) VALUES
(1, 'CC-2026-1001', 7, 'Severe pothole near Metro Pillar 142', 'Potholes and damaged roads', 'Large deep pothole causing vehicle damage and traffic bottleneck during peak hours.', 'MG Road, near Metro Pillar 142', 'In Progress', 'High', 1, 2, DATE_SUB(NOW(), INTERVAL 3 DAY)),
(2, 'CC-2026-1002', 7, 'Garbage bin overflowing for three days', 'Overflowing garbage bins', 'Municipal bin on 4th cross is completely overflowing and dogs are scattering waste.', '4th Cross, Green Valley Enclave, MG Road', 'Assigned', 'Medium', 2, 3, DATE_SUB(NOW(), INTERVAL 2 DAY)),
(3, 'CC-2026-1003', 7, 'Major pipeline leakage wasting drinking water', 'Water leakage', 'Clean water is gushing out of broken underground pipe onto the pedestrian pavement.', 'Opposite State Bank, Ring Road', 'Resolved', 'Urgent', 3, 4, DATE_SUB(NOW(), INTERVAL 5 DAY)),
(4, 'CC-2026-1004', 8, 'Three streetlights dark since last weekend', 'Damaged streetlights', 'Three consecutive street lamps are non-functional making the lane completely dark and unsafe at night.', 'Sector 7, Main Avenue near Community Park', 'Submitted', 'Medium', 4, NULL, DATE_SUB(NOW(), INTERVAL 1 DAY)),
(5, 'CC-2026-1005', 8, 'Sewage overflow near Primary School', 'Drainage and sewage problems', 'Drainage chamber is clogged and sewage water is flooding the school entrance gate.', 'Primary School Lane, Sector 7', 'Under Review', 'Urgent', 5, 6, DATE_SUB(NOW(), INTERVAL 1 DAY));

-- Seed Complaint History
INSERT INTO complaint_history (complaint_id, updated_by, old_status, new_status, remarks, updated_at) VALUES
(1, 7, NULL, 'Submitted', 'Complaint registered by citizen with initial photos.', DATE_SUB(NOW(), INTERVAL 3 DAY)),
(1, 1, 'Submitted', 'Assigned', 'Assigned to Roads and Infrastructure Department officer Rajesh Varma.', DATE_SUB(NOW(), INTERVAL 2 DAY)),
(1, 2, 'Assigned', 'In Progress', 'Inspection completed. Asphalt patch team scheduled for tonight.', DATE_SUB(NOW(), INTERVAL 1 DAY)),

(2, 7, NULL, 'Submitted', 'Complaint filed by citizen.', DATE_SUB(NOW(), INTERVAL 2 DAY)),
(2, 1, 'Submitted', 'Assigned', 'Assigned to Sanitation Inspector Sunita Deshmukh.', DATE_SUB(NOW(), INTERVAL 1 DAY)),

(3, 7, NULL, 'Submitted', 'Emergency water pipeline complaint logged.', DATE_SUB(NOW(), INTERVAL 5 DAY)),
(3, 1, 'Submitted', 'Assigned', 'Urgent priority assigned to Water Supply Dept.', DATE_SUB(NOW(), INTERVAL 4 DAY)),
(3, 4, 'Assigned', 'In Progress', 'Plumbing crew deployed to replace damaged connector.', DATE_SUB(NOW(), INTERVAL 3 DAY)),
(3, 4, 'In Progress', 'Resolved', 'Main valve closed, cracked PVC section replaced, water pressure restored normally.', DATE_SUB(NOW(), INTERVAL 2 DAY)),

(4, 8, NULL, 'Submitted', 'Complaint submitted by citizen.', DATE_SUB(NOW(), INTERVAL 1 DAY)),

(5, 8, NULL, 'Submitted', 'Urgent sewage overflow reported.', DATE_SUB(NOW(), INTERVAL 1 DAY)),
(5, 1, 'Submitted', 'Under Review', 'Prioritized by Administrator due to school proximity. Assigned to Drainage Superintendent Manoj Kulkarni.', NOW());
