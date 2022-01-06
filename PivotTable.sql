


INSERT INTO products values (2,'leptop','block color accer leptop'),(3,'desktop','hp high perfermance desktop')



create database miscellaneous

CREATE TABLE Employee (Name nvarchar (max),Year int ,Sales int) 

INSERT INTO Employee  

select * from Employee
select * from Grades


--PIVOTTABLE
--It converts data from row level to column level. It convert unique value to multiple values in column

--Example1
SELECT Year, Pankaj,Rahul,Sandeep 
FROM (SELECT Name, Year, Sales FROM Employee )Tab1  
PIVOT  
(  
SUM(Sales) FOR Name IN (Pankaj,Rahul,Sandeep)) AS Tab2  
ORDER BY [Tab2].Year 
 

--we can’t provide integer value as a column name directly so we use brackets

SELECT Name, [2010],[2011],[2012] FROM   
(SELECT Name, [Year] , Sales FROM Employee )Tab1  
PIVOT  
(  
SUM(Sales) FOR [Year] IN ([2010],[2011],[2012])) AS Tab2  
ORDER BY Tab2.Name 



--Example 2
select * from Grades


SELECT * FROM (SELECT [Student],[Subject],[Marks] FROM Grades) S
PIVOT (
SUM([Marks]) FOR [Subject]
IN ([Mathematics],[Science],[Geography])
) AS P

--Example 3
--There will be limitations after creating the pivottable when we insert new values to table.This is because we did not mention the new column in the IN list of the PIVOT operator
--Each time we want to include a new column in the PIVOT, we would need to go and modify the underlying code.
 INSERT INTO Grades VALUES 
('Jacob','History',80),
('Amilee','History',90)

-- if the requirements change and now, we need to pivot students instead of the subjects, even in such a case, we would need to modify the entire query. 
--In order to avoid this, we can create something dynamic in which we can configure the columns on which we would need the PIVOT table.

--**Building a Dynamic Stored Procedure for PIVOT Tables**--

CREATE PROCEDURE DynamicPivotTable
  @ColumnToPivot  NVARCHAR(255),
  @ListToPivot    NVARCHAR(255)
AS
BEGIN
 
DECLARE @SqlStatement NVARCHAR(MAX)
SET @SqlStatement = N'
SELECT * FROM (SELECT [Student],[Subject],[Marks] FROM Grades) StudentResults
PIVOT (
SUM([Marks]) FOR ['+@ColumnToPivot+']
IN ('+@ListToPivot+')
) 
AS PivotTable '
 
EXEC(@SqlStatement)
END

--@ColumnToPivot = it accepts name of the column
--@ListToPivot = it accepts the list of the values

--Executing the Dynamic Stored Procedure--

EXEC DynamicPivotTable
  N'Subject'
  ,N'[Mathematics],[Science],[Geography]'

INSERT INTO Grades VALUES ('Jacob','History',80),('Amilee','History',90)--now inserting values in base table

EXEC DynamicPivotTable
  N'Subject'
  ,N'[Mathematics],[Science],[Geography],[History]'