-- Data Analysis of Chocolate data

# Show all the tables
show tables;

# Show data from the tables
select * from geo;
select * from people;
select * from products;
select * from sales;

# Get the amount per box in sales table
select spid,pid,SaleDate,(Amount/Boxes) as 'Amount per box' from sales;

# Show sales with amount above 10000 and in descending order
select * from sales
where Amount > 10000
order by Amount desc;

# Show details with customers in descending order
select * from sales
order by Customers desc
limit 100;

# Showing sales data for amount greater than 10000 and year 2022
select * from sales
where Amount > 10000 and year(SaleDate) = 2022
order by Amount desc;

# Showing details where boxes are between 1000 to 2000
select SPID,SaleDate,Amount,Boxes from sales
where Boxes between 1000 and 2000;

# Display the shipments that happened on Monday
select SPID,Amount,Boxes,weekday(SaleDate) as 'Day of Week' from sales
where weekday(SaleDate) = 0;

select * from people;

# Show people that are from either delish or jucies team
select Salesperson,Team from people
where Team in ('Delish','Jucies');

# Salesperson names starting from B
select Salesperson from people
where Salesperson like 'b%';

# Categorize the Amount in sales table using 'case'
select 
SaleDate, Boxes, Amount,
case when Amount < 1000 then 'Under 1k'
	 when Amount < 5000 then 'Under 5k'
     when Amount < 10000 then 'Under 10k'
     else 'Above 10k'
end as 'Amount Category'
from sales;

# Applying joins on sales and people table
select p.Salesperson, s.SaleDate, s.Amount  from
sales s inner join people p 
on s.spid = p.spid
order by s.Amount desc;

# Displaying date amount and product sold 
select s.SaleDate, s.Amount, pr.Product from
sales s inner join products pr
on s.pid = pr.pid;

# Displaying team salesperson product amount and saledate 
select p.Team, p.Salesperson, pr.Product, s.Amount, s.SaleDate 
from sales s join people p on s.spid = p.spid
join products pr on pr.pid = s.pid
order by s.Amount desc;

# Displaying team salesperson product amount and saledate where there is no team 
select p.Team, p.Salesperson, pr.Product, s.Amount, s.SaleDate 
from sales s join people p on s.spid = p.spid
join products pr on pr.pid = s.pid
where p.Team = '';

# Displaying team salesperson product amount and saledate where country is USA or Canada
select p.Team, p.Salesperson, pr.Product, s.Amount, s.SaleDate, g.geo
from sales s join people p on s.spid = p.spid
join products pr on pr.pid = s.pid
join geo g on g.GeoID = s.GeoID
where g.geo in ('USA','Canada')
and s.Amount > 1000
order by s.Amount;


-- Use of group by clause to aggregate the result or create reports

# Country wise sales report
select g.geo, sum(s.Amount) as 'Total Amount', sum(s.Boxes) as 'Total Boxes', 
avg(s.Customers) as 'Average Customers' from 
sales s join geo g on s.GeoID = g.GeoID
group by g.geo
order by 'Total Amount';

# Display top 10 products that are sold
select pr.Product, sum(s.Amount) as 'Total Amount', sum(s.Boxes) as 'Total Boxes' from
sales s join products pr on s.pid = pr.pid
group by pr.Product
order by sum(s.Amount) desc
limit 10;

# Details of shipment where amount is greater than 2000 and boxes less than 100
select * from sales
where amount > 2000 and boxes < 100
order by amount desc;

# How many shipments each salesperson had in the month of january 2022
select p.Salesperson,count(s.SPID) as 'Total Shipments'
from sales s join people p
where s.SPID = p.SPID and s.SaleDate between '2022-01-01' and '2022-01-31'
group by s.SPID
order by count(s.SPID) desc;

# Which product sell more boxes ? Milk bars or Eclairs
select p.Product,count(s.Boxes) as 'Total Boxes' from sales s join products p 
where s.PID = p.PID and s.PID in ('P01','P06')
group by s.PID;

# What are the names of salespersons who had at least 5 shipment (sale) 
# in the first 7 days of January 2022?
select p.Salesperson,count(s.SPID) as 'Total Shipments'
from sales s join people p
where s.SPID = p.SPID and s.SaleDate between '2022-01-01' and '2022-01-07'
group by s.SPID
having count(s.SPID) >= 5
order by count(s.SPID) desc;

# Which salespersons did not make any shipments in the first 7 days of January 2022?
select Salesperson from people 
where SPID not in 
(select distinct spid from sales where SaleDate between '2022-01-01' and '2022-01-07'); 

# Names of top 5 Salesperson in the month of March 2022 based on amount of sales performed
# Display Salesperson Total_Amount
select p.Salesperson,sum(s.Amount) as 'Total Amount'
from sales s join people p
where s.SPID = p.SPID and s.SaleDate between '2022-03-01' and '2022-03-31'
group by s.SPID
order by sum(s.Amount) desc
limit 5;

# How many times we shipped more than 1,000 boxes in each month?
select year(saledate) as 'Year', month(saledate) as 'Month', count(*) as 'Times we shipped 1k boxes'
from sales
where boxes>1000
group by year(saledate), month(saledate)
order by year(saledate), month(saledate);


# India or Australia? Who buys more chocolate boxes on a monthly basis?
select year(saledate) 'Year', month(saledate) 'Month',
sum(CASE WHEN g.geo='India' = 1 THEN boxes ELSE 0 END) 'India Boxes',
sum(CASE WHEN g.geo='Australia' = 1 THEN boxes ELSE 0 END) 'Australia Boxes'
from sales s
join geo g on g.GeoID=s.GeoID
group by year(saledate), month(saledate)
order by year(saledate), month(saledate);






