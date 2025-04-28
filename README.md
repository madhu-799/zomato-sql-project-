# SQL project : data analysis for Zomato 

## Overview

This project demonstrates sql -problem solving skills through analysis of data for zomato ,a popular food delivery comapany in India .This project involves setting up a database ,importiing data ,handling nulls ,and  solving a variety of business problems using complex sql queries 

## Project structure

1) **database setup**: creation of the **zomato** database  and the required tables

2)**data import** : inserting  data into the table
      
3) **data cleaning** : handling null values and ensuring data integrity
   
4)**business poblems** : solving 20  specific business problems using sql queries

## create database

```sql 
create database zomato;
````

## create tables and import the data

```sql
--create table "customer"
if object_id ('customers','u') is not  null 
drop table customers 

create table customers 
(   
     customer_id  int primary key ,
    customer_name  varchar(25) ,
    reg_date  date
);

bulk insert customers 
from 'C:\Users\MADHU\OneDrive\Desktop\sql project 1\New folder (3)\customer.csv'
with
( 
   firstrow=2,
   fieldterminator=',',
   rowterminator='\n'
 );

--create table "deliveries"

 if object_id ('deliveries ','u') is not  null 
drop table deliveries 

create table deliveries  
(
   delivery_id	int primary key ,
   order_id	int ,
   delivery_status varchar(20),
   delivery_time time ,
   rider_id   int 

);

BULK INSERT deliveries
FROM 'C:\\Users\\MADHU\\OneDrive\\Desktop\\sql project 1\\New folder (3)\\deliveries.csv'
WITH 
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);

--create table "orders "
  if object_id ('orders  ','u') is not  null 
drop table orders 

create table orders 
(
   order_id int primary key  ,
   customer_id int,
   restaurant_id int,
   order_item  varchar(25),
   order_time  time ,
   order_date  date,
   order_status varchar(25),
   total_amount  int 
);

BULK INSERT orders 
FROM 'C:\\Users\\MADHU\\OneDrive\\Desktop\\sql project 1\\New folder (3)\\orders.csv'
WITH 
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);

--create table "restaurant"

   if object_id ('restaurant  ','u') is not  null 
drop table restaurant 

create table restaurant
(
   restraunt_id  int primary key  ,
   restaurant_in_city varchar(30),
   opening_hours varchar(25)
);

BULK INSERT restaurant
FROM 'C:\\Users\\MADHU\\OneDrive\\Desktop\\sql project 1\\New folder (3)\\restaurant_csv.csv'
WITH 
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);

--create table "rider"
    if object_id ('rider  ','u') is not  null 
drop table rider

create table rider
(
   rider_id  int primary key ,
   rider_name 	varchar(30),
   sign_up    varchar(25)
);

BULK INSERT rider
FROM 'C:\Users\MADHU\OneDrive\Desktop\sql project 1\New folder (3)\rider.csv'
WITH 
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);
````
**Businesss Problems Solved**

1. write a query to find the top 5 most frequently ordered dishes by customer called "arjun mehta"  in the last 1 year

```sql 
select * from orders
select * from customers

---join  customers and orders table 
---filter of last 1 year 
---filter 'arjun mehta'
--group by customer id ,dishes, count 

select  top 5 
	c.customer_id,
	c.customer_name,
	o.order_item as dishes ,
	count(*) as total_orders ,
	DENSE_RANK() over(order by count(*)  desc) as rank 
from orders o 
inner join customers c 
on o.customer_id=c.customer_id
where 
	o.order_date >= DATEADD(year  ,-1, cast(getdate() as date ))
	and c.customer_name='arjun mehta'
group by 
	c.customer_id,
	c.customer_name,
	o.order_item 
order by 
	c.customer_id,
	c.customer_name,
	o.order_item  desc 

````

2. popular time slots
 identify the time slots during which the  most orders are placed based on 2 hour time period 

```sql 

----1st approach 
select 
case 
	when datepart (hour , order_time) between 0 and 1 then '00:00-02:00'
	when datepart (hour ,order_time) between 2 and 4  then '02:00-04:00'
	when datepart (hour ,order_time) between 4 and 5  then '04:00-05:00'
	when datepart (hour ,order_time) between 6 and 9  then '06:00-09:00'
	when datepart (hour ,order_time) between 9 and 10  then '09:00-10:00'
	when datepart (hour ,order_time) between 10 and 11  then '10:00-11:00'
	when datepart (hour ,order_time) between 11 and 13  then '11:00-13:00'
	when datepart (hour ,order_time) between 13 and 19  then '13:00-019:00'
end  as time_slot ,
count(order_id) as order_count
from orders
group by order_time
order by order_count desc;

--2nd aproach 

