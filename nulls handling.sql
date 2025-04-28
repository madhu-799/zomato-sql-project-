--handling nulls 
-----how to check the null values int the tables 

 select * from customers
select count(*) as customer 
from customers
where customer_id  is null
or 
 reg_date is   null
 or 
 customer_name is null 


 select * from orders
 select count(*)  from restaurant
where restraunt_id is null
or restaurant_in_city is null

---how to insert a null value into the tabes 
insert into  orders(order_id,customer_id,restaurant_id)
values(10001,2,54),
(10003,2,54),
(10004,2,56)


----how to delete nulls vlaues form the tables 
delete from orders 
where  order_item is null 
or order_date is null
or order_time is null 
or order_status is null 
or total_amount is null

---to check the nulls 
select count(*) from orders
where order_date is null