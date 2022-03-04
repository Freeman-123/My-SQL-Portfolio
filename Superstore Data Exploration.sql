select *
from SalesProject..Orders

--checking if row ID can be primary key
select *
from SalesProject..Orders
order by 1

--checking if order ID is a primary key or not

select [Order ID], count(*)
from SalesProject..Orders
group by [Order ID]
having count(*)>1

select *
from SalesProject..Orders
where [Order ID]= 'AE-2014-3830'

--Order ID cannot be primary key

--comparing ship date and order date

select *
from SalesProject..Orders
where [ship date]<[order date]

--All shipping dates are greater or equal with order date, so it's VALID 

--checking various shipping methods and their equivalent days

select distinct [ship mode]
from SalesProject..Orders

select min(a.Num_of_Days), max(a.Num_of_Days)
from(
select DATEDIFF(DAY, [order date], [ship date]) as Num_of_Days
from SalesProject..Orders
where [ship mode] = 'second class') a

select min(a.Num_of_Days), max(a.Num_of_Days)
from(
select DATEDIFF(DAY, [order date], [ship date]) as Num_of_Days
from SalesProject..Orders
where [ship mode] = 'first class') a

select min(a.Num_of_Days), max(a.Num_of_Days)
from(
select DATEDIFF(DAY, [order date], [ship date]) as Num_of_Days
from SalesProject..Orders
where [ship mode] = 'standard class') a

--looking  at customers that order multiple items

select [customer id], [Order id], count(*)
from SalesProject..Orders
group by [customer id],[order id]
order by [customer id]

-- The returns worksheet

select *
from SalesProject..Returns

--The market with the highest returned orders

select [market], count (*)
from SalesProject..Returns
group by [market]