select  
	cast(datepart(hour ,order_time)/2.0 as int ) *2 as start_time ,---lke suppose 22/2 -->11 *2--->22 
	cast(datepart(hour ,order_time)/2.0 as int ) *2  + 2 as end_time ,    -----22/2 -->11 *2--->22 +2--->24
	count(*) as total_orders 
from orders 
group by 
	cast(datepart(hour ,order_time)/2.0 as int ) *2 ,
	cast(datepart(hour ,order_time)/2.0 as int ) *2  + 2 
order by  
	total_orders desc;

--3rd approach with ctes

WITH slots AS (
    SELECT
           (CAST(DATEPART(HOUR, order_time) / 2.0 AS INT) * 2) AS start_time
    FROM   dbo.orders
)
SELECT
       s.start_time,
       s.start_time + 2                AS end_time,
       COUNT(*)                        AS total_orders
FROM   slots AS s
GROUP  BY s.start_time
ORDER  BY total_orders DESC;

````

3. order value analysis 
 find the average order value per customer  who has placed more than 2 orders 
,return customer_name, average order value

```sql

select 
	---o.customer_id,
	c.customer_name ,
	avg(o.total_amount) avg
from orders o
inner join customers as c 
on o.customer_id=c.customer_id
group by ----o.customer_id	
c.customer_name
having count(order_id) >2

````

4.high value customers 
 list the customers who have spent more than 300 in total on food orders ,
return customer_name  and customer_id 

```sql

select 
   c.customer_name ,
   sum(o.total_amount) as total_spent 
from orders o
inner  join customers c
on o.customer_id=c.customer_id
group by c.customer_name
having sum(o.total_amount) >300
````

5. orders without delivery 
write a query to find orders that were placed but not delivered ,
return each restaurnat name ,city , no of not deliverd orders

```sql 
select * from orders 
select * from deliveries
select * from restaurant

--1st approach 
select 
	r.restaurant_in_city,
	count(o.order_id) as  not_delivered 
from orders  o
left  join deliveries d 
on o.order_id=d.order_id
left join restaurant r
on o.restaurant_id=r.restraunt_id
where delivery_id is  null
group by r.restaurant_in_city
order by not_delivered  desc


--2nd approach by using the subquery 
select * 
from orders o
left join restaurant r 
on r.restraunt_id=o.restaurant_id
 where 
	 o.order_id not in ( select  order_id from deliveries)

````
6. restaurant revenue rankings 
rank restaurant by their total revenue from last year , 
including thier name, total revenue , rank within their city
```sql
select * from orders 
select * from restaurant

with ranking_table as (
select 
	r.restaurant_in_city ,
	sum(o.total_amount) as total_revenue ,
	row_number() over( partition by r.restaurant_in_city  order by (o.total_amount) desc) as rankings 
from orders o 
inner join restaurant r
on o.restaurant_id=r.restraunt_id
group by r.restaurant_in_city  ,o.total_amount)
----order by  r.restaurant_in_city, total_revenue desc )t

select * 
from ranking_table 
where rankings  =1
`````

7. most popular dish by city 
identify the most popular dish in each city based on the numbers of orders 

```sql
select * from orders 
select * from restaurant

select * from(
	select 
		r.restaurant_in_city,
		o.order_item  as dishes,
		count(o.order_id) as total_orders ,
		rank() over(partition by restaurant_in_city  order by count(order_id)desc )  as rankflag
	from orders o
	inner join  restaurant r 
	on o.restaurant_id=r.restraunt_id
	group by 
	restaurant_in_city,
	order_item)t 
	where rankflag =1

````
8. customer churn :
 find the customers who haven't placed an order in 2023-9-00   but did in 2023 -10-00

```sql
---find customer who has done orders in 2023-9-00 
--find the customers who  have ot orders in  2023 -10-00
--compare 1&2

select * from orders 
select * from customers

select distinct customer_id
from orders 
where year(order_date) =2023 and month(order_date) =8
except ---OR --and customer_id not in(
select distinct customer_id
from orders 
where year(order_date) =2023 and month(order_date) =9;

````

9. cancellation rate comparison 
 calculate and compare the order cancellation rate for each restaurant between 
the current month  and the previous month 

```sql
select * from orders 
select * from deliveries

---previous month 
with cancel_ratio  as
(
	select 
		o.restaurant_id,
		count(o.order_id) as total_orders ,
		count (case when d.delivery_id  is null then 1  else  0 end  ) as not_delivered 
	from orders o
	left join deliveries d
	on o.order_id=d.order_id
	where month(order_date)=8
	group by restaurant_id
) 

select 
restaurant_id,
total_orders,
not_delivered,
round(cast(not_delivered as float )/cast(total_orders as float )*100, 2)   as cancel_ratio
from cancel_ratio;

