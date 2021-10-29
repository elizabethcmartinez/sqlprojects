select * from purchasing.ProductVendor

-- return vendor record with maximum STANDARD PRICE 
select * from Purchasing.ProductVendor 
where StandardPrice = (select max(standardprice) from Purchasing.ProductVendor) 

select max(standardprice) from Purchasing.ProductVendor

-- return the maximum last receipt cost 
select max(lastreceiptcost) from Purchasing.ProductVendor

-- select 2nd highest last receipt cost in vendor table 
with cte as (select distinct(lastreceiptcost), row_number() over (order by lastreceiptcost desc) as SecondHighestCost
from Purchasing.ProductVendor) 
select * from cte where SecondHighestCost = 2

select max(lastreceiptcost) from Purchasing.ProductVendor
where LastReceiptCost
not in (select max(LastReceiptCost) from Purchasing.ProductVendor)
-- result is going to equal the 2nd highest LastReceiptCost 
--not in means not equal 

select lastreceiptcost from purchasing.ProductVendor
group by LastReceiptCost
order by LastReceiptCost desc
offset 1 row fetch next 1 row only

select * from Purchasing.ProductVendor

-- select range of products based on productID 

select * from Purchasing.ProductVendor
where ProductID between 1 and 100

--return productid, orderqty highest std price, averageleadtime

select pv.ProductID, averageleadtime, standardprice, OrderQty
from Purchasing.ProductVendor pv inner join Purchasing.PurchaseOrderDetail pod
on pv.ProductID = pod.ProductID
where StandardPrice in (select max(StandardPrice) from Purchasing.ProductVendor)

select pv.ProductID, averageleadtime, standardprice, OrderQty, UnitPrice
from Purchasing.ProductVendor pv inner join Purchasing.PurchaseOrderDetail pod
on pv.ProductID = pod.ProductID
where UnitPrice in (select max(UnitPrice) from Purchasing.PurchaseOrderDetail group by ProductID)

-- find the 2nd highest salary of an employee
--select max(salary) from employees 
----where salary <> (select max(salary) from employees)
--Cluster index is a type of index that sorts the data rows in the table on their key values 
--Non-clustered index stores the data at one location and indices at another location

-- find all the students, whose marks are greater than average marks
-- select students, marks from table where marks > select avg(marks) from table; 
https://www.c-sharpcorner.com/uploadfile/nipuntomar/normalization-and-its-types/

select * from HumanResources.EmployeePayHistory

--retrieve record w the highest salary 
select * from HumanResources.EmployeePayHistory
where Rate = (select max(rate) from HumanResources.EmployeePayHistory)

-- retrieve rate with highest salary
select max(Rate) from HumanResources.EmployeePayHistory

-- select 2nd highest salary in employee
select max(rate) from HumanResources.EmployeePayHistory
where Rate <> (select max(rate) from HumanResources.EmployeePayHistory)

select rate from HumanResources.EmployeePayHistory
order by rate desc 
offset 1 row fetch next 1 row only

with cte as (select rate, ROW_NUMBER() over (order by rate DESC) as SecondMaxRate from 
humanresources.employeepayhistory) 
select * from cte where secondmaxrate = 2

-- select a range of bussiness ids based on ID: Range (Between clause)
select * from HumanResources.EmployeePayHistory
where BusinessEntityID between 5 and 82

-- return ID, highest rate and payfrequency without the jobtitle designer engineer 
select ep.BusinessEntityID, rate, jobtitle 
from HumanResources.EmployeePayHistory EP
left join HumanResources.Employee E 
			on EP.BusinessEntityID = e.BusinessEntityID
where 'designer engineer' <> JobTitle and 'design engineer' <> JobTitle

-- return the highest rate, ID, jobtitle, for each organizationlevel

select * from HumanResources.Employee
select * from HumanResources.EmployeePayHistory

select ep.Rate, e.BusinessEntityID, e.JobTitle, e.OrganizationLevel
from HumanResources.Employee e 
left join HumanResources.EmployeePayHistory ep
on e.BusinessEntityID = ep.BusinessEntityID
where rate in (select max(rate) from HumanResources.EmployeePayHistory)
group by Rate, e.BusinessEntityID, JobTitle, OrganizationLevel
having e.BusinessEntityID = 1
-- having is only used on aggregates 

select * from sales.SalesOrderDetail
select * from sales.SalesOrderHeader

-- return all salesid, as well as highest totaldue and unit price from SOD and SOH 

select sod.SalesOrderID, totaldue, unitprice from sales.SalesOrderDetail sod
left join sales.SalesOrderHeader soh on sod.SalesOrderID = soh.SalesOrderID
where totaldue in (select max(totaldue) from sales.SalesOrderHeader) 
order by SalesOrderID

select salesorderid, count(specialofferid) as NumberofSpecialOffers
from sales.SalesOrderDetail
group by salesorderid
having count(specialofferid) > 1

-- records with max unit price 
select * from sales.SalesOrderDetail
where unitprice = (select max(unitprice) from sales.SalesOrderDetail)

select max(unitprice) from sales.SalesOrderDetail

select max(unitprice) from sales.SalesOrderDetail 
where unitprice <> (select max(unitprice) from sales.SalesOrderDetail)

select * from sales.SalesOrderDetail
where SpecialOfferID between 5 and 10

