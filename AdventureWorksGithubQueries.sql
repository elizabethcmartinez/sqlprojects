CREATE TRIGGER T_INSERT_DEPARTMENT  
ON EmployeeData  
FOR INSERT AS   
   BEGIN  
   INSERT Departments  VALUES ('Medicine')
   End;

   insert into EmployeeData values ('Elizabeth Martinez')

   select max(id) from employeedata
   select max(DepartmentID) from Departments

      select * from EmployeeData
   select * from Departments

select @@IDENTITY
select SCOPE_IDENTITY()

SELECT IDENT_CURRENT('EmployeeData') AS IdentityValue


CREATE PROCEDURE CHECKEMPLOYEEID
@EMPLOYEEID INT 
AS BEGIN 
SET NOCOUNT ON; 
DECLARE @EXISTS INT 
IF EXISTS(SELECT EMPLOYEEID FROM EMPLOYEES WHERE EMPLOYEEID = @EMPLOYEEID) 
BEGIN 
	SET @EXISTS = 1 
END 
	ELSE 
		BEGIN 
			SET @EXISTS = 0 
		END 
	RETURN @EXISTS 
END 

DECLARE @RETURNVALUE INT 
EXEC @RETURNVALUE = CHECKEMPLOYEEID 8
SELECT @RETURNVALUE

ALTER proc fetchsupplierproducts 
@p_supplierID int, 
@p_supplierName varchar(15) OUT,
@p_companyName varchar(15) OUT

as begin 
SELECT P.PRODUCTID, P.PRODUCTNAME, P.UNITPRICE 
FROM Products P 
INNER JOIN  Suppliers S 
	ON P.SupplierID = S.SupplierID 
	WHERE S.SupplierID = @p_supplierID
SELECT @p_supplierName = CONTACTNAME, @p_companyName = COMPANYNAME 
FROM SUPPLIERS
WHERE @p_supplierID = SupplierID
END

-- EXAMPLE OUTPUT PARAMETERS --

create proc spGetTotalEmployeeCountByGender 
@Gender varchar(10),
@EmployeeCount int output
AS BEGIN 
SELECT @EMPLOYEECOUNT = COUNT(ID)
FROM EMPLOYEE
WHERE GENDER = @GENDER
END 

-- OPTIONS TO PRODUCE RESULTS --

DECLARE @EMPLOYEETOTAL INT 
EXEC spGetTotalEmployeeCountByGender 'MALE', @EMPLOYEETOTAL OUT
PRINT @EMPLOYEETOTAL 
IF (@EMPLOYEETOTAL IS NULL)
PRINT '@EMPLOYEETOTAL IS NULL'
ELSE 
PRINT '@EMPLOYEETOTAL IS NOT NULL'


DECLARE @EMPLOYEETOTAL INT 
EXEC spGetTotalEmployeeCountByGender @EMPLOYEECOUNT = @EMPLOYEETOTAL OUT, 
@GENDER = 'MALE'
PRINT @EMPLOYEETOTAL 


DECLARE @EMPLOYEETOTAL INT 
EXEC spGetTotalEmployeeCountByGender 'MALE', @EMPLOYEETOTAL OUT
PRINT @EMPLOYEETOTAL 

-- EXAMPLE SP WITH DEFAULT VALUES -- 
CREATE PROCEDURE SPADDNUMBERS
@NO1 INT = 100,
@NO2 INT 
AS BEGIN 
	DECLARE @RESULT INT 
	SET @RESULT = @NO1 + @NO2
PRINT 'THE SUM OF THE 2 NUMBERS IS: ' + CAST(@RESULT AS VARCHAR) 
END 

EXEC SPADDNUMBERS @NO2 = 25
--OR
EXEC SPADDNUMBERS @NO1 = DEFAULT, @NO2 = 25

-- CASE WHEN EXAMPLE -- 
SELECT [MIDDLE NAME], EMPLOYEEID 
FROM table0 
ORDER BY  
CASE WHEN [MIDDLE NAME] IS NULL 
THEN 1 
ELSE 0 
END, [middle name], employeeid DESC;

CREATE TABLE Employee
(
  ID INT PRIMARY KEY,
  Name VARCHAR(50),
  Gender VARCHAR(50),
  DOB DATETIME,
  DeptID INT
)
GO
INSERT INTO Employee VALUES(1, 'Pranaya', 'Male','1996-02-29 10:53:27.060', 1)
INSERT INTO Employee VALUES(2, 'Priyanka', 'Female','1995-05-25 10:53:27.060', 2)
INSERT INTO Employee VALUES(3, 'Anurag', 'Male','1995-04-19 10:53:27.060', 2)
INSERT INTO Employee VALUES(4, 'Preety', 'Female','1996-03-17 10:53:27.060', 3)
INSERT INTO Employee VALUES(5, 'Sambit', 'Male','1997-01-15 10:53:27.060', 1)
INSERT INTO Employee VALUES(6, 'Hina', 'Female','1995-07-12 10:53:27.060', 2)
GO

-- count the number of employees in the table using the output parameter 
create proc spTotalCountEmployee1
@totalcount int output 
as
begin 
	select @totalcount = count(ID) from Employee
end 

declare @employeetotal INT 
EXEC spTotalCountEmployee1 @EMPLOYEETOTAL OUT
PRINT @EMPLOYEETOTAL 

-- COUNT THE NUMBER OF EMPLOYEES USING RETURN STATUS 

ALTER PROC SPTOTALCOUNTEMPLOYEE2 
AS BEGIN 
	RETURN (SELECT COUNT(ID) FROM Employee) 
	END 

	DECLARE @TOTALCOUNT2 INT 
	EXEC @TOTALCOUNT2 = SPTOTALCOUNTEMPLOYEE2 
	PRINT @TOTALCOUNT2

-- TAKE THE ID OF AN EMPLOYEE AND RETURN THEIR NAME WITH OUTPUT PARAMETER

ALTER PROC SPEMPLOYEEID
	@ID INT,
	@NAME VARCHAR(15) OUTPUT
	AS BEGIN 
	SELECT @NAME = NAME FROM EMPLOYEE 
	WHERE ID = @ID END 

	DECLARE @EMPLOYEEINFO VARCHAR(15)
	EXEC SPEMPLOYEEID 1, @EMPLOYEEINFO OUT
	PRINT 'THE NAME IS: ' + @EMPLOYEEINFO

-- Three ship countries with the highest average freight overall, 
-- in descending order by average freight
SELECT ShipCountry, ORDERDATE FROM ORDERS 
WHERE YEAR(ORDERDATE) = 1997

select Top 3 ShipCountry, AVG(Freight) AS   AverageFreight
from Orders
where YEAR(OrderDate) = 1997
group by ShipCountry
order by AVG(Freight) DESC;

--What is the OrderID of the order that the (incorrect) answer BELOW is missing?
Select Top 3  ShipCountry, AverageFreight = avg(freight)
From Orders Where OrderDate between '1/1/1997' and '12/31/1997'
Group By ShipCountry
Order By AverageFreight desc;

--SOLUTION: THE ORDERID OF THE ORDER THAT THE INCORRECT ANSWER ABOVE IS MISSING
SELECT ORDERID, FREIGHT, SHIPCOUNTRY
FROM ORDERS
WHERE YEAR(ORDERDATE) = 1997
AND 
ORDERID NOT IN 
(SELECT ORDERID FROM ORDERS WHERE ORDERDATE BETWEEN '1/1/1997' AND '12/31/1997');

select ORDERDATE, FREIGHT from orders 
WHERE YEAR(ORDERDATE) = 1997 
order by OrderDate

SELECT ORDERDATE, FREIGHT
FROM ORDERS
Where OrderDate between '1/1/1997' and '12/31/1997'

-- Get 3 ship countries with highest AVG freight charges. 
-- Use last 12 months of order data, using as the end date, the last OrderDate in Orders.

SELECT TOP 3 SHIPCOUNTRY, AVG(FREIGHT) AS AVERAGEFREIGHT 
FROM Orders
WHERE ORDERDATE 
BETWEEN 
	DATEADD(YY, -1, (SELECT MAX(ORDERDATE) FROM ORDERS))
	 and 
    (Select Max(OrderDate) from Orders)
GROUP BY ShipCountry
ORDER BY AVERAGEFREIGHT DESC


SELECT MAX(ORDERDATE) FROM ORDERS
-- ADD 10 DAYS TO SPECIFIED FIELD DATE 
SELECT DATEADD(DD, 10, '1996-12-01')
--SUBTRACT 1 DAY 
SELECT DATEADD(DD, -1, '1996-12-01')
--SUBTRACT 3 YEARS
SELECT DATEADD(YY, -3, '1996-12-01')
--ADD 4 MONTHS 
SELECT DATEADD(MM, 4, '1996-12-02')
--ADD 2 HOURS 
SELECT DATEADD(HH, 2, '1996-12-12')
--SUBTRACT 120 MIN
SELECT DATEADD(MI, -120, '1996-12-12')

SELECT * FROM ORDERS
SELECT * FROM PRODUCTS
SELECT * FROM Employees
SELECT * FROM [Order Details]

SELECT ORDERS.EMPLOYEEID, Employees.LASTNAME, Orders.ORDERID, 
Products.PRODUCTNAME, [Order Details].QUANTITY
FROM ORDERS
LEFT JOIN EMPLOYEES ON ORDERS.EMPLOYEEID = EMPLOYEES.EMPLOYEEID
LEFT JOIN [ORDER DETAILS] ON ORDERS.ORDERID = [ORDER DETAILS].OrderID 
LEFT JOIN Products ON [Order Details].ProductID = Products.ProductID
ORDER BY 
Orders.OrderID, Products.ProductID

select  O.EmployeeID, E.LastName, O.OrderID, P.ProductName, OD.Quantity
from Employees AS E, Orders AS O, Products AS P, [Order Details] as OD
where
O.EmployeeID = E.EmployeeID
and
OD.OrderID = O.OrderID
and
OD.ProductID = P.ProductID;

-- CUSTOMERS WHO NEVER PLACED AN ORDER 
SELECT CUSTOMERID 
FROM CUSTOMERS WHERE 
CustomerID NOT IN (SELECT DISTINCT(CUSTOMERID) FROM ORDERS)

SELECT * FROM [ORDER DETAILS]
SELECT * FROM ORDERS
SELECT * FROM Products
SELECT * FROM Employees
	
-- CUSTOMERS WHO NEVER PLACED AN ORDER WITH EmployeeID 4 

SELECT CUSTOMERID 
FROM CUSTOMERS WHERE 
CustomerID NOT IN (SELECT DISTINCT(CUSTOMERID) FROM ORDERS WHERE EmployeeID = 4)

select * from customers
select * from Orders
select * from [Order Details]

-- Find 1996 orders from customers with atleast 1 order of $10,000+
-- orders table
-- customers table 
-- order details table 
select * from customers
select * from Orders
select * from [Order Details]
