-- A transitive dependency occurs when one non-prime attribute is dependent on another non-prime attribute.
-- Transitive dependency is expressing the dependency of A on C when A depends on B and B depends on C.
--  Partial dependencies are when the key is composite and some but not all of the columns of the key
-- determine another attribute. 

--employee(Eid,ename,managerid)
-- give me the Employees who are not managers

select eid as employee, managerid as manager 
from employee e
left join employee m 
on e.managerid = m.eID 
where e.managerid is null  

SELECT Eid, ename, managerid FROM EMPLOYEES 
WHERE eID not in 
   (SELECT MANAGERID FROM EMPLOYEES where MANAGERID is not null)

select * from employee where eID <> ManagerID 

select eid, ename from employee E 
left join employee M 
on E.eID = M.ManagerID 
where M.MangerID is null 

select JobTitle, BirthDate, firstname, lastname
from HumanResources.Employee E
inner join person.Person P on e.BusinessEntityID = p.BusinessEntityID


-- Retrieve the businesses who are not in OrganizationLevel 4
select * from HumanResources.Employee

select A.BusinessEntityID, A.OrganizationLevel 
from HumanResources.Employee A
Left join HumanResources.Employee B 
on A.BusinessEntityID = b.BusinessEntityID
where B.OrganizationLevel <> 4


select c.CustomerID, c.StoreID, c.TerritoryID, p.firstname, p.LastName, soh.SalesOrderID
from sales.Customer c
inner join person.Person p on p.businessentityid = c.personid
inner join sales.SalesOrderHeader as soh on soh.CustomerID = c.customerid

select * from Sales.SalesOrderHeader
select * from Sales.SalesPerson

select soh.SalesOrderID, sp.SalesQuota, sp.Bonus 
from sales.SalesOrderHeader soh
inner join sales.SalesPerson sp
on sp.BusinessEntityID = soh.salespersonid
where sp.SalesQuota <> 300000.00

-- transitive dependency: always relate to attributes outside of candidate keys 
-- partial dependency: dependencies within candidate keys or dependencies of non-candidate keys on 
-- only parts of the candidate keys rather than all components 

--partial dependencies are when a key is composite and some but not all of its columns determine 
-- another attribute 
-- When an attribute in a table depends on only a part of the primary key or composite key and
-- not the whole key 
--transitive dependency: when a non-prime attribute depends on other non-prime attributes
-- rather than depending upon the prime attributes of primary key. 

select * from Sales.SalesOrderDetail

-- Retrieve products with maximum number of order items 
select productID, max(orderqty) as MAXORDERQTY
from sales.SalesOrderDetail
group by ProductID
order by max(orderqty) desc;

select productid, orderqty from sales.SalesOrderDetail order by OrderQty desc
offset 0 rows fetch next 1 row only

select productid, orderqty from sales.SalesOrderDetail
order by OrderQty desc 
limit 0,1 -- this means select one row after zero row, to find the FIRST HIGHEST product orders

with cte as (select productID, row_number() over (order by orderqty desc) as MAXORDER_Qty from 
sales.SalesOrderDetail)
select productid from cte where MAXORDER_QTY = 1

-- Cid and Cname who have made maximum number of orders 
select cid, cname, max(orders) as max_order_num
from customers 
group by cid, cname 
order by max(orders) desc;

-- Cid and Cname who have not made any order 
select cid, cname, Oid 
from customers c 
left join orders o on c.cid = o.cid
where c.cid is null 

select businessentityid, loginid, jobtitle 
from HumanResources.Employee
where jobtitle = 'Research and Development Engineer';

select firstname, middlename, LastName, BusinessEntityID
from person.person 
where middlename like 'J'

select * from Production.ProductCostHistory
where ModifiedDate = '2003-06-17' 

--display employees who are not "Research Dev Engineers" 
select businessentityid, loginid, jobtitle 
from HumanResources.Employee
where jobtitle <> 'Research and Development Engineer';

select * from person.Person
where ModifiedDate > 'December 29, 2000'
order by ModifiedDate asc;

select * from person.Person
where ModifiedDate <> '2000-12-29'
order by ModifiedDate asc;

select * from person.Person
where ModifiedDate between '2000-12-01' and '2000-12-31'

select * from person.Person
where ModifiedDate not between '2000-12-01' and '2000-12-31'
order by ModifiedDate asc;

-- where clauses filter to include only the required rows, cutting down network traffic 
-- increase performance 

select * from humanresources.Employee

select * from HumanResources.Employee
where OrganizationLevel in (3, 4)

select * from HumanResources.Employee
where OrganizationLevel = 1

select * from HumanResources.Employee
where JobTitle = 'design engineer' and OrganizationLevel = 3

select max(SickLeaveHours), OrganizationLevel from HumanResources.Employee
group by OrganizationLevel

--print the name of distinct business IDs whose Sick hours is between 20 & 60
select distinct(businessentityid), SickLeaveHours from HumanResources.Employee
where SickLeaveHours between 20 and 60
order by SickLeaveHours desc

--find business ID whose sickleavehours are equal or greater than 40 and less than 50 or equal to
select businessentityid, SickLeaveHours from HumanResources.Employee
where SickLeaveHours >= 40 and SickLeaveHours <= 50

-- find IDs of employees whose job titles start with 'D' 
select businessentityid, JobTitle from HumanResources.Employee
where jobtitle like 'D%'

-- find record with maximum sick hours for a female 
select max(sickleavehours) as sickhours, Gender from HumanResources.Employee
where gender = 'F'
group by Gender

-- find record with maximum sick hours for a female 
select * from HumanResources.Employee where SickLeaveHours in
(select max(sickleavehours) from HumanResources.Employee where gender like 'F')

-- get nth or 3rd highest sick hours 
with cte as (select sickleavehours, gender, row_number() over (order by sickleavehours desc) AS ThirdMax 
from HumanResources.Employee) 
select * from cte where ThirdMax = 3

select sickleavehours, gender from HumanResources.Employee
order by SickLeaveHours desc 
offset 2 rows fetch next 1 row only

select min(sickleavehours) from HumanResources.employee
where sickleavehours in (select sickleavehours from HumanResources.Employee
order by SickLeaveHours desc offset 0 rows fetch next 3 rows only)

-- get the 3rd lowest sick hours, swap Desc with Asc 

select max(sickleavehours) from HumanResources.Employee 
where SickLeaveHours in (select SickLeaveHours from HumanResources.Employee
order by sickleavehours ASC offset 0 rows fetch next 3 rows only)

-- write a query to insert new employee details 
insert into HumanResources.Employee
values (123456789, adventure123, 0x957082, 4)

-- update organization level of ID 1 to organization level 2 
update HumanResources.Employee
set OrganizationLevel = 2 where BusinessEntityID = 1
-- delete where business id is one
delete from HumanResources.Employee
where BusinessEntityID = 1

-- fetch all details from employee and employeedepartment 
select * from HumanResources.Employee e
left join HumanResources.EmployeeDepartmentHistory eph
on e.BusinessEntityID = eph.BusinessEntityID

select JobTitle, Gender from HumanResources.Employee e
left join HumanResources.EmployeeDepartmentHistory eph
on e.BusinessEntityID = eph.BusinessEntityID
where Gender = 'f'

select SickLeaveHours, JobTitle, Gender from HumanResources.Employee e
left join HumanResources.EmployeeDepartmentHistory eph
on e.BusinessEntityID = eph.BusinessEntityID
where SickLeaveHours in 
(select max(sickleavehours) from HumanResources.Employee
where Gender = 'female')

-- create and drop a table 
create table jobtitleopenings
(jobID int not null, firstname varchar(10), lastname varchar(10), number int, department smallint, 
gender char(1), primary key (jobID)); 

drop table jobtitleopenings