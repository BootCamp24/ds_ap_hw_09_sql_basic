-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- Link to schema: https://app.quickdatabasediagrams.com/#/d/WRsTZc
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.


CREATE TABLE "departments" (
    "dept_no" VARCHAR(5)   NOT NULL,
    "dept_name" VARCHAR(50)   NOT NULL,
    "last_updated" timestamp default localtimestamp  NOT NULL,
    CONSTRAINT "pk_departments" PRIMARY KEY (
        "dept_no"
     )
);

CREATE TABLE "employees" (
    "emp_no" INTEGER   NOT NULL,
    "emp_title" VARCHAR(6)   NOT NULL,
    "birth_date" date   NOT NULL,
    "first_name" VARCHAR(150)   NOT NULL,
    "last_name" VARCHAR(200)   NOT NULL,
    "sex" VARCHAR(2)   NOT NULL,
    "hire_date" date   NOT NULL,
    "last_updated" timestamp default localtimestamp  NOT NULL,
    CONSTRAINT "pk_employees" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "titles" (
    "title_id" VARCHAR(6)   NOT NULL,
    "title" VARCHAR(75)   NOT NULL,
    "last_updated" timestamp default localtimestamp  NOT NULL,
    CONSTRAINT "pk_titles" PRIMARY KEY (
        "title_id"
     )
);

CREATE TABLE "dept_manager" (
    "id" SERIAL   NOT NULL,
    "dept_no" VARCHAR(5)   NOT NULL,
    "empl_no" INTEGER   NOT NULL,
    "last_updated" timestamp default localtimestamp  NOT NULL,
    CONSTRAINT "pk_dept_manager" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "dept_emp" (
    "id" SERIAL   NOT NULL,
    "emp_no" INTEGER   NOT NULL,
    "dept_no" VARCHAR(5)   NOT NULL,
    "last_updated" timestamp default localtimestamp  NOT NULL,
    CONSTRAINT "pk_dept_emp" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "salaries" (
    "id" SERIAL   NOT NULL,
    "emp_no" INTEGER   NOT NULL,
    "salary" INTEGER   NOT NULL,
    "last_updated" timestamp default localtimestamp  NOT NULL,
    CONSTRAINT "pk_salaries" PRIMARY KEY (
        "id"
     )
);

ALTER TABLE "employees" ADD CONSTRAINT "fk_employees_emp_title" FOREIGN KEY("emp_title")
REFERENCES "titles" ("title_id");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_empl_no" FOREIGN KEY("empl_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "salaries" ADD CONSTRAINT "fk_salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");
-- 1.List the employee number, last name, first name, sex, and salary of each employee (2 points)
Select 
	e.emp_no,
	e.last_name,
	e.first_name,
	e.sex,
	s.salary
FROM
	employees e
	join salaries s on e.emp_no = s.emp_no
ORDER by 
	e.last_name asc,
	s.salary desc;

-- 2.List the first name, last name, and hire date for the employees who were hired in 1986

Select
	e.first_name,
	e.last_name,
	e.hire_date
from 
	employees e
Where
	EXTRACT(YEAR FROM e.hire_date) = 1986
Order by
	e.last_name asc,
	e.hire_date desc;

--3.List the manager of each department along with their department number, department name, employee number, last name, and first name 
Select 
	dm.dept_no,
	d.dept_name,
	e.emp_no,
	e.last_name,
	e.first_name
FROM
	employees e
	join  dept_manager dm on dm.empl_no = e.emp_no 
	join departments d on d.dept_no = dm.dept_no
	
ORDER by 
	dm.dept_no asc;



--4.List the department number for each employee along with that employee’s employee number, last name, first name, and department name
Select 
	de.dept_no,
	e.emp_no,
	e.last_name,
	e.first_name,
	d.dept_name
FROM
	employees e
	join  dept_emp de on de.emp_no = e.emp_no 
	join departments d on d.dept_no = de.dept_no
	
ORDER by 
	e.last_name asc,
	e.first_name asc;

--5.List first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B
Select
	e.first_name,
	e.last_name,
	e.sex
from 
	employees e
Where
	e.first_name = 'Hercules' AND 
	e.last_name LIKE 'B%'
Order by
	e.last_name asc,
	e.first_name desc;

--6 List each employee in the Sales department, including their employee number, last name, and first name
Select 
	e.emp_no,
	e.last_name,
	e.first_name,
	d.dept_name
FROM
	employees e
	join  dept_emp de on de.emp_no = e.emp_no 
	join departments d on d.dept_no = de.dept_no
Where
	dept_name = 'Sales'
ORDER by 
	e.last_name asc,
	e.first_name asc;

--7 List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name 
Select 
	e.emp_no,
	e.last_name,
	e.first_name,
	d.dept_name
FROM
	employees e
	join  dept_emp de on de.emp_no = e.emp_no 
	join departments d on d.dept_no = de.dept_no
Where
	d.dept_name IN ('Sales','Development')
ORDER by 
	e.last_name asc,
	e.first_name asc;

--8 List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name)
Select
	e.last_name,
	count(e.emp_no) as num_last_name
from 
	employees e
Group by
	e.last_name
Order by
	num_last_name desc;