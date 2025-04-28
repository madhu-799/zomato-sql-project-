# SQL project : data analysis for Zomato 

## Overview

This project demonstrates sql -problem solving skills through analysis of data for zomato ,a popular food delivery comapany in India .This project involves setting up a database ,importiing data ,handling nulls ,and  solving a variety of business problems using complex sql queries 

##Project structure

1) **database setup**: creation of the **zomato** database  and the required tables 

2)**data import** : inserting  data into the tables
   
3) **data cleaning** : handling null values and ensuring data integrity
   
4)**business poblems** : solving 20  specific business problems using sql queries

## create database
---sql 
create database zomato; 


## create tables and import the data

---sql  
**customer table**

if object_id ('customers','u') is not  null 
drop table customers 

create table customers 
(customer_id  int primary key ,
customer_name  varchar(25) ,
reg_date  date
)

bulk insert customers 
from 'C:\Users\MADHU\OneDrive\Desktop\sql project 1\New folder (3)\customer.csv'
with( firstrow=2,
fieldterminator=',',
rowterminator='\n'
 )

**deliveries table**

 if object_id ('deliveries ','u') is not  null 
drop table deliveries 

create table deliveries 
(delivery_id	int primary key ,
order_id	int ,
delivery_status varchar(20),
delivery_time time ,
rider_id   int 

)

BULK INSERT deliveries
FROM 'C:\\Users\\MADHU\\OneDrive\\Desktop\\sql project 1\\New folder (3)\\deliveries.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
)

**orders table**

  if object_id ('orders  ','u') is not  null 
drop table orders 

create table orders 
(order_id int primary key  ,
customer_id int,
restaurant_id int,
order_item  varchar(25),
order_time  time ,
order_date  date,
order_status varchar(25),
total_amount  int 
)


BULK INSERT orders 
FROM 'C:\\Users\\MADHU\\OneDrive\\Desktop\\sql project 1\\New folder (3)\\orders.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
)

**restaurant table**

   if object_id ('restaurant  ','u') is not  null 
drop table restaurant 

create table restaurant
(restraunt_id  int primary key  ,
restaurant_in_city varchar(30),
opening_hours varchar(25)

)

BULK INSERT restaurant
FROM 'C:\\Users\\MADHU\\OneDrive\\Desktop\\sql project 1\\New folder (3)\\restaurant_csv.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
)

**rider table**
    if object_id ('rider  ','u') is not  null 
drop table rider

create table rider
(rider_id  int primary key ,
rider_name 	varchar(30),
sign_up    varchar(25)
)

BULK INSERT rider
FROM 'C:\Users\MADHU\OneDrive\Desktop\sql project 1\New folder (3)\rider.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
)

-----





