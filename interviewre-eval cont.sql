CREATE TABLE employee_info (
  id int NOT NULL,
  [name] varchar(100) NOT NULL,
  email varchar(100) NOT NULL,
  department varchar(100) NOT NULL,
  salary int NOT NULL,
  DOB date NOT NULL,
  gender varchar(5) NOT NULL
)
INSERT INTO employee_info (id, [name], email, department, salary, DOB, gender) VALUES
(1, 'Karan Mehta', 'Karan@gmail.com', 'HR', 300000, '1998-05-10', 'M'),
(2, 'Rohit Sharma', 'Rohit@gmail.com', 'Admin', 75000, '1997-01-25', 'M'),
(3, 'Ankush Rajput', 'Ankush@gmail.com', 'Accounts', 60000, '1998-02-09', 'M'),
(4, 'Priyanshi Sharma', 'Priyanshi@gmail.com', 'HR', 500000, '1998-06-15', 'F'),
(5, 'Sanket Gupta', 'Sanket@gmail.com', 'Developer', 100000, '1997-05-07', 'M'),
(6, 'Shruti Kapoor', 'Shruti@gmailcom', 'Admin', 80000, '1995-11-26', 'F'),
(7, 'Rohit Sharma', 'Rohit@gmail.com', 'Admin', 75000, '1997-01-25', 'M'),
(8, 'Sanket Gupta', 'Sanket@gmail.com', 'Developer', 100000, '1997-05-07', 'M'),
(9, 'Geet Gour', 'Geet@gmail.com', 'Tester', 17000, '1998-07-03', 'F')

--retrieve record with highest salary 
select * from employee_info where salary = 
(select max(salary) from employee_info)

-- retrieve highest salary in employee table 
select max(salary) from employee_info

-- select 2nd highest salary in employee table 
select max(salary) from employee_info 
where salary <> (select max(salary) from employee_info)

select salary from employee_info
order by salary desc 
offset 1 row fetch next 1 row only 
-- or limit 2, 1

-- select range of employees based on ID 
select * from employee_info
where id between 5 and 8 

-- return emp name, highest salary and department 
select * from sales.SalesOrderHeader
select * from sales.SalesOrderDetail

-- return salesorderid, revision #, highest product id
select soh.SalesOrderID, soh.RevisionNumber, sod.ProductID 
from sales.SalesOrderHeader soh 
inner join sales.SalesOrderDetail sod 
on soh.SalesOrderID = sod.SalesOrderID
where ProductID in (select max(ProductID) from sales.SalesOrderDetail)

select soh.SalesOrderID, soh.RevisionNumber, sod.ProductID 
from sales.SalesOrderHeader soh 
inner join sales.SalesOrderDetail sod 
on soh.SalesOrderID = sod.SalesOrderID
where ProductID in (select max(ProductID) from sales.SalesOrderDetail group by SalesOrderID)

-- provide second highest unitprice of sod 
select max(unitprice) from sales.SalesOrderDetail
where UnitPrice <> (select max(unitprice) from Sales.SalesOrderDetail)

select unitprice from Sales.SalesOrderDetail
order by UnitPrice desc
offset 1 row fetch next 1 row only 

-- find duplicate rows in table 
select salesorderid, count(SalesOrderID) as NumofTimes 
from sales.SalesOrderDetail
group by SalesOrderID
having count(SalesOrderID) > 1

select salesorderid, count(*) as NumofRepeatedRecords
from sales.SalesOrderDetail
group by SalesOrderID
having count(SalesOrderID) > 1

-- fetch the number of cardtypes under Vista 
select count(*) from sales.CreditCard
where CardType like 'Vista' 
group by CardType

-- get the current date
select getdate();

-- first 4 characters from card names 
select substring(cardtype, 1, 4) from sales.CreditCard

--create a new table which consists of data and structure copied from the other table.
-- create table newtable as select * from sales.CreditCard;

-- find IDs with unitprices between 50 and 100
select salesorderid, unitprice from sales.SalesOrderDetail
where unitprice between 50 and 100

-- find the records with cards that begin with 'C'
select * from sales.CreditCard where CardType like 'C%'

-- fetch top N records of unitprice 
select top 6 * from sales.salesorderdetail order by UnitPrice desc;

-- fetch 3rd highest unit price 
with CTE as (
select salesorderid, unitprice, ROW_NUMBER() over (order by unitprice DESC) as ThirdHighest
from sales.SalesOrderDetail) 
select * FROM CTE WHERE ThirdHighest = 3

-- query to get cardnumber not in ExpMonth 
select cardnumber, expmonth from sales.CreditCard
where expmonth not in (select ExpMonth from sales.CreditCard where ExpMonth like 3)
group by CardNumber, ExpMonth
order by ExpMonth

-- number of productid whose orderqty not between salesorderid 43659 and 43664
select count(productid), orderqty, salesorderid from sales.SalesOrderDetail
where OrderQty not in 
	(select salesorderid from sales.SalesOrderDetail where OrderQty between 43659 and 43664)
group by OrderQty, SalesOrderID

select SalesOrderID from sales.SalesOrderDetail
where SalesOrderID between 43659 and 43664

-- finding unique cardtypes 
select distinct(cardtype) from sales.CreditCard

-- finding repeated cardtypes
select cardtype, count(cardtype) from sales.CreditCard
group by cardtype
having count(cardtype) = 1

-- finding repeated cardtypes
select cardtype, count(cardtype) from sales.CreditCard
group by cardtype
having count(cardtype) > 1

-- find second highest unitprice 
select max(unitprice) from sales.SalesOrderDetail
where unitprice not in (select max(unitprice) from sales.SalesOrderDetail) 

select unitprice from sales.SalesOrderDetail
order by UnitPrice desc 
offset 1 row fetch next 1 row only