---current  month 
with cancel_ratio  as
(
	select 
		o.restaurant_id,
		count(o.order_id) as total_orders ,
		count (case when d.delivery_id  is null then 1  else  0 end  ) as not_delivered 
	from orders o
	left join deliveries d
	on o.order_id=d.order_id
	where month(order_date)=9
	group by restaurant_id
) 

select 
restaurant_id,
total_orders,
not_delivered,
round(cast(not_delivered as float )/cast(total_orders as float )*100, 2)   as cancel_ratio
from cancel_ratio;

--comapare  both the ctes 

with cancel_ratio_8  as
(
	select 
		o.restaurant_id,
		count(o.order_id) as total_orders ,
		count (case when d.delivery_id  is null then 1  else  0 end  ) as not_delivered 
	from orders o
	left join deliveries d
	on o.order_id=d.order_id
	where month(order_date)=8
	group by o.restaurant_id 
),

cancel_ratio_9  as
(
	select 
		o.restaurant_id,
		count(o.order_id) as total_orders ,
		count (case when d.delivery_id  is null then 1  else  0 end  ) as not_delivered 
	from orders o
	left join deliveries d
	on o.order_id=d.order_id
	where month(order_date)=9
	group by o.restaurant_id 
),

last_month_data  as
(
	select 
	restaurant_id,
	total_orders,
	not_delivered,
	round(cast(not_delivered as float )/cast(total_orders as float )*100, 2)   as cancel_ratio
	from cancel_ratio_8
),

current_month_data  as
(
	select 
	restaurant_id,
	total_orders,
	not_delivered,
	round(cast(not_delivered as float )/cast(total_orders as float )*100, 2)   as cancel_ratio
	from cancel_ratio_9
)

select 
	c.restaurant_id as restaurant_id ,
	c.cancel_ratio as current_month_cancel_ratio,
	l.cancel_ratio as last_month_cancel_ratio
from current_month_data as c
inner join last_month_data as l 
on c.restaurant_id =l.restaurant_id ;

`````


10. rider average delivery time 
determine each riders average delivery time 

```sql
select * from rider
select * from deliveries

select 
	 o.order_id,
	 o.order_time ,
	 d.delivery_time,
	 d.rider_id,
	 DATEDIFF(HOUR, o.order_time, d.delivery_time) AS time_difference_hours,
     DATEDIFF(MINUTE, o.order_time, d.delivery_time) AS time_difference_minutes,
	 case 
		 when d.delivery_time <o.order_time then 1440 
		 else  0
	 end as time_differnce
from orders o 
inner join deliveries  d 
on o.order_id=d.order_id
where d.delivery_status ='delivered'

````

11.monthly restaurant growth ratio 
 calculate each restaurant's growth ratio based on the total amount of delivered orders since its joining 

```sql
select * from deliveries
select * from orders

with growth_ratio as
(

	select 
		o.restaurant_id,
		format(o.order_date,'mm-yy') as months,
		count(o.order_id ) as current_month_orders ,
		lag(count(o.order_id ),1) over(partition by o.restaurant_id order by format(o.order_date,'mm-yy')) as previous_month_orders 
	from orders o
	inner join  deliveries as d  
	on o.order_id=d.order_id
	where d.delivery_status ='delivered'
	group by o.restaurant_id, format(o.order_date,'mm-yy')
	---order by o.restaurant_id,months
) 


select 
	restaurant_id,
	months,
	current_month_orders,
	previous_month_orders ,
	round (cast(current_month_orders as float )-cast(previous_month_orders as float )/cast(previous_month_orders as float )*100 ,2) as growth_ratio
from growth_ratio 
order by restaurant_id,months;


--calcualtion like 
/* last -20
current-30
current-last/last *100
30-20/20*100----> growth */

`````

12. customer segmentation :
customers into 'gold' or 'silver' groups based on  their total spending 
comapred to the average order value(adv) ,if a customer's total spending execeeds adv ,
label them as 'gold' otherwise label them as 'silver' 
write an sql query to determine each segemnts ,
total no of orders and total revenue 

```sql

---totalspending 
--avg order value 
--gold -
--silver 
--each category total no of orders and total revenue

select  
category,
sum(total_orders)as total_orders ,
sum(total_spendings)as total_revenue   
from (
	select 
		customer_id,
		sum(total_amount) as total_spendings ,
		count(order_id)as total_orders,
		case 
			when sum(total_amount) > (select avg(total_amount) as avg_value from orders ) then 'gold'
			else 'silver '
		end  as category 
	from orders 
	group by customer_id ) t 
group  by category

select 
avg(total_amount) as avg_value---154
from orders 

````

13. rider monthly earnings :
calculate each rider's total monthly earnings , assuming they earn 8% of the order amount 

```sql
select * from rider
select * from orders

select 
	d.rider_id,
	format(o.order_date,'MM')as month ,
	sum(o.total_amount) as total_revenue ,
	sum(o.total_amount)*0.08 as ride_earnings
from orders o
inner join deliveries d 
on o.order_id=d.order_id
group by d.rider_id,format(o.order_date,'MM')
order by d.rider_id,sum(o.total_amount)

````

14.rider earnings analysis :
find the number of 5-star ,4-star,3-star ratings each rider has ,
riders recevies this rating based on delivery time ,
if orders are delivered less than  15 minutes of orders recevied time the rider will get 5 star rating,
if they deliver  between 15-20 minutes they get an 4star rating,
if they deliver  after 20 minutes they get an 3star rating

```sql

select 
	rider_id,
	ratings,
	count(*) as total_ratings 
from (
----1st subquery 
	select  
		rider_id,
		delivery_time_taken,
		case 
			when delivery_time_taken <15 then '5-star'
			when delivery_time_taken between 15  and 20 then '4-star'
			else '3-star'
		end as ratings 

	from (
	---2nd subquery 
		select 
			o.order_id,
			o.order_time,
			d.delivery_time,
			d.rider_id,
			round(datediff(MINUTE,o.order_time,d.delivery_time)+
			case 
				when d.delivery_time < o.order_time then 1440 --it is 1 day=1440 minutes 
				else 0 
			end ,
			2) as delivery_time_taken 
		from orders  as o 
		inner join deliveries d 
		on o.order_id=d.order_id
		where delivery_status='delivered'
	)t
		
)t 
group by 
	rider_id,
	ratings
order by 	
	rider_id,
	ratings,
	total_ratings desc

````
15) order frequency by day :
 analyze order frequency per day in the week and 
identify the peak day for each restaurant 

``sql

SELECT *
FROM (
    SELECT 
        r.restaurant_in_city,
        FORMAT(o.order_date, 'dddd') AS day,
        COUNT(o.order_id) AS total_orders,
        RANK() OVER (PARTITION BY r.restaurant_in_city ORDER BY COUNT(o.order_id) DESC) AS rank
    FROM orders o
    INNER JOIN restaurant r ON o.restaurant_id = r.restraunt_id
    GROUP BY r.restaurant_in_city, FORMAT(o.order_date, 'dddd')
) t
WHERE rank = 1
ORDER BY restaurant_in_city, total_orders DESC;  -- ✅ ordering after final select

````

16. customer lifetime value 
calculate  the total revenue gernerated by each customer over all their orders

```sql
select 
	o.customer_id,
	c.customer_name,
	sum(o.total_amount) as total_revenue 
from orders o
inner join customers c
on o.customer_id =c.customer_id 
group by o.customer_id ,customer_name

```
17. monthly sales trends 
identify sales trends by comparing each month's of  total sales to the previous month

``sql
select 
	year(order_date) as year,
	month(order_date) as month,
	sum(total_amount)as total_sales ,
	lag(sum(total_amount),1) over(order by year(order_date),month(order_date)) as prev_month_sales

from orders
group by 
order_date,
year(order_date) 

```
18. rider effieciency :
 evaluate rider effieciency by determining average delivery times and identifying those with the lowest and highest 

```sql
with new_table as
(
	select 
		o.order_id,
		o.order_time,
		d.delivery_time,
		d.rider_id as riders_id  ,
	   DATEDIFF(MINUTE, o.order_time, d.delivery_time) AS time_difference_minutes,
		 case 
			 when d.delivery_time <o.order_time then 1440 
			 else  0
		 end as time_deliver
	from orders o 
	inner join deliveries d
	on o.order_id=d.order_id
	where d.delivery_status='delivered'
),

riders_time as 
(
	select 
		riders_id ,
		avg(time_deliver) avg_time
	from  new_table
	group by riders_id
) 
select 
min(avg_time),
max(avg_time)
from riders_time

````
19. order item popularity :
 track the popularity of specific order items over time  and identify seasonal demand rises  

```sql 
select 
order_id,
seasons,
count(order_id )as total_orders 
from (
	select *,
		month(order_date) as month,
		case 
			when month(order_date) between  4 and 6 then 'spring '
			when month(order_date) > 6 then 'summer'
			else 'winter'
		end as seasons
	from orders
)t 
group by order_id,
seasons
```

20.rank each city based on the total revenue for the last year 2023

```sql
select 
	r.restaurant_in_city,
	sum(o.total_amount )  as total_revenue ,
	rank() over(order by sum(total_amount))as city_rank
from orders o
inner join restaurant r
on o.restaurant_id=r.restraunt_id
group by restaurant_in_city 
order by city_rank 
````

