
------CREATING---------- 
--create database databasename
--create table tablename
------DELETING---------
--drop database databasename    (to delete the entire database
--drop table tablename    (to delete the entire table)
--How to delete entire column from table
ALTER TABLE SalesOrders
DROP COLUMN columnname

use Company---   Company is database name


-----------------------CREATE----------------------------------------
create database Company

CREATE TABLE Customers (ID int NOT NULL PRIMARY KEY, Name varchar(255) NOT NULL, Email varchar(255),Contact int, Salary nvarchar(10) NULL)

CREATE TABLE Orders (OrderID int NOT NULL PRIMARY KEY, OrderNumber int NOT NULL, CustomerID int FOREIGN KEY REFERENCES Customers(ID))

CREATE TABLE Address (Address nvarchar(255) NOT NULL, CustomerID int FOREIGN KEY REFERENCES Customers(ID) )

----------------------SELECT-------------------------------

select * from [Emp-Dept-DB].[dbo].Employees  ------  To Select Database from anywhere

select * from Orders--- to select from tablename
select * from Customers
select * from Address

---------------------INSERT--------------------------------

insert into Customers values(1,'xyz1','xyz@gm.com',8871), (2,'xyz11','xyz1@gm.com',88711)
insert into Orders values(1,101,1), (2,102,2),(3,103,3)
insert into Address values('Address1',1),('Address2',2)

----------------------DELETE--------------------------------------

DELETE FROM Address WHERE CustomerID=1 -- Deleting paticular row

ALTER TABLE tablename    -----To Delete entire column----
DROP COLUMN columnname;  --------------------------------    //Ref:https://www.sqlservertutorial.net/sql-server-basics/sql-server-delete/



exec sp_rename 'Customers.ID', 'CustomerID', 'COLUMN'; --Changing column name query
exec sp_rename 'Address.Address', 'Addresses', 'COLUMN';

------------------------------------------------------------------------------------------------------------------------------------------------

--Joining Customers and Address Table using inner join(2 tables)

SELECT Customers.Name,Customers.Email,Customers.Contact, Address.Addresses,Customers.CustomerID  --Table.Column name from both the tables
FROM Customers
INNER JOIN Address ON Customers.CustomerID = Address.CustomerID

----Joining Customers, Address & Orders Table using inner join(3 tables)

SELECT Customers.Name,Customers.Email,Customers.Contact, Address.Addresses,Orders.OrderID,Orders.OrderNumber,Customers.CustomerID  --Table.Column name from both the tables
FROM(( Customers
INNER JOIN Address ON Customers.CustomerID = Address.CustomerID)
INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID)




-- Finding the total names that are repeated in the columns// Taking example of customers Table and column Name
select* from Customers

select Name, COUNT(Name) as Totalrepeatation 
from Customers
Group by Name
order by Name Asc

-------------------------------------------------------------------------------------------------------------------------------------------

--Joining two tables (using where keyword) whose CustomerId=1

SELECT Customers.Name,Customers.Email,Customers.Contact, Address.Addresses,Customers.CustomerID  --Table.Column name from both the tables
FROM Customers
INNER JOIN Address ON Customers.CustomerID = Address.CustomerID where Customers.CustomerId=2

--Join query plus Number of customers whose address is more than 2.  --  Same customer with address more than 2

SELECT Customers.Name, COUNT(Address.CustomerID) AS NumberOfCustomers
FROM (Address
INNER JOIN Customers ON Customers.CustomerID = Address.CustomerID)
GROUP BY Name
Having COUNT(Address.CustomerID) > 2;

--HOW TO ADD NEW COLUMN TO THE TABLE

ALTER TABLE Customers
ADD Salary nvarchar (10) NULL

--------------------------------------------------------------------------------------------------------------------------------------------------------
      --UPDATE--              1) https://www.codegrepper.com/code-examples/sql/sql+replace+value+in+row   2)

--Now adding value to the newly added column

update Customers set Salary =1000 where CustomerId=1
update Customers set Salary =10000 where CustomerId=2
update Customers set Salary =100000 where CustomerId=3

--How to delete entire column from table
ALTER TABLE SalesOrders
DROP COLUMN columnname

---------------------------------------------------------------------------------------------------------------------------------------------------------

--Finding maximum salary in the Customers Table

SELECT max(Salary)
FROM Customers
--2nd max salary in customers Table
WHERE Salary < (SELECT max(Salary) FROM Customers)




----------------------------------------------------------------------------------------------------------------------------------------------------------

--Nth Highest salary in Customers table

SELECT Name, Salary 
FROM Customers e1 
WHERE 2-1 = (SELECT COUNT(DISTINCT Salary) FROM Customers e2 WHERE e2.Salary > e1.Salary) -- Here N-1 where n can be 2,3,4 
------------------------------------------------------------------------------------------------------------------------------------------------------

