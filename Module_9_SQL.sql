--Module 9 SQL Challenge - EmployeesSQL
--Create Database & Import Data
/*
Background:
It’s been two weeks since you were hired as a new data engineer at Pewlett Hackard (a fictional company). Your first major task is to do a research project about people whom the company employed during the 1980s and 1990s. All that remains of the employee database from that period are six CSV files.
For this project, you’ll design the tables to hold the data from the CSV files, import the CSV files into a SQL database, and then answer questions about the data. That is, you’ll perform data modeling, data engineering, and data analysis, respectively.

Instructions:
This Challenge is divided into three parts: data modeling, data engineering, and data analysis.

Data Modeling:
Inspect the CSV files, and then sketch an Entity Relationship Diagram of the tables. To create the sketch, feel free to use a tool like QuickDBDLinks to an external site..

Data Engineering:
1. Use the provided information to create a table schema for each of the six CSV files. Be sure to do the following:
-Remember to specify the data types, primary keys, foreign keys, and other constraints.
-For the primary keys, verify that the column is unique. Otherwise, create a composite keyLinks to an external site., which takes two primary keys to uniquely identify a row.
-Be sure to create the tables in the correct order to handle the foreign keys.
2. Import each CSV file into its corresponding SQL table.

Data Analysis:
1. List the employee number, last name, first name, sex, and salary of each employee.
2. List the first name, last name, and hire date for the employees who were hired in 1986.
3. List the manager of each department along with their department number, department name, employee number, last name, and first name.
4. List the department number for each employee along with that employee’s employee number, last name, first name, and department name.
5. List first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B.
6. List each employee in the Sales department, including their employee number, last name, and first name.
7. List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name.
8. List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name).
*/

--Data Engineering: Create Database and load data
CREATE TABLE Titles (
    title_id VARCHAR   NOT NULL,
    title VARCHAR   NOT NULL,
    CONSTRAINT pk_Titles PRIMARY KEY (
        title_id
     )
);

CREATE TABLE Employees (
    emp_no INT   NOT NULL,
    emp_title_id VARCHAR   NOT NULL,
    birth_date DATE   NOT NULL,
    first_name VARCHAR   NOT NULL,
    last_name VARCHAR   NOT NULL,
    sex VARCHAR   NOT NULL,
    hire_date DATE   NOT NULL,
    CONSTRAINT pk_Employees PRIMARY KEY (
        emp_no
     )
);

CREATE TABLE Departments (
    dept_no VARCHAR   NOT NULL,
    dept_name VARCHAR   NOT NULL,
    CONSTRAINT pk_Departments PRIMARY KEY (
        dept_no
     )
);

CREATE TABLE dept_emp (
    emp_no INT   NOT NULL,
    dept_no VARCHAR   NOT NULL,
    CONSTRAINT pk_dept_emp PRIMARY KEY (
        emp_no,dept_no
     )
);

CREATE TABLE dept_manager (
    dept_no VARCHAR   NOT NULL,
    emp_no INT   NOT NULL,
    CONSTRAINT pk_dept_manager PRIMARY KEY (
        dept_no,emp_no
     )
);

CREATE TABLE Salaries (
    emp_no INT   NOT NULL,
    salary INT   NOT NULL,
    CONSTRAINT pk_Salaries PRIMARY KEY (
        emp_no
     )
);

ALTER TABLE Employees ADD CONSTRAINT fk_Employees_emp_title_id FOREIGN KEY(emp_title_id)
REFERENCES Titles (title_id);

ALTER TABLE dept_emp ADD CONSTRAINT fk_dept_emp_emp_no FOREIGN KEY(emp_no)
REFERENCES Employees (emp_no);

ALTER TABLE dept_emp ADD CONSTRAINT fk_dept_emp_dept_no FOREIGN KEY(dept_no)
REFERENCES Departments (dept_no);

ALTER TABLE dept_manager ADD CONSTRAINT fk_dept_manager_dept_no FOREIGN KEY(dept_no)
REFERENCES Departments (dept_no);

ALTER TABLE dept_manager ADD CONSTRAINT fk_dept_manager_emp_no FOREIGN KEY(emp_no)
REFERENCES Employees (emp_no);

ALTER TABLE Salaries ADD CONSTRAINT fk_Salaries_emp_no FOREIGN KEY(emp_no)
REFERENCES Employees (emp_no);


--Data Analysis:
-- 1. List the employee number, last name, first name, sex, and salary of each employee
SELECT
	e.emp_no,
	first_name,
	last_name,
	sex,
	s.salary
FROM
	Employees AS e INNER JOIN Salaries AS s ON e.emp_no = s.emp_no


-- 2. List the first name, last name, and hire date for the employees who were hired in 1986
SELECT
	first_name,
	last_name,
	hire_date
FROM
	employees
WHERE
	hire_date BETWEEN '1/1/1986' AND '12/31/1986'


-- 3. List the manager of each department along with their department number, department name, employee number, last name, and first name
SELECT
	e.first_name,
	e.last_name,
	d.dept_name,
	dm.dept_no,
	dm.emp_no
FROM
	dept_manager AS dm 
	JOIN departments AS d ON dm.dept_no = d.dept_no
	JOIN employees AS e ON dm.emp_no = e.emp_no


-- 4. List the department number for each employee along with that employee’s employee number, last name, first name, and department name
SELECT
	dm.dept_no,
	dm.emp_no,
	e.first_name,
	e.last_name,
	d.dept_name
FROM
	dept_manager AS dm
	JOIN employees AS e ON e.emp_no = dm.emp_no
	JOIN departments AS d ON d.dept_no = dm.dept_no


-- 5. List first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B
SELECT
	first_name,
	last_name,
	sex
FROM
	employees
WHERE
	first_name = 'Hercules' AND last_name LIKE 'B%'


-- 6. List each employee in the Sales department, including their employee number, last name, and first name
SELECT
	e.first_name,
	e.last_name,
	e.emp_no,
	de.dept_no
	
FROM
	dept_emp AS de
	JOIN employees AS e ON e.emp_no = de.emp_no 
	JOIN departments AS d ON d.dept_no = de.dept_no
WHERE
	de.dept_no = 'd007'


-- 7. List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name
SELECT
	e.first_name,
	e.last_name,
	e.emp_no,
	de.dept_no,
	d.dept_name
FROM
	dept_emp AS de
	JOIN employees AS e ON e.emp_no = de.emp_no 
	JOIN departments AS d ON d.dept_no = de.dept_no
WHERE
	de.dept_no = 'd007' OR de.dept_no = 'd005'
ORDER BY
	dept_name


-- 8. List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name)
SELECT
	COUNT(last_name) AS Last_Name_count,
	last_name
FROM
	employees
GROUP BY
	last_name
ORDER BY
	last_name_count DESC
