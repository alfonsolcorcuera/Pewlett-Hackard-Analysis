-- Creating tables

CREATE TABLE departments (
     dept_no VARCHAR NOT NULL,
     dept_name VARCHAR(40) NOT NULL,
     PRIMARY KEY (dept_no),
     UNIQUE (dept_name)
);

CREATE TABLE employees (
     emp_no INT NOT NULL,
     birth_date DATE NOT NULL,
	 first_name VARCHAR NOT NULL,
	 last_name VARCHAR NOT NULL,
	 gender VARCHAR NOT NULL,
     hire_date DATE NOT NULL,
	 PRIMARY KEY (emp_no)
);
 
CREATE TABLE dept_manager (
dept_no VARCHAR NOT NULL,
	emp_no INT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY(emp_no) REFERENCES employees(emp_no),
	FOREIGN KEY(dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE salaries (
	emp_no INT NOT NULL,
	salary INT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	PRIMARY KEY (emp_no)
);

CREATE TABLE titles (
	emp_no INT NOT NULL,
	title VARCHAR NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (emp_no) REFERENCES salaries (emp_no)
);

CREATE TABLE dept_emp(
	emp_no INT NOT NULL,
	dept_no VARCHAR(4) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	PRIMARY KEY (dept_no, emp_no)
);


-- Retrieveing employees and titles

SELECT e.emp_no, e.first_name, e.last_name, t.title, t.from_date, t.to_date
INTO retirement_titles
FROM employees as e
JOIN titles as t
ON (e.emp_no = t.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY e.emp_no ASC;

-- Use Dictinct with Orderby to remove duplicate rows

SELECT DISTINCT ON (emp_no)
emp_no, first_name, last_name, title
INTO unique_titles
FROM retirement_titles
WHERE to_date= '9999-01-01'
ORDER BY emp_no, to_date DESC;

-- Create Retiring Titles table

SELECT COUNT(*), title
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY count DESC;

-- Create a Mentorship Eligibility Table

SELECT DISTINCT ON (e.emp_no)
e.emp_no, e.first_name, e.last_name, e.birth_date, de.from_date, de.to_date, ti.title
INTO mentorship_eligibility
FROM employees as e
JOIN dept_emp as de ON (e.emp_no = de.emp_no)
JOIN titles as ti ON (e.emp_no = ti.emp_no)
WHERE (de.to_date = '9999-01-01')
AND (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY e.emp_no ASC; 

-- Obtain Total Mentorship Employees by Title

SELECT COUNT(*), title
INTO mentorship_titles
FROM mentorship_eligibility
GROUP BY title
ORDER BY count DESC;

-- Other estimations

-- Total employees
SELECT COUNT(*)
FROM employees as e
JOIN titles as ti ON e.emp_no = ti.emp_no
WHERE to_date = '9999-01-01';

-- Employees about to retire

SELECT COUNT(*)
FROM unique_titles;

-- Employees about to retire by title

SELECT * FROM retiring_titles;

-- Total employees available for mentorship
SELECT COUNT(*)
FROM mentorship_eligibility;

-- Mentorship eligibility by title

SELECT COUNT(*), title
FROM mentorship_eligibility
GROUP BY title
ORDER BY count DESC;
