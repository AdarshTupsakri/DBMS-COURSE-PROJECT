-- Campus Placement and Recruitment Drive Management System
-- DBMS Course Project | MySQL 8.x

DROP DATABASE IF EXISTS campus_placement;
CREATE DATABASE campus_placement;
USE campus_placement;

-- ---------- DDL ----------
CREATE TABLE department (
  dept_id    INT AUTO_INCREMENT PRIMARY KEY,
  dept_name  VARCHAR(60) NOT NULL UNIQUE,
  hod_name   VARCHAR(60) NOT NULL
);

CREATE TABLE student (
  student_id   INT AUTO_INCREMENT PRIMARY KEY,
  roll_no      VARCHAR(15) NOT NULL UNIQUE,
  full_name    VARCHAR(80) NOT NULL,
  email        VARCHAR(80) NOT NULL UNIQUE,
  phone        VARCHAR(15),
  dept_id      INT NOT NULL,
  cgpa         DECIMAL(3,2) NOT NULL CHECK (cgpa BETWEEN 0 AND 10),
  backlogs     INT NOT NULL DEFAULT 0 CHECK (backlogs >= 0),
  grad_year    YEAR NOT NULL,
  is_placed    ENUM('No','Yes') NOT NULL DEFAULT 'No',
  FOREIGN KEY (dept_id) REFERENCES department(dept_id)
);

CREATE TABLE company (
  company_id    INT AUTO_INCREMENT PRIMARY KEY,
  company_name  VARCHAR(80) NOT NULL UNIQUE,
  industry      VARCHAR(50) NOT NULL,
  hr_name       VARCHAR(60) NOT NULL,
  hr_email      VARCHAR(80) NOT NULL,
  hr_phone      VARCHAR(15)
);

CREATE TABLE placement_drive (
  drive_id    INT AUTO_INCREMENT PRIMARY KEY,
  company_id  INT NOT NULL,
  drive_date  DATE NOT NULL,
  venue       VARCHAR(60) NOT NULL,
  mode        ENUM('On-campus','Off-campus','Virtual') NOT NULL,
  status      ENUM('Scheduled','Completed','Cancelled') NOT NULL DEFAULT 'Scheduled',
  FOREIGN KEY (company_id) REFERENCES company(company_id) ON DELETE CASCADE
);

CREATE TABLE job_role (
  role_id       INT AUTO_INCREMENT PRIMARY KEY,
  drive_id      INT NOT NULL,
  title         VARCHAR(60) NOT NULL,
  package_lpa   DECIMAL(5,2) NOT NULL CHECK (package_lpa > 0),
  min_cgpa      DECIMAL(3,2) NOT NULL DEFAULT 6.00,
  max_backlogs  INT NOT NULL DEFAULT 0,
  location      VARCHAR(40) NOT NULL,
  FOREIGN KEY (drive_id) REFERENCES placement_drive(drive_id) ON DELETE CASCADE
);

CREATE TABLE application (
  application_id  INT AUTO_INCREMENT PRIMARY KEY,
  student_id      INT NOT NULL,
  role_id         INT NOT NULL,
  applied_on      DATE NOT NULL,
  status          ENUM('Applied','Shortlisted','Rejected','Selected') NOT NULL DEFAULT 'Applied',
  UNIQUE (student_id, role_id),
  FOREIGN KEY (student_id) REFERENCES student(student_id) ON DELETE CASCADE,
  FOREIGN KEY (role_id)    REFERENCES job_role(role_id)  ON DELETE CASCADE
);

CREATE TABLE interview_round (
  round_id        INT AUTO_INCREMENT PRIMARY KEY,
  application_id  INT NOT NULL,
  round_no        INT NOT NULL,
  round_type      ENUM('Aptitude','Technical','HR','Group Discussion') NOT NULL,
  round_date      DATE NOT NULL,
  result          ENUM('Pending','Cleared','Failed') NOT NULL DEFAULT 'Pending',
  UNIQUE (application_id, round_no),
  FOREIGN KEY (application_id) REFERENCES application(application_id) ON DELETE CASCADE
);

