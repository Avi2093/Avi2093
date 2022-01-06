--TEMPORARY TABLE : Temporary tables get created in TempDB & are automatically deleted when we close the current connection. To explicitly delete it we can use drop statement in current connection
--Local temporary table  :Start with prefix #.  We can create multiple tables with same name in different connection. There are random numbers that at suffix
--Global temporary table :Start with prefix ##. We cannot create multiple tables with same name in every connectio. It has to be unique. There are no random numbers at suffix. It is visible to all the connection
create table #TemporaryTablelocal (id int, Name char(50))

insert into #TemporaryTablelocal values(1,'David'),(2,'Shelly'),(3,'Warren')

select * from #TemporaryTablelocal



--Open new tab//NEW QUERY 
--Now if we create a temporary table inside stored procedure 
create proc spCreateLocalTemp
as
Begin
create table #TemporaryTablelocal (id int, Name char(50))

insert into #TemporaryTablelocal values(1,'David'),(2,'Shelly'),(3,'Warren')

select * from #TemporaryTablelocal

End

--Temporary table will be automatically deleted after we execute the stored procedure



--TEMPORARY VARIABLE : prefix with @Tempvariable
--All statements should be executed at once because it is stored in memory and not the database
--Syntax
Declare @TblVariable table(id int, Name varchar(20))
insert into @TblVariable values(1,'Sainik')

select * from @TblVariable






--To check the temporary tables(local + Global) present in system database we can write the below query      or  directly go to System Database=>tempdb =>Temporary Tables
select name from tempdb..sysobjects
where name like '##EmployeeDetails%'



