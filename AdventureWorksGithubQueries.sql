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

create procedure spGetResult
@No1 INT, 
@No2 INT, 
@Result INT OUTPUT 
as begin 
	set @Result = @No1 + @No2
end

declare @result int 
exec spGetResult 10, 20, @result output 
print @result
print 'The Result is: '+ cast(@result as varchar) 

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

-- TAKE THE ID OF AN EMPLOYEE AND RETURN THEIR NAME WITH RETURN

CREATE PROC SPEMPLOYEENAME 
@ID INT
AS BEGIN 
RETURN (SELECT NAME FROM EMPLOYEE WHERE ID = @ID) END 

DECLARE @EMPLOYEENAME VARCHAR(15)
EXEC  @EMPLOYEENAME = SPEMPLOYEENAME 1
PRINT @EMPLOYEENAME 