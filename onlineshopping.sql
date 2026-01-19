create database OnlineShoppingDB

select * from Customers

select * from Order_items

select * from Orders

select * from Payments

select * from Products
go


--q2 :returns the names and countries of customers who made orders witha total amount between �500 and �1000
select C.[name] , C.country , sum(Oi.Total_amount) as total_spent
from Customers C
Join Orders O on O.customer_id = C.customer_id
Join Order_items Oi on Oi.order_id = O.order_id
group by C.customer_id, C.[name], C.country
having sum(Oi.Total_amount) between 500 and 1000
go


--q3: Get the total amount paid by customers belonging to UK who bought at least more than three products in an order. 
select sum (P.Amount_paid) as Total_amount_paid
from payments P
where P.order_id in (
   Select O.order_id 
   From Orders O
   Join Customers C on C.customer_id = O.customer_id
   Join Order_items OI on OI.order_id = O.order_id
   Where C.country = 'UK'
   Group by O.order_id
   Having sum (OI.quantity)>3
)
go

--q4)returns the highest and second highest amount_paid from UK or Australia 
select top 2 C.[name],
max(round (P.Amount_paid * 1.122, 0)) as vat_included_amount
from Customers C
Join Orders O on O.customer_id = C.customer_id
Join Payments P on P.order_id = O.order_id
Where C.country in( 'UK' , 'Australia' )
Group by C.[name]
Order by vat_included_Amount desc

go

--q5) returns a list of the distinct product_name and the total quantity purchased for each product called as total_quantity. Sort by total_quantity
Select P.product_name, sum (OI.quantity) as total_quantity 
From products P
Join Order_items OI on OI.product_id = P.product_id
Group by P.product_name
Order by total_quantity desc
go

 --q6) procedure: Update the amount_paid of customers who purchased either laptop or smartphone as products and amount_paid>=�17000 of all orders to the discount of 5%
create procedure UpdateDiscountTechOrders
as
begin
    update P
    set P.Amount_paid = P.Amount_paid * 0.95
    from Payments P
    join Orders O on O.order_id = P.order_id
    join Customers C on C.customer_id = O.customer_id
    join Order_items Oi on Oi.order_id = O.order_id
    join Products Pr on Pr.product_id = Oi.product_id
    where Pr.product_name in ('laptop', 'smartphone') and P.Amount_paid >= 17000;
end;
go

--test

-- first i check the amount pay of products
  select P.payment_id, C.[name], PR.product_name, P.Amount_paid
  from Payments P
  join Orders O on P.order_id = O.order_id
  join Customers C on C.customer_id = O.customer_id
  join Order_items Oi on Oi.order_id = O.order_id
  join Products Pr on Pr.product_id = Oi.product_id
  where Pr.product_name in ('laptop', 'smartphone') and P.Amount_paid >=17000; -- after discount they will decrease
go
--then i execute the procedure
 exec UpdateDiscountTechOrders;

 go

 -- finally i run this part to undrestand the differents.
  select P.payment_id, C.[name], PR.product_name, P.Amount_paid
  from Payments P
  join Orders O on P.order_id = O.order_id
  join Customers C on C.customer_id = O.customer_id
  join Order_items Oi on Oi.order_id = O.order_id
  join Products Pr on Pr.product_id = Oi.product_id
  where Pr.product_name in ('laptop', 'smartphone') and P.Amount_paid >=17000; -- after discount they will decrease
go

 --q7 : some queries of my own

--7) 1 : Top 5 customers by total quantity ordered and amount spent
select top 5 C.[name], sum(Oi.quantity) as total_quantity, sum(P.Amount_paid) as total_spent
from Customers C
join Orders O on O.customer_id = C.customer_id
join Order_items Oi on Oi.order_id = O.order_id
join Payments P on P.order_id = O.order_id
group by C.customer_id, C.[name]
order by total_spent desc;
go

--7) 2: countries with customers who never placed any orders
select  country, count(*) as inactive_customers
from Customers C
where not exists (
    select 1 from Orders O
    where O.customer_id = C.customer_id
)
group by country
order by inactive_customers desc;
go

--7) 3: Customers who ordered with more than 10 items 
select C.[name], sum(Oi.quantity) as total_items
from Customers C
join Orders O on O.customer_id = C.customer_id
join Order_items Oi on Oi.order_id = O.order_id
group by C.customer_id, C.[name]
having sum(Oi.quantity) > 10;
go

--7) 4: Average product price per category
select category, avg(price) as average_price
from Products
group by category;
go

--7) 5: Product with highest revenue generated and how many times it was sold
select top 5 P.product_name, sum(Oi.Total_amount) as total_revenue, count(Oi.order_item_id) as times_sold
from Products P
join Order_items Oi on Oi.product_id = P.product_id
join Orders O on O.order_id = Oi.order_id
join Payments Ps on Ps.order_id = O.order_id
group by P.product_name
order by total_revenue desc;
go

--7) 6 : most 3 popular product
select top 3 P.product_name, sum(Oi.quantity) as total_sold
from Order_items Oi
join Products P on P.product_id = Oi.product_id
group by P.product_name
order by total_sold desc;
go

--7) 7 : Total payments received per payment method
select payment_method, sum(Amount_paid) as total_received
from Payments
group by payment_method;
go


-- 7) 8: Daily total income from payments
select payment_date, sum(Amount_paid) as daily_income
from Payments
group by payment_date
order by payment_date;
go

