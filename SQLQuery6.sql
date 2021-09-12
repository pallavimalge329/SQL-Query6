--rank() :- generate rank for the column based on certain criteria 
--dense_rank() :- generates rank without any gap.


select BusinessEntityID,Rate,
ROW_NUMBER() over(order by Rate desc) 'Series',
RANK() over (order by Rate desc) 'rank',
DENSE_RANK() over(order by Rate desc) 'WithoutGap'
from HumanResources.EmployeePayHistory

--Analytical function
 
create table empsales
(
productid int not null,
month int not null,
sales int not null
)
insert into EmpSales (productid,month,sales)
values (1,1,2000), (1,2,4500),(2,3,4800),(3,4,5600),(4,5,1500)

select * 
from empsales

--next month :- Lead() 
--or with the previous month :- Lag()

select month,sales 'Current Month',
Lead(Sales) over(order by Month) 'Next Month',
Lag(Sales) over (order by Month) 'Previous Month'
from empsales


--  >Any 
select BusinessEntityID, JobTitle,VacationHours
from HumanResources.Employee
where VacationHours>Any (select VacationHours
from HumanResources.Employee
where JobTitle='Recruiter')
order by VacationHours


--Subquery (to display departmentid for employee email address is ken0@adventure-works.com
--  tables  employeedepartmenthistory  , Person.EmailAddress
--??  on Joins |  subquery

select JobTitle, VacationHours 
from HumanResources.Employee e1
where JobTitle in('Buyer','Recruiter') and 
e1.VacationHours>(Select avg(VacationHours)
from HumanResources.Employee e2
where e1.JobTitle=e2.JobTitle
)

--Batch 

declare @rate int
select @rate=max(Rate)
from HumanResources.EmployeePayHistory
print @rate
if (@rate>120)
begin
print 'No need to revise'
end
go

-- Stored Procedures
create proc prcSales
as
begin
select * from empsales
end

exec prcSales

create proc prcMonthSales @m int
as
begin
Select *
from empsales
where month=@m
end

exec prcMonthSales 4

create proc prcEmpTitle @title varchar(20)
as
begin
select BusinessEntityID,LoginID,Gender
from HumanResources.Employee
where JobTitle=@title
end

exec prcEmpTitle 'Buyer'








