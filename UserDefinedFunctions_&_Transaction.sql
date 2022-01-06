--using miscellaneous db

--Scalar Function: It may or maynot have parameter but always return a single value. 
                   --Return value can be of any data type except for text,ntext,image,cursor & timestamp.
				   --Scalar function can be used in select & where clause.

create function CalculateAge(@DOB Date)
Returns int
as

Begin
Declare @Age int
       set @Age =DATEDIFF(year,@DOB,GETDATE()) -
      case
          when(month(@DOB)>month (getdate())) or
          (month(@DOB) =month(getdate())and day(@DOB)>day(getdate()))
       Then 1
     else 0
End
Return @Age
End

----To invoke the scalar function
select dbo.CalculateAge('1993/11/20') as age --  We need to write it as dbo.CalculateAge only than it will run 



select Id,Cust_Name, DOB,dbo.CalculateAge(DOB) as Age from Customers -- Using select
where dbo.CalculateAge(DOB)>25




select * from Customers

--Table Valued Function
--Inline table value

create function Empgrp_gender(@Gender char(6))
returns table
as
 return(select Id, Cust_Name,DOB,Gender,Department_Id
 from Customers 
 where Gender = @Gender)

 --To call the function

 select * FROM Empgrp_gender('Male')


 --SCENARIOS fetching male employees in table Customers details with Department Name of Department Table

select Id,Cust_Name,Gender,Department_Name
from Empgrp_gender('Male') e
join Department d on d.Department_Id = e.Department_Id


select * from Customers
select * from Department

--Another example of Inline Statement

create function Inline_TableSyntax()
Returns Table
as
Return (select Id,Cust_Name,DOB from Customers)

select * from Inline_TableSyntax()





--Multi-statement Table Valued Function

create function Multi_statement()
Returns @Table Table(Id int, Name char(15), DateofBirth Date)
as
Begin
insert into @Table
select Id, Cust_Name,DOB from Customers
Return
End

select * FROM Multi_statement()

update Inline_TableSyntax() set Cust_Name ='Jane' where Id =1  -- We can update table values in inline table value function but in multiline table value function it cannot be done
update Multi_statement() set Cust_Name ='Kristy' where Id =1  -- It will throw an error









select * from Customers
select * from Department

--CTE(Common Table Expression): It's a temporary result set. 
--It can only be referenced by select,insert,update,delete statement that immediately follows it(means

With EmployeeCount (Department_Id,TotalEmployees)
as
(
select Department_Id, COUNT(*) as TotalEmployees from Customers
group by Department_Id
)
select Department_Name,TotalEmployees 
from Department
join EmployeeCount
on Department.Department_Id = EmployeeCount.Department_Id
order by TotalEmployees


--Using multiple Cte

With EmployeeCount (Department_Id,TotalEmployees)
as
(
select Department_Id, COUNT(Id) as TotalEmployees from Customers
join Department
on Customers.Department_Id = Department.Department_Id
group by Department_Name),













--TRANSACTION


select * from Customers
begin transaction

Update Customers set Cust_Name = 'Elias' where Id =6
Rollback transaction
commit transaction-- Now its permanently committed

 -- now it is not updated in the database, not commited. 
--If we check Employee table from new query we wont be able to see that changes however to see the uncommitted changes use
--set transaction isolation level read uncommitted




select * from MailingAddress
select * from PhysicalAddress

--Stored procedure with transaction

create proc spUdateAddress
as
Begin
 Begin Try
     Begin Transaction
	 Update MailingAddress set City ='Phoenix' where EmpId = 1 
	 Update PhysicalAddress set City ='San Diego' where EmpId = 1 
	 Commit Transaction
	 End Try
 Begin Catch
 Rollback Transaction
 End Catch
 End

	  