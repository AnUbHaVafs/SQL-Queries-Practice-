-- TRIGGER -- SS
-- this is a block of code which will executed when a particular operation
-- is performed on the database or table . this block of code gets tirggered when 
-- particular action gets performed on table/database.

-- look at below 2 queries : one with 
-- ON DELETE SET NULL --> see below
-- ON DELETE CASCADE --> see below

CREATE TABLE client (
  client_id INT PRIMARY KEY,
  client_name VARCHAR(40),
  branch_id INT,
  FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE SET NULL --> if branch.branch_id 102 gets deleted then client.branch_id corresponds to 102 gets NULL but in case of cascade it will get removed (row will gets removed!)
);

CREATE TABLE works_with (
  emp_id INT,
  client_id INT,
  total_sales INT,
  PRIMARY KEY(emp_id, client_id),
  FOREIGN KEY(emp_id) REFERENCES employee(emp_id) ON DELETE CASCADE,
  FOREIGN KEY(client_id) REFERENCES client(client_id) ON DELETE CASCADE
);

-- find all clients who are handles by the branch that michael scott manages
--  assume you know michael's ID
SELECT client.client_name 
FROM client 
WHERE client.branch_id = (
    SELECT branch.branch_id
    FROM branch
    WHERE mgr_id = 102
    LIMIT 1
);

-- //find names of employeees who have sold over 30000 to a single client 
SELECT first_name, last_name
FROM employee
WHERE emp_id IN (
   SELECT emp_id 
   FROM works_with 
   WHERE total_sales > 30000
);


 SELECT employee.emp_id, employee.first_name, branch.branch_name
 FROM employee
 RIGHT JOIN branch --> include all the branches even the some branches foesn't have the mgr_id 
 ON employee.emp_id=branch.mgr_id;

 SELECT employee.emp_id, employee.first_name, branch.branch_name
 FROM employee
 LEFT JOIN branch --it will include all the rows of the letf table from eployee because the employee table is int the left even though the branch for them is null
 ON employee.emp_id=branch.mgr_id;

-- Join : used to comibie the rows based on the columns we get , 
--  SELECT employee.emp_id, employee.first_name, branch.branch_name
--  FROM employee
--  JOIN branch
--  ON employee.emp_id=branch.mgr_id;

-- SELECT salary 
-- FROM employee
-- UNION 
-- SELECT total_sales 
-- FROM works_with;

SELECT client_name , client.branch_id
FROM client
UNION
SELECT supplier_name, branch_supplier.branch_id
FROM branch_supplier;

-- below is equal to the above

-- SELECT client_name , branch_id
-- FROM client
-- UNION
-- SELECT supplier_name, branch_id
-- FROM branch_supplier;

SELECT first_name AS Company_Names
FROM employee
UNION
SELECT branch_name
FROM branch
UNION 
SELECT client_name
FROM client;

-- // UNION  
-- conditions :
-- both must have equal number of columns AND same data type 

-- SELECT first_name
-- FROM employee
-- UNION
-- SELECT branch_name
-- FROM branch;

-- -- fidn any client swho are in school
-- SELECT *
-- FROM client 
-- WHERE client_name LIKE '%school%';
-- SELECT *
-- FROM client;

-- -- Find any employee born in october 
-- SELECT *
-- FROM employee
-- WHERE birth_day LIKE '____-10%';

-- -- find any branch suppliers who are in label bussiness
-- SELECT *
-- FROM branch_supplier 
-- WHERE supplier_name LIKE '% Label%';

-- -- Wildcards
-- -- used to filter out the data using some patterns 
-- -- % = any no. of characters, _ = one character
-- SELECT *
-- FROM client 
-- WHERE client_name LIKE '%LLC'; --before LLC any number of characters can come 

-- -- find the total sales of each salesman 
-- SELECT SUM(total_sales), client_id
-- FROM works_with
-- GROUP BY client_id;

-- find the total number of male and female employees
-- SELECT COUNT(sex), sex
-- FROM employee
-- GROUP BY sex;

-- -- // find the average of all employees salaries
-- SELECT AVG(salary)
-- FROM employee;

-- SELECT AVG(salary)
-- FROM employee
-- WHERE sex='M';

-- SELECT SUM(salary)
-- FROM employee;

-- -- //finding number of female employees born after 1970
-- SELECT COUNT(emp_id)
-- FROM employee
-- WHERE sex='F' AND birth_day > '1971-01-01';

-- SELECT *
-- FROM employee;

-- SELECT COUNT(super_id)
-- FROM employee;

-- SELECT COUNT(emp_id)
-- FROM employee;

-- SELECT DISTINCT branch_id
-- FROM employee;

-- SELECT DISTINCT branch_id
-- FROM employee;

-- SELECT DISTINCT sex
-- FROM employee;

-- it will change the colum heading to forename and surname
SELECT first_name AS forename, last_name AS surname 
FROM employee;

SELECT first_name, last_name
FROM employee;

SELECT * 
FROM employee
ORDER BY salary;

SELECT *
FROM employee;

SELECT *
FROM branch;

SELECT *
FROM works_with;

SELECT *
FROM branch_supplier;

SELECT *
FROM client;

CREATE TABLE employee (
  emp_id INT PRIMARY KEY,
  first_name VARCHAR(40),
  last_name VARCHAR(40),
  birth_day DATE,
  sex VARCHAR(1),
  salary INT,
  super_id INT,
  branch_id INT
);

CREATE TABLE branch (
  branch_id INT PRIMARY KEY,
  branch_name VARCHAR(40),
  mgr_id INT,
  mgr_start_date DATE,
  FOREIGN KEY(mgr_id) REFERENCES employee(emp_id) ON DELETE SET NULL
);

ALTER TABLE employee
ADD FOREIGN KEY(branch_id)
REFERENCES branch(branch_id)
ON DELETE SET NULL;

ALTER TABLE employee
ADD FOREIGN KEY(super_id)
REFERENCES employee(emp_id)
ON DELETE SET NULL;

CREATE TABLE client (
  client_id INT PRIMARY KEY,
  client_name VARCHAR(40),
  branch_id INT,
  FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE SET NULL
);

CREATE TABLE works_with (
  emp_id INT,
  client_id INT,
  total_sales INT,
  PRIMARY KEY(emp_id, client_id),
  FOREIGN KEY(emp_id) REFERENCES employee(emp_id) ON DELETE CASCADE,
  FOREIGN KEY(client_id) REFERENCES client(client_id) ON DELETE CASCADE
);

CREATE TABLE branch_supplier (
  branch_id INT,
  supplier_name VARCHAR(40),
  supply_type VARCHAR(40),
  PRIMARY KEY(branch_id, supplier_name),
  FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE CASCADE
);


-- -----------------------------------------------------------------------------

-- Corporate
INSERT INTO employee VALUES(100, 'David', 'Wallace', '1967-11-17', 'M', 250000, NULL, NULL);

INSERT INTO branch VALUES(1, 'Corporate', 100, '2006-02-09');

UPDATE employee
SET branch_id = 1
WHERE emp_id = 100;

INSERT INTO employee VALUES(101, 'Jan', 'Levinson', '1961-05-11', 'F', 110000, 100, 1);

-- Scranton
INSERT INTO employee VALUES(102, 'Michael', 'Scott', '1964-03-15', 'M', 75000, 100, NULL);

INSERT INTO branch VALUES(2, 'Scranton', 102, '1992-04-06');

UPDATE employee
SET branch_id = 2
WHERE emp_id = 102;

INSERT INTO employee VALUES(103, 'Angela', 'Martin', '1971-06-25', 'F', 63000, 102, 2);
INSERT INTO employee VALUES(104, 'Kelly', 'Kapoor', '1980-02-05', 'F', 55000, 102, 2);
INSERT INTO employee VALUES(105, 'Stanley', 'Hudson', '1958-02-19', 'M', 69000, 102, 2);

-- Stamford
INSERT INTO employee VALUES(106, 'Josh', 'Porter', '1969-09-05', 'M', 78000, 100, NULL);

INSERT INTO branch VALUES(3, 'Stamford', 106, '1998-02-13');

UPDATE employee
SET branch_id = 3
WHERE emp_id = 106;

INSERT INTO employee VALUES(107, 'Andy', 'Bernard', '1973-07-22', 'M', 65000, 106, 3);
INSERT INTO employee VALUES(108, 'Jim', 'Halpert', '1978-10-01', 'M', 71000, 106, 3);


-- BRANCH SUPPLIER
INSERT INTO branch_supplier VALUES(2, 'Hammer Mill', 'Paper');
INSERT INTO branch_supplier VALUES(2, 'Uni-ball', 'Writing Utensils');
INSERT INTO branch_supplier VALUES(3, 'Patriot Paper', 'Paper');
INSERT INTO branch_supplier VALUES(2, 'J.T. Forms & Labels', 'Custom Forms');
INSERT INTO branch_supplier VALUES(3, 'Uni-ball', 'Writing Utensils');
INSERT INTO branch_supplier VALUES(3, 'Hammer Mill', 'Paper');
INSERT INTO branch_supplier VALUES(3, 'Stamford Lables', 'Custom Forms');

-- CLIENT
INSERT INTO client VALUES(400, 'Dunmore Highschool', 2);
INSERT INTO client VALUES(401, 'Lackawana Country', 2);
INSERT INTO client VALUES(402, 'FedEx', 3);
INSERT INTO client VALUES(403, 'John Daly Law, LLC', 3);
INSERT INTO client VALUES(404, 'Scranton Whitepages', 2);
INSERT INTO client VALUES(405, 'Times Newspaper', 3);
INSERT INTO client VALUES(406, 'FedEx', 2);

-- WORKS_WITH
INSERT INTO works_with VALUES(105, 400, 55000);
INSERT INTO works_with VALUES(102, 401, 267000);
INSERT INTO works_with VALUES(108, 402, 22500);
INSERT INTO works_with VALUES(107, 403, 5000);
INSERT INTO works_with VALUES(108, 403, 12000);
INSERT INTO works_with VALUES(105, 404, 33000);
INSERT INTO works_with VALUES(107, 405, 26000);
INSERT INTO works_with VALUES(102, 406, 15000);
INSERT INTO works_with VALUES(105, 406, 130000);


-- DROP TABLE student;

-- SELECT name,major
-- FROM student
-- WHERE name IN ('User 1', 'User 2', 'User 6') AND student_id <8
-- ORDER BY student_id;

-- SELECT name,major
-- FROM student
-- WHERE name IN ('User 1', 'User 2', 'User 6')--> where name is user 1...
-- ORDER BY student_id;

-- SELECT name,major
-- FROM student
-- WHERE major<>'Biology' OR name ='User 2'
-- ORDER BY student_id;

-- SELECT name,major
-- FROM student
-- WHERE major='Biology' OR name ='User 2'
-- ORDER BY student_id
-- LIMIT 2;


-- INSERT INTO student VALUES(6,'User 1', 'Biology');
-- INSERT INTO student VALUES(7,'User 2', 'Maths');
-- INSERT INTO student VALUES(8,'User 3', 'Biology');
-- INSERT INTO student VALUES(9,'User 4', 'Maths');
-- INSERT INTO student VALUES(10,'User 5', 'Science');
-- INSERT INTO student VALUES(11,'User 6', 'CS');
-- INSERT INTO student VALUES(12,'User 7', 'Physical');

-- SELECT *
-- FROM student
-- ORDER BY major,student_id DESC
-- LIMIT 1; 

-- SELECT *
-- FROM student
-- ORDER BY major,student_id DESC; 
---> this will first order the data according to major and if some rows are having
-- same major then it will order those data using student_id



-- SELECT *
-- FROM student
-- ORDER BY student_id ASC;

-- SELECT name,major
-- FROM student
-- ORDER BY student_id DESC;

-- SELECT name,major
-- FROM student
-- ORDER BY name DESC;



-- SELECT * FROM student;

-- DELETE FROM student
-- WHERE student_id = 3 AND name='Anubhav';

-- DELETE FROM student
-- WHERE student_id = 4;

-- DELETE FROM student; --> it will delete all particular rows.

-- UPDATE student 
-- SET major = 'IT', name='Ankit'
-- WHERE student_id=4;

-- UPDATE student 
-- SET major = 'CS & IT'
-- WHERE major='CS' OR major='IT';

-- UPDATE student 
-- SET major = 'CS'
-- WHERE student_id = 4;

-- UPDATE student 
-- SET major = 'CS'
-- WHERE major = 'Computer Science';




-- DROP TABLE student;
-- CREATE TABLE student(
--   student_id INT AUTO_INCREMENT,
--   name VARCHAR(20),
--   major VARCHAR(20),
--   PRIMARY KEY(student_id)
-- );

-- SELECT * FROM student;

-- INSERT INTO student(name,major) VALUES('Ankit','Computer Science');
-- INSERT INTO student(name,major) VALUES('Mayank','ME');
-- 1	Ankit	Computer Science
-- 2	Anubhav	IT

-- DROP TABLE student;
-- CREATE TABLE student(
--   student_id INT,
--   name VARCHAR(20),
--   major VARCHAR(20) DEFAULT 'undecided',
--   PRIMARY KEY(student_id)
-- );

-- SELECT * FROM student;

-- INSERT INTO student(student_id, name) VALUES(1,'Ankit');
-- 1	Ankit	undecided







-- DROP TABLE student;
-- CREATE TABLE student(
--   student_id INT,
--   name VARCHAR(20) NOT NULL,
--   major VARCHAR(20) UNIQUE,
--   PRIMARY KEY(student_id)
-- );

-- SELECT * FROM student;

-- INSERT INTO student VALUES(1,'JACK','BIOLOGY');
-- INSERT INTO student VALUES(2,'KATE','SOCIOLOGY');
-- INSERT INTO student VALUES(3,NULL,'CHEMISTRY');  -->  Column 'name' cannot be null
-- INSERT INTO student VALUES(4,'JACK','BIOLOGY'); --> --> Duplicate entry 'BIOLOGY' for key 'student.major'
-- INSERT INTO student VALUES(5,'MIKE','CS');


-- CREATE TABLE student(
--   student_id INT PRIMARY KEY,
--   name VARCHAR(20),
--   major VARCHAR(20)
-- );

-- SELECT * FROM student;

-- INSERT INTO student VALUES(5,'MARK','COMPUTER SCIENCE');
-- DROP TABLE student;
-- INSERT INTO student(student_id,name) VALUES(4,'CLAIRE');

-- INSERT INTO student VALUES(2,'KATE','SOCIOLOGY');

-- INSERT INTO student VALUES(1,'JACK','BIOLOGY');


-- DESCRIBE student;

-- DROP TABLE student;

-- ALTER TABLE student ADD gpa DECIMAL(3,2);

-- ALTER TABLE student DROP COLUMN gpa;