----------------SUBQUERY-----------
--Subquery are select statements that returns a single value and can be nested inside a select,update,insert or delete statement.
select * from products
select * from sales

--Scenario : We we have two tables writing a subquery to check which product has no sales so far

select Id, Name, Description from products
where Id not in (select  Productid from sales)


--CORELATED QUERIES: In here subquery/inner query depends on the outer query for its values
--Scenario : In here we are getting quantity of Products which are sold 

select Name,(select sum(QuantitySold) from sales where ProductId =products.Id) as Quantityofitemssold --Corelated Query "  select sum(QuantitySold) from sales where ProductId =products.Id  ". Every time we select row from outer query inner query can be executed
from products



--Create Stored Procedures

create proc spGet3rdHighestSalary
AS
Begin
SELECT Name, Salary 
FROM Customers e1 
WHERE 2-1 = (SELECT COUNT(DISTINCT Salary) FROM Customers e2 WHERE e2.Salary > e1.Salary)
End
---------------------------------------------------------------------------------------------------------------------------------------------------------

---Functions in sql server

create function AddTwoNumbers(@int1 as int, @int2 as int)
returns int
As
begin
return(@int1 +@int2)
end

--Executing the function
select dbo.AddTwoNumbers(2,5)
---------------------------------------------------------------------------------------------------------------------------------------------------------

-----------------------STORED PROCEDURE-----------------------
--Requirement
--Create a stored procedure for loan Statement.
--Inputs:
--LoanAmount
--Rate of Interest
--Tenure in Years

--O/P
--SNo  PayDate    EmiAmount
--1    Aug21,2021 yyyy
--2    Aug21,2021
--3
--.
--.
--24
--Grand Total :
-------------------------------------------------
--*********TECHNICAL SPECIFICATION DOCUMENT*************
--1)Loan Date
--2)Formula =PNR/100
--3)using above formula, we get interest
--Interest =PNR/100
--4)TotalAmount =LoanAmt+Interest
--5)EMI =Total Amount/TenureinMonths
--6)Display the data


use Ibank
go
create proc LoanStatement              --To alter it use alter proc LoanStatement
(
@LoanAmount money,
@ROI tinyint,
@TenureInYrs tinyint
)
as
begin
--Declare a Variable for Loan Date
declare @LoanDate datetime
set @LoanDate =getdate()

--Calculate Interest
--Formula =PNR/100
declare @Interest moneyewa  set @Interest =(@LoanAmount*@ROI*@TenureInYrs)/1000

--Calculate Total Amount
declare @TotalAmt money
set @TotalAmt =@LoanAmount +@Interest

--Calculate EMI Amount
declare @EMIAmt money
set @EMIAmt = (@TotalAmt/@TenureInYrs) *12

--Display the EMI Table
print '--------------------------------------------'
print 'SL No' + space(10) +'EMI Due Date'+space(10)+'EMI Amount in USD'


--LOOP SYNTAX
--start
declare @incr int
set @incr =1

--Condition
while
(@incr<(@TenureInYrs*12))
begin
print cast(@incr as varchar)+ space(10)+ cast(dateadd(mm,@incr,@LoanDate) as varchar)+space(10)+cast(@EmiAmt as varchar)

--Increment/Decrement
set @incr = @incr +1
end
print '--------------------------------------------'
print 'GrandTotal :' +space(10) +cast(@TotalAmt as varchar)
end

exec LoanStatement 500000,1,24
----------------------------------------------------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------------------------------------------------------

--SQL delete duplicate Rows using Group By and having clause //https://www.sqlshack.com/different-ways-to-sql-delete-duplicate-rows-from-a-sql-table/
--SQL delete duplicate Rows using Common Table Expressions (CTE)(FOLLOW THE LINK)
--STEP BY STEP GUIDE


--STEP1 checking the count of employee whose first_name and last_name has count of more than 1
SELECT first_name,last_name,
   
COUNT(*) AS CNT
FROM Employee
GROUP BY first_name,last_name 
HAVING COUNT(*) > 1;

select* from Employee

--STEP2 dislay the duplicate rows

SELECT *
    FROM Employee
    WHERE ID NOT IN
    (
        SELECT MAX(ID)
        FROM Employee
        GROUP BY first_name,last_name 
    );
	--STEP3 deleting it
	DELETE FROM Employee
    WHERE ID NOT IN
    (
        SELECT MAX(ID) AS MaxRecordID
        FROM Employee
        GROUP BY first_name,last_name 
    );

--------------------------------------------------------------------------------------------------------------------------------------










                






                








