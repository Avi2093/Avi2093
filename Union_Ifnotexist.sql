--miscellaneous db

--UNION & UNION ALL

--For both to work the number,Data type & order of the column in the select statement should be same


select * from unionindiacust 
select * from unionUScust





select id,Name,Email from unionindiacust
union
select id,Name,Email from unionUScust




select id,Name,Email from unionindiacust
union all
select id,Name,Email from unionUScust


--Sorting results using Orderby // It should be used at last not in between the select statements

select * from unionindiacust 
union
select * from unionUScust
order by Name 



--IFNOTEXISTS

--Syntax

select * from Customers

if not exists (select * from Customers where Id =7)
Begin
insert into Customers values(7,'Daniel','1996-04-12','Male',3)
end