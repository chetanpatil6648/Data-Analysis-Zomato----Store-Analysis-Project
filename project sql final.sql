create database project;
use project;

#Q1

CREATE TABLE Employee (
  emp_no INT NOT NULL PRIMARY KEY,
  e_name VARCHAR(60) NOT NULL,
  job VARCHAR(60) DEFAULT 'CLERK',
  mgr INT,
  hire_date DATE NOT NULL,
  sal DECIMAL(10,2) NOT NULL CHECK (sal > 0),
  comm DECIMAL(10,2),
  dept_no INT NOT NULL REFERENCES Dept(dept_no)
 );
select * from employee;

INSERT INTO Employee (emp_no, e_name, job, mgr, hire_date, sal, comm, dept_no)
VALUES
(7369, 'SMITH', 'CLERK', 7902, '1989-12-17', 800.00, NULL, 20),
(7499, 'ALLEN', 'SALESMAN', 7698, '1981-02-20', 1600.00, 300.00, 30),
(7521, 'WARD', 'SALESMAN', 7698, '1981-02-22', 1250.00, 500.00, 30),
(7566, 'JONES', 'MANAGER', 7839, '1981-04-02', 2975.00, NULL, 20),
(7654, 'MARTIN', 'SALESMAN', 7698, '1981-09-28', 1250.00, 1400.00, 30),
(7698, 'BLAKE', 'MANAGER', 7839, '1981-05-01', 2850.00, NULL, 30),
(7782, 'CLARK', 'MANAGER', 7839, '1981-06-09', 2450.00, NULL, 10),
(7788, 'SCOTT', 'ANALYST', 7566, '1987-04-19', 3000.00, NULL, 20),
(7839, 'KING', 'PRESIDENT', NULL, '1981-11-17', 5000.00, NULL, 10),
(7844, 'TURNER', 'SALESMAN', 7698, '1981-09-08', 1500.00, 0.00, 30),
(7876, 'ADAMS', 'CLERK', 7788, '1987-05-23', 1100.00, NULL, 20),
(7900, 'JAMES', 'CLERK', 7698, '1981-12-03', 950.00, NULL, 30),
(7902, 'FORD', 'ANALYST', 7566, '1981-12-03', 3000.00, NULL, 20),
(7934, 'MILLER', 'CLERK', 7782, '1982-01-23', 1300.00, NULL, 10);

select * from employee;

#Q2

CREATE TABLE Dept (
  dept_no INT PRIMARY KEY,
  d_name VARCHAR(60),
  loc VARCHAR(60)
);

INSERT INTO dept (dept_no, d_name, loc)
VALUES
(10, 'OPERATIONS', 'BOSTON'),
(20, 'RESEARCH', 'DALLAS'),
(30, 'SALES', 'CHICAGO'),
(40, 'ACCOUNTING', 'NEW YORK');

select * from dept;

#Q3
select 
	e_name,
    sal
    from employee
    where sal > 1000;

#Q4
select *
 from employee
 where hire_date < '1981-09-30';

#Q5
select
	e_name 
    from employee
    where SUBSTR(e_name, 2, 1) = 'I';

#Q6
select
 e_name,
 sal as 'salary',
 sal * 0.4  as 'Allowances',
 sal * 0.1 as 'P.F.',
 sal - ('Allowances' + 'P.F.') AS 'Net Salary'
from employee;

#Q7
SELECT
	e_name,
    job FROM Employee
    WHERE mgr IS NULL;
 
#Q8
SELECT
	e_name,
	emp_no,
    sal FROM Employee
    ORDER BY sal ASC;

#Q9
select count(distinct job) as 'Total jobs'
from employee;

#Q10
 select
	job,
    sum(sal+COALESCE(comm, 0)) as Total_payable_salary 
    from employee 
    where job = 'salesman';
 
#Q11
SELECT 
	dept_no,
    job, AVG(sal / 12) AS avg_monthly_salary 
    FROM Employee
    GROUP BY dept_no, job;
    
#Q12
select
	e.e_name,
    e.sal,
    d.d_name as deptname
    from employee e
    inner join dept d on e.dept_no = d.dept_no;
 
#Q13
CREATE TABLE Job_Grades (
  grade char(1) PRIMARY KEY,
  lowest_sal DECIMAL(10,2) NOT NULL,
  highest_sal DECIMAL(10,2) NOT NULL
);

INSERT INTO Job_Grades (grade, lowest_sal, highest_sal)
VALUES ('A', 0, 999),
       ('B', 1000, 1999),
       ('C', 2000, 2999),
       ('D', 3000, 3999),
       ('E', 4000, 5000);
       
select * from job_grades;

#Q14
SELECT
	e.e_name,
    e.sal,
    g.grade
	FROM Employee e 
    INNER JOIN job_grades g ON e.sal BETWEEN g.lowest_sal AND g.highest_sal;

#Q15
SELECT
	e.e_name AS Emp_name,
    m.e_name AS "Emp Reports to Mgr"
	FROM Employee e
	LEFT JOIN Employee m ON e.mgr=m.emp_no
	ORDER BY e.e_name;

#Q16
SELECT 
	e_name,
    sal,
    comm,
    (sal + COALESCE(comm, 0))  AS total_salary
FROM Employee;

#Q17
SELECT 
	e_name,
    sal,
    emp_no
    FROM Employee
    WHERE MOD(emp_no, 2) != 0;
    
#Q18
WITH ranked_emps AS (
    SELECT
        e.e_name,
        e.sal,
        DENSE_RANK() OVER (ORDER BY sal DESC) AS org_rank,
        DENSE_RANK() OVER (PARTITION BY dept_no ORDER BY sal DESC) AS dept_rank
    FROM Employee e
    )

#Q19
SELECT 
	e_name , 
    sal
    FROM Employee 
    ORDER BY sal DESC LIMIT 3;
    
#Q20
SELECT
	e.e_name,
    e.sal, 
    d.d_name
    FROM Employee e
	INNER JOIN Dept d ON e.dept_no=d.dept_no
	WHERE e.sal=(SELECT MAX(sal) FROM Employee a
	WHERE a.dept_no = e.dept_no);
