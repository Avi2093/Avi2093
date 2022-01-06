--miscellaneous db

--Partisionby clause          ref:Groupby clause as example

CREATE TABLE Orders (orderid INT,[Orderdate] DATE,[CustomerName] VARCHAR(100),[Customercity] VARCHAR(100), [Orderamount] MONEY)
select * from Orders

--Using aggregate functions to calculate the average,minimum and sum of the orderamount
SELECT Customercity, 
       AVG(Orderamount) AS AvgOrderAmount, 
       MIN(OrderAmount) AS MinOrderAmount, 
       SUM(Orderamount) TotalOrderAmount
FROM Orders
GROUP BY Customercity

--Now if we want to add another columns CustomerName and OrderAmount in output it will throw an error.
/*SELECT Customercity, CustomerName ,OrderAmount,
       AVG(Orderamount) AS AvgOrderAmount, 
       MIN(OrderAmount) AS MinOrderAmount, 
       SUM(Orderamount) TotalOrderAmount
FROM [dbo].[Orders]
GROUP BY Customercity*/

--It wont allow any column in select clause that is not part of GROUP BY clause.
---Therefore----
--We Use------


--Partition Clause--

SELECT Customercity,CustomerName,OrderAmount,
       AVG(Orderamount) OVER(PARTITION BY Customercity) AS AvgOrderAmount, 
       MIN(OrderAmount) OVER(PARTITION BY Customercity) AS MinOrderAmount, 
       SUM(Orderamount) OVER(PARTITION BY Customercity) TotalOrderAmount
FROM Orders

-------------ROW_NUMBER FUNCTION-------------

--It returns row in Sequence starting from 1
--Order by is required, Partision by is optional
--when data is partioned row number is reset to 1 when partision changes

select * from Customers


select Cust_Name,Gender,Salary,
row_number() over(order by Gender) as Rownumber
from Customers

--Scenario partition by gender

select Cust_Name,Gender,Salary,
row_number() over(partition by gender order by Gender) as Rownumber  --whenver the partition changes the data is reset to 1
from Customers 

--Deleting the duplicate rows using Cte                             --insert into Customers values(10,'Anthony','1996-06-21','Male',2,newid(),'Anthony@gmail.com',5909094)
with Customercte as
(
select Cust_Name,DOB,Gender,Department_Id,Email,
row_number()over(partition by Gender order by Gender)as RowNumber
from Customers
)
delete from Customercte where RowNumber >1