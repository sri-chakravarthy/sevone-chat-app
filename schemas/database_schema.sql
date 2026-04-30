-- ============================================
-- Employee Management Database Schema
-- Multiple Organizations with Related Tables
-- ============================================

-- Drop database if exists and create fresh
DROP DATABASE IF EXISTS employee_management;
CREATE DATABASE employee_management;
USE employee_management;

-- ============================================
-- Table 1: Organizations
-- ============================================
CREATE TABLE organizations (
    organization_id INT PRIMARY KEY AUTO_INCREMENT,
    organization_name VARCHAR(255) NOT NULL,
    industry VARCHAR(100),
    headquarters_location VARCHAR(255),
    founded_date DATE,
    employee_count INT DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_org_name (organization_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- Table 2: Departments
-- ============================================
CREATE TABLE departments (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    organization_id INT NOT NULL,
    department_name VARCHAR(100) NOT NULL,
    department_code VARCHAR(20) UNIQUE,
    budget DECIMAL(15, 2),
    manager_id INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (organization_id) REFERENCES organizations(organization_id) ON DELETE CASCADE,
    INDEX idx_org_dept (organization_id, department_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- Table 3: Employees
-- ============================================
CREATE TABLE employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    organization_id INT NOT NULL,
    department_id INT,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(20),
    job_title VARCHAR(100),
    hire_date DATE NOT NULL,
    termination_date DATE,
    salary DECIMAL(12, 2),
    is_active BOOLEAN DEFAULT TRUE,
    date_of_birth DATE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    last_login DATETIME,
    FOREIGN KEY (organization_id) REFERENCES organizations(organization_id) ON DELETE CASCADE,
    FOREIGN KEY (department_id) REFERENCES departments(department_id) ON DELETE SET NULL,
    INDEX idx_emp_name (last_name, first_name),
    INDEX idx_emp_email (email),
    INDEX idx_emp_org (organization_id),
    INDEX idx_emp_dept (department_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- Table 4: Projects
-- ============================================
CREATE TABLE projects (
    project_id INT PRIMARY KEY AUTO_INCREMENT,
    organization_id INT NOT NULL,
    project_name VARCHAR(255) NOT NULL,
    project_code VARCHAR(50) UNIQUE,
    description TEXT,
    start_date DATE NOT NULL,
    end_date DATE,
    deadline DATETIME,
    status ENUM('planning', 'in_progress', 'on_hold', 'completed', 'cancelled') DEFAULT 'planning',
    budget DECIMAL(15, 2),
    project_manager_id INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    completed_at DATETIME,
    FOREIGN KEY (organization_id) REFERENCES organizations(organization_id) ON DELETE CASCADE,
    FOREIGN KEY (project_manager_id) REFERENCES employees(employee_id) ON DELETE SET NULL,
    INDEX idx_project_status (status),
    INDEX idx_project_org (organization_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- Table 5: Employee_Projects (Junction Table)
-- ============================================
CREATE TABLE employee_projects (
    assignment_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT NOT NULL,
    project_id INT NOT NULL,
    role VARCHAR(100),
    allocation_percentage DECIMAL(5, 2) DEFAULT 100.00,
    assigned_date DATE NOT NULL,
    removed_date DATE,
    is_active BOOLEAN DEFAULT TRUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    last_activity_date DATETIME,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON DELETE CASCADE,
    FOREIGN KEY (project_id) REFERENCES projects(project_id) ON DELETE CASCADE,
    UNIQUE KEY unique_assignment (employee_id, project_id, assigned_date),
    INDEX idx_emp_proj (employee_id, project_id),
    INDEX idx_active_assignments (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- Add foreign key for department manager
-- (After employees table is created)
-- ============================================
ALTER TABLE departments
ADD CONSTRAINT fk_dept_manager 
FOREIGN KEY (manager_id) REFERENCES employees(employee_id) ON DELETE SET NULL;

-- ============================================
-- Sample Data Insertion
-- ============================================

-- Insert Organizations
INSERT INTO organizations (organization_name, industry, headquarters_location, founded_date, employee_count) VALUES
('TechCorp Solutions', 'Technology', 'San Francisco, CA', '2010-03-15', 250),
('Global Finance Inc', 'Finance', 'New York, NY', '2005-07-22', 500),
('HealthCare Plus', 'Healthcare', 'Boston, MA', '2015-01-10', 180),
('EduTech Systems', 'Education', 'Austin, TX', '2018-09-05', 120);

-- Insert Departments
INSERT INTO departments (organization_id, department_name, department_code, budget) VALUES
(1, 'Engineering', 'ENG-001', 5000000.00),
(1, 'Product Management', 'PM-001', 2000000.00),
(1, 'Human Resources', 'HR-001', 800000.00),
(2, 'Investment Banking', 'IB-001', 10000000.00),
(2, 'Risk Management', 'RM-001', 3000000.00),
(3, 'Patient Care', 'PC-001', 4000000.00),
(3, 'Research & Development', 'RD-001', 6000000.00),
(4, 'Curriculum Development', 'CD-001', 1500000.00);

-- Insert Employees
INSERT INTO employees (organization_id, department_id, first_name, last_name, email, phone, job_title, hire_date, salary, date_of_birth, last_login) VALUES
(1, 1, 'John', 'Smith', 'john.smith@techcorp.com', '555-0101', 'Senior Software Engineer', '2020-01-15', 120000.00, '1990-05-20', '2026-04-23 14:30:00'),
(1, 1, 'Sarah', 'Johnson', 'sarah.johnson@techcorp.com', '555-0102', 'Lead Developer', '2019-03-22', 135000.00, '1988-08-15', '2026-04-24 09:15:00'),
(1, 2, 'Michael', 'Brown', 'michael.brown@techcorp.com', '555-0103', 'Product Manager', '2021-06-10', 110000.00, '1992-11-30', '2026-04-23 16:45:00'),
(1, 3, 'Emily', 'Davis', 'emily.davis@techcorp.com', '555-0104', 'HR Manager', '2018-09-05', 95000.00, '1985-03-12', '2026-04-24 08:00:00'),
(2, 4, 'David', 'Wilson', 'david.wilson@globalfinance.com', '555-0201', 'Investment Analyst', '2019-11-20', 140000.00, '1987-07-25', '2026-04-23 17:20:00'),
(2, 4, 'Jennifer', 'Martinez', 'jennifer.martinez@globalfinance.com', '555-0202', 'Senior Banker', '2017-04-15', 160000.00, '1984-12-08', '2026-04-24 10:30:00'),
(2, 5, 'Robert', 'Garcia', 'robert.garcia@globalfinance.com', '555-0203', 'Risk Analyst', '2020-08-01', 115000.00, '1991-09-18', '2026-04-23 15:00:00'),
(3, 6, 'Lisa', 'Anderson', 'lisa.anderson@healthcareplus.com', '555-0301', 'Nurse Practitioner', '2021-02-10', 85000.00, '1993-04-22', '2026-04-24 07:30:00'),
(3, 7, 'James', 'Taylor', 'james.taylor@healthcareplus.com', '555-0302', 'Research Scientist', '2019-07-15', 105000.00, '1989-10-05', '2026-04-23 13:45:00'),
(4, 8, 'Maria', 'Thomas', 'maria.thomas@edutech.com', '555-0401', 'Curriculum Designer', '2020-05-20', 75000.00, '1994-06-14', '2026-04-24 11:00:00');

-- Update department managers
UPDATE departments SET manager_id = 2 WHERE department_id = 1;
UPDATE departments SET manager_id = 3 WHERE department_id = 2;
UPDATE departments SET manager_id = 4 WHERE department_id = 3;
UPDATE departments SET manager_id = 6 WHERE department_id = 4;
UPDATE departments SET manager_id = 7 WHERE department_id = 5;

-- Insert Projects
INSERT INTO projects (organization_id, project_name, project_code, description, start_date, end_date, deadline, status, budget, project_manager_id, completed_at) VALUES
(1, 'Mobile App Redesign', 'PROJ-001', 'Complete redesign of mobile application', '2026-01-15', NULL, '2026-06-30 23:59:59', 'in_progress', 500000.00, 2, NULL),
(1, 'Cloud Migration', 'PROJ-002', 'Migrate infrastructure to cloud', '2025-10-01', '2026-03-31', '2026-03-31 23:59:59', 'completed', 800000.00, 2, '2026-03-28 16:30:00'),
(2, 'Risk Assessment System', 'PROJ-003', 'New risk assessment platform', '2026-02-01', NULL, '2026-08-31 23:59:59', 'in_progress', 1200000.00, 6, NULL),
(3, 'Patient Portal Enhancement', 'PROJ-004', 'Improve patient portal features', '2026-03-10', NULL, '2026-07-15 23:59:59', 'in_progress', 350000.00, 9, NULL),
(4, 'Online Learning Platform', 'PROJ-005', 'Build new e-learning system', '2025-09-01', '2026-02-28', '2026-02-28 23:59:59', 'completed', 600000.00, 10, '2026-02-25 14:00:00');

-- Insert Employee-Project Assignments
INSERT INTO employee_projects (employee_id, project_id, role, allocation_percentage, assigned_date, last_activity_date) VALUES
(1, 1, 'Backend Developer', 80.00, '2026-01-15', '2026-04-23 16:00:00'),
(2, 1, 'Tech Lead', 100.00, '2026-01-15', '2026-04-24 10:00:00'),
(1, 2, 'DevOps Engineer', 20.00, '2025-10-01', '2026-03-28 15:00:00'),
(2, 2, 'Project Lead', 100.00, '2025-10-01', '2026-03-28 16:30:00'),
(5, 3, 'Business Analyst', 75.00, '2026-02-01', '2026-04-23 14:30:00'),
(6, 3, 'Project Manager', 100.00, '2026-02-01', '2026-04-24 09:00:00'),
(7, 3, 'Risk Specialist', 90.00, '2026-02-01', '2026-04-23 17:00:00'),
(8, 4, 'UX Designer', 60.00, '2026-03-10', '2026-04-24 08:00:00'),
(9, 4, 'Technical Lead', 100.00, '2026-03-10', '2026-04-23 15:30:00'),
(10, 5, 'Content Developer', 100.00, '2025-09-01', '2026-02-25 14:00:00');

-- ============================================
-- Useful Views
-- ============================================

-- View: Active employees with their organization and department
CREATE VIEW v_active_employees AS
SELECT 
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS full_name,
    e.email,
    e.job_title,
    o.organization_name,
    d.department_name,
    e.hire_date,
    e.salary,
    e.last_login
FROM employees e
JOIN organizations o ON e.organization_id = o.organization_id
LEFT JOIN departments d ON e.department_id = d.department_id
WHERE e.is_active = TRUE;

-- View: Project assignments with employee details
CREATE VIEW v_project_assignments AS
SELECT 
    p.project_name,
    p.project_code,
    p.status AS project_status,
    o.organization_name,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    ep.role,
    ep.allocation_percentage,
    ep.assigned_date,
    ep.last_activity_date
FROM employee_projects ep
JOIN employees e ON ep.employee_id = e.employee_id
JOIN projects p ON ep.project_id = p.project_id
JOIN organizations o ON p.organization_id = o.organization_id
WHERE ep.is_active = TRUE;

-- ============================================
-- Sample Queries
-- ============================================

-- Query 1: Get all employees in a specific organization with their departments
-- SELECT * FROM v_active_employees WHERE organization_name = 'TechCorp Solutions';

-- Query 2: Find all projects with their assigned employees
-- SELECT * FROM v_project_assignments ORDER BY project_name, employee_name;

-- Query 3: Get employees who haven't logged in for more than 7 days
-- SELECT employee_id, full_name, email, last_login 
-- FROM v_active_employees 
-- WHERE last_login < DATE_SUB(NOW(), INTERVAL 7 DAY);

-- Query 4: Get project statistics by organization
-- SELECT 
--     o.organization_name,
--     COUNT(p.project_id) AS total_projects,
--     SUM(CASE WHEN p.status = 'completed' THEN 1 ELSE 0 END) AS completed_projects,
--     SUM(CASE WHEN p.status = 'in_progress' THEN 1 ELSE 0 END) AS active_projects,
--     SUM(p.budget) AS total_budget
-- FROM organizations o
-- LEFT JOIN projects p ON o.organization_id = p.organization_id
-- GROUP BY o.organization_id, o.organization_name;

-- Query 5: Find employees working on multiple projects
-- SELECT 
--     e.employee_id,
--     CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
--     COUNT(ep.project_id) AS project_count
-- FROM employees e
-- JOIN employee_projects ep ON e.employee_id = ep.employee_id
-- WHERE ep.is_active = TRUE
-- GROUP BY e.employee_id, e.first_name, e.last_name
-- HAVING COUNT(ep.project_id) > 1;

-- ============================================
-- Database Creation Complete
-- ============================================
SELECT 'Database created successfully!' AS status;

-- Made with Bob