CREATE TABLE offer (
  offer_id        INT AUTO_INCREMENT PRIMARY KEY,
  application_id  INT NOT NULL UNIQUE,
  offer_date      DATE NOT NULL,
  package_lpa     DECIMAL(5,2) NOT NULL CHECK (package_lpa > 0),
  joining_date    DATE,
  status          ENUM('Offered','Accepted','Declined') NOT NULL DEFAULT 'Offered',
  FOREIGN KEY (application_id) REFERENCES application(application_id) ON DELETE CASCADE
);

-- ---------- DML: sample data (min. 5 rows per table) ----------
INSERT INTO department (dept_name, hod_name) VALUES
('CSE', 'Dr. R. Menon'), ('CSE (AI & ML)', 'Dr. S. Iyer'),
('ECE', 'Dr. K. Rao'), ('Mechanical', 'Dr. P. Reddy'), ('Civil', 'Dr. A. Sharma');

INSERT INTO student (roll_no, full_name, email, phone, dept_id, cgpa, backlogs, grad_year, is_placed) VALUES
('21WU0101001','Ananya Reddy','ananya.r@woxsen.edu.in','9876500001',2,9.10,0,2026,'Yes'),
('21WU0101002','Rahul Verma','rahul.v@woxsen.edu.in','9876500002',1,8.40,0,2026,'Yes'),
('21WU0101003','Sneha Kulkarni','sneha.k@woxsen.edu.in','9876500003',1,7.60,1,2026,'No'),
('21WU0101004','Imran Shaikh','imran.s@woxsen.edu.in','9876500004',3,6.90,0,2026,'No'),
('21WU0101005','Priya Nair','priya.n@woxsen.edu.in','9876500005',2,8.80,0,2026,'No'),
('21WU0101006','Karthik Rao','karthik.r@woxsen.edu.in','9876500006',4,6.20,2,2026,'No'),
('21WU0101007','Meera Joshi','meera.j@woxsen.edu.in','9876500007',5,7.20,0,2026,'No');

INSERT INTO company (company_name, industry, hr_name, hr_email, hr_phone) VALUES
('TechNova Solutions','IT Services','Aarti Mehta','hr@technova.com','9000011111'),
('DataBridge Analytics','Analytics','Vikram Singh','talent@databridge.io','9000022222'),
('Infracore Constructions','Construction','Suresh Patil','careers@infracore.in','9000033333'),
('AutoMech Industries','Manufacturing','Neha Gupta','hr@automech.com','9000044444'),
('FinEdge Capital','Finance','Rohit Das','jobs@finedge.com','9000055555');

INSERT INTO placement_drive (company_id, drive_date, venue, mode, status) VALUES
(1,'2026-08-10','Auditorium A','On-campus','Completed'),
(2,'2026-08-24','Seminar Hall 2','On-campus','Completed'),
(3,'2026-09-05','Civil Block','On-campus','Completed'),
(4,'2026-10-15','Auditorium B','On-campus','Scheduled'),
(5,'2026-10-22','Online','Virtual','Scheduled');

INSERT INTO job_role (drive_id, title, package_lpa, min_cgpa, max_backlogs, location) VALUES
(1,'Software Engineer',6.50,7.00,0,'Hyderabad'),
(1,'Systems Analyst',5.00,6.50,1,'Pune'),
(2,'Data Analyst',8.00,8.00,0,'Bengaluru'),
(3,'Site Engineer',4.50,6.00,1,'Hyderabad'),
(4,'Design Engineer',5.50,6.50,0,'Chennai'),
(5,'Financial Analyst',9.00,8.00,0,'Mumbai');

