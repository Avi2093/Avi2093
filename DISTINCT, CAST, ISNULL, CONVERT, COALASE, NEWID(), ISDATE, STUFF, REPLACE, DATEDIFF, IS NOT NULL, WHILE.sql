--using miscellaneous db

--DISTINCT : It returns distinct values. If there are any duplicate rows in the table it will return duplicate values
select * from Employee
SELECT DISTINCT Name FROM Employee

SELECT COUNT(DISTINCT Name) FROM Employee

-- CAST function : It converts value in a specific datatype

SELECT CAST(25.65 AS int)
select * from Customers

select Id,Cust_Name,cast(DOB as datetime) as Convertedcolumn from Customers

--CONVERT function: It convert the value in specific datetype also it has style parameters for datetime format

select Id,Cust_Name,convert(nvarchar, DOB) as Convertedcolumn from Customers
select Id,Cust_Name,convert(nvarchar, DOB,102) as Convertedcolumn from Customers
--concatenating Id(int & Cust_Name
select Id,Cust_Name,Cust_Name +'-'+ cast(Id as nvarchar) as Cust_Name_Id from Customers


--ISNULL function: It checks for nulls & if the column value is null it will return the value of other column. It can take only two arguments(Firstname & Lastname)
select * from Person
select Isnull(Firstname,Lastname) as Name from Person

--ISNOTNULL function:


--Coalesce Function: It retrieves first non null value from a row
select Coalesce(Firstname,Lastname,Nickname) as Name from Person

--NEWID() Function: It is to create GUID(GLobal unique Identifier 16 byte bnary data type). Every time we execute newid() we get a unique Id.
select * from Customers

insert into Customers values( 10,'Shelly','1998-10-26',3,Newid(),'Shelly@gmail.com')

--ISDATE(): USed to check if the expression is valid date. Returns 1 if valid otherwise 0

select ISdate('2017-08-25')


--STUFF() Function
--It delete part of the string & insert another part into it at specified position
select Id,Cust_Name, stuff(Cust_Name,2,2,'**')as StuffedName from Customers -- Here first 2 is 2nd character and another 2 is no of character to be removed from 2nd charcter and insering '**'

--Replace() function : It replace the string value with another string value

select Gender,replace(Gender, 'ale','***')as Convertedcolmn from Customers

--DatePart: It returns datapart like if I select 2022-01-03 todays date then it will return 2
select datepart(weekday, '2022-01-03')
select dateName(weekday, '2022-01-03')

--DateDiff:It returns the difference between two dates counting either months,Day,Hours

select * from Customers
select datediff(month,'1998-10-25' ,'1996-06-21')

--To calculate the age of the Employee using Case statement,DateDiff,Dateadd

--Creating a function 
Create function CalculateAge_emp (@DOB datetime)
returns nvarchar(50)
begin

declare @tmpDate datetime, @years int,@months int, @days int
--set @DOB = '1990-11-13'
select @tmpDate =@DOB
select @years =datediff(year, @tmpDate,getdate())-
       case
	   when(month(@DOB)>month(getdate())) or
	   (month(@DOB) =month(getdate()) and Day(@DOB)>Day(getdate()))
	   Then 1 else 0
	   end
select @tmpdate =dateadd(year,@years,@tmpdate)

select @months =datediff(month,@tmpdate,getdate())-
       case
	   when day(@DOB)>day(getdate())
	   then 1 else 0
	   end
select @tmpdate = dateadd(month,@months,@tmpdate)
select @days = datediff(day,@tmpdate,getdate())
--select @years as Years,@months as Months, @days as Days       -- It is for single value 
declare @Age nvarchar(50)
set @Age =cast(@years as nvarchar(4)) +'Years' + cast(@months as nvarchar(4)) + 'Months'+ cast(@days as nvarchar(4)) +'days'
return @Age
end

select  dbo.CalculateAge_emp('1990-04-11')   --Since it is a user defined function we wil add dbo
--Now Finding out age of all the employees in Customers Table

Select *from Customers      
select Id,Cust_Name,DOB, dbo.CalculateAge_emp(DOB) as Age from Customers


Sys.dm_exec_query_stats: