-- query to find the third or Nth highest unitprice 
select * from Sales.SalesOrderDetail

select * from sales.SalesOrderDetail
order by unitprice desc 
offset 2 rows fetch next 1 row only

with cte as (select *, ROW_NUMBER() over (order by unitprice desc) as ThirdPrice 
from sales.SalesOrderDetail) 
select * from cte where ThirdPrice = 3

-- query to find second highest unit price 
select max(unitprice) from sales.SalesOrderDetail 
where UnitPrice <> (select max(unitprice) from sales.SalesOrderDetail)
-- result is going to equal the 2nd highest unitprice  
--not in means not equal 

-- query to find duplicate row 
select SalesOrderID, count(carriertrackingnumber) from sales.SalesOrderDetail
group by salesorderid
having count(CarrierTrackingNumber) > 1

--employee(Eid,ename,managerid)
-- give me the Employees who are not managers

select ename from employee
where ename not in (select managerid from employee where managerid is not null) 

select * from sales.SalesOrderDetail

-- give salesorderid who are not specialofferID 1 

select salesorderid from sales.SalesOrderDetail
where SalesOrderID not in (select SalesOrderID from sales.SalesOrderDetail 
where SpecialOfferID = 1)

select * from sales.SalesOrderDetail
where SalesOrderID not in (select SalesOrderID from sales.SalesOrderDetail 
where SpecialOfferID = 1)
order by SpecialOfferID

select sod.SalesOrderID, CarrierTrackingNumber from sales.SalesOrderDetail sod
left join sales.SalesOrderHeader soh
on sod.SalesOrderID = soh.SalesOrderID
where sod.CarrierTrackingNumber is not null

-- display all product with salesorderID even if an order has never placed.
select * from production.product
select * from sales.SalesOrderDetail

select p.Name, p.ProductID, salesorderid from Production.Product p 
left join sales.SalesOrderDetail sod
on p.ProductID = sod.ProductID
where SalesOrderID is null;

-- display all product names with salesorderID where a sales order has never placed.
select p.name, salesorderid from Production.Product p
left join sales.SalesOrderDetail sod
on p.ProductID = sod.ProductID
where SalesOrderID is null