INSERT INTO application (student_id, role_id, applied_on, status) VALUES
(1,3,'2026-08-12','Selected'),
(2,1,'2026-08-05','Selected'),
(3,2,'2026-08-06','Selected'),
(4,1,'2026-08-05','Rejected'),
(5,3,'2026-08-12','Rejected'),
(5,6,'2026-10-01','Applied'),
(7,4,'2026-08-28','Selected'),
(1,6,'2026-10-01','Applied'),
(4,2,'2026-08-06','Selected');

INSERT INTO interview_round (application_id, round_no, round_type, round_date, result) VALUES
(1,1,'Aptitude','2026-08-24','Cleared'),
(1,2,'Technical','2026-08-24','Cleared'),
(1,3,'HR','2026-08-25','Cleared'),
(2,1,'Technical','2026-08-10','Cleared'),
(2,2,'HR','2026-08-10','Cleared'),
(3,1,'Aptitude','2026-08-10','Cleared'),
(3,2,'Technical','2026-08-11','Pending'),
(4,1,'Aptitude','2026-08-10','Failed'),
(5,1,'Technical','2026-08-24','Failed');

INSERT INTO offer (application_id, offer_date, package_lpa, joining_date, status) VALUES
(1,'2026-08-27',8.00,'2027-07-01','Accepted'),
(2,'2026-08-12',6.50,'2027-07-15','Accepted'),
(7,'2026-09-10',4.50,'2027-08-01','Offered'),
(3,'2026-08-14',5.00,'2027-08-01','Declined'),
(9,'2026-08-15',5.00,'2027-08-01','Offered');

-- ---------- Queries (joins, aggregates) ----------
-- Q1: Students with their department
SELECT s.roll_no, s.full_name, d.dept_name, s.cgpa
FROM student s JOIN department d ON s.dept_id = d.dept_id
ORDER BY s.cgpa DESC;

-- Q2: Drives with company and roles on offer
SELECT c.company_name, pd.drive_date, pd.mode, jr.title, jr.package_lpa
FROM placement_drive pd
JOIN company c ON pd.company_id = c.company_id
JOIN job_role jr ON jr.drive_id = pd.drive_id
ORDER BY pd.drive_date;

-- Q3: Number of applications per company (aggregate + GROUP BY)
SELECT c.company_name, COUNT(a.application_id) AS total_applications
FROM company c
JOIN placement_drive pd ON pd.company_id = c.company_id
JOIN job_role jr ON jr.drive_id = pd.drive_id
LEFT JOIN application a ON a.role_id = jr.role_id
GROUP BY c.company_name
ORDER BY total_applications DESC;

-- Q4: Department-wise placement count and average package
SELECT d.dept_name, COUNT(DISTINCT s.student_id) AS students_with_offers,
       ROUND(AVG(o.package_lpa),2) AS avg_package_lpa
FROM offer o
JOIN application a ON o.application_id = a.application_id
JOIN student s ON a.student_id = s.student_id
JOIN department d ON s.dept_id = d.dept_id
WHERE o.status = 'Accepted'
GROUP BY d.dept_name;

-- Q5: Highest, lowest and average package overall
SELECT MAX(package_lpa) AS highest, MIN(package_lpa) AS lowest,
       ROUND(AVG(package_lpa),2) AS average
FROM offer WHERE status IN ('Offered','Accepted');

-- Q6: Eligible unplaced students for a role (CGPA and backlog criteria)
SELECT s.full_name, s.cgpa, s.backlogs, jr.title
FROM student s JOIN job_role jr
  ON s.cgpa >= jr.min_cgpa AND s.backlogs <= jr.max_backlogs	
WHERE s.is_placed = 'No' AND jr.title = 'Financial Analyst';

-- Q7: Placement percentage (subquery)
SELECT ROUND(100 * SUM(is_placed = 'Yes') / COUNT(*), 1) AS placement_percent FROM student;
SELECT * FROM department;

-- ---------- DELETE / UPDATE examples (used by the UI) ----------
-- UPDATE application SET status = 'Selected' WHERE application_id = 3;
-- DELETE FROM application WHERE application_id = 8;