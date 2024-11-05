--1.Who is the senior most employee based on job title? 

use [music project ]
select top(1) * from employee
order by levels desc

--2.Which countries have the most Invoices? 
select billing_country,count(*) as most_invoice from invoice
 group by billing_country
 order by most_invoice desc

 --3.What are top 3 values of total invoice? 
select top(3) * from invoice
order by total desc

--4.	Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money.
--Write a query that returns one city that has the highest sum of invoice totals.
--Return both the city name & sum of all invoice totals 

select top(1) billing_country,sum(total)as total_invoice from invoice
group by billing_country
order by total_invoice desc

--5.	Who is the best customer? The customer who has spent the most money will be declared the best customer.
--Write a query that returns the person who has spent the most money 

select top(1)c.customer_id,sum(i.total) as most_spending from customer c
join invoice i 
on c.customer_id=i.customer_id
group by C.customer_id
order by most_spending desc



--Question Set 2 – Moderate 
--1. Write query to return the email, first name, last name, & Genre of all Rock Music 
--listeners. Return your list ordered alphabetically by email starting with A 

select distinct(c.email), c.first_name,c.last_name,g.name from customer c
join invoice i
on c.customer_id=i.customer_id
join invoice_line il
on i.invoice_id=il.invoice_id
join track t 
on il.track_id=t.track_id
join genre g 
on t.genre_id=g.genre_id
where g.name='rock '
order by email asc

--2. Let's invite the artists who have written the most rock music in our dataset. Write a 
--query that returns the Artist name and total track count of the top 10 rock bands

select top(10)a.artist_id,a.name,count(t.track_id) as total_count from artist a
join album al
on a.artist_id=al.artist_id
join track t
on al.album_id=t.album_id
join genre g
on t.genre_id=g.genre_id
where g.name='rock'
group by a.artist_id,a.name
order by total_count desc

--3. Return all the track names that have a song length longer than the average song length. 
--Return the Name and Milliseconds for each track. Order by the song length with the 
--longest songs listed first 


 select name,milliseconds from track
 where milliseconds >(select avg(milliseconds) from track)
 order by milliseconds desc


-------------------------------Question Set 3 – Advance 
------1. Find how much amount spent by each customer on artists? Write a query to return 
------customer name, artist name and total spent
select  c.first_name,c.last_name,ar.name,sum(i.total) as total from customer c 
 join invoice i 
on c.customer_id=i.customer_id
 join invoice_line il
on i.invoice_id=il.invoice_id
 join track t 
on il.track_id=t.track_id
 join album a
on t.album_id=a.album_id
 join artist ar
on a.artist_id=ar.artist_id
group by c.first_name,c.last_name,ar.name




--We want to find out the most popular music Genre for each country. We determine the 
--most popular genre as the genre with the highest amount of purchases. Write a query 
--that returns each country along with the top Genre. For countries where the maximum 
--number of purchases is shared return all Genres 

with cte as (select c.country,g.name,sum(il.quantity) as total_purchase from customer c
join invoice i on 
c.customer_id=i.customer_id
join invoice_line il
on i.invoice_id=il.invoice_id
join track t 
on il.track_id=t.track_id
join genre g 
on t.genre_id=g.genre_id
group by c.country,g.name
)

select * from(select country,name,total_purchase,row_number()over(partition by country order by total_purchase desc) as finder from cte) as s
where finder = 1
order by total_purchase desc




---3.Write a query that determines the customer that has spent the most on music for each 
--country. Write a query that returns the country along with the top customer and how 
--much they spent. For countries where the top amount spent is shared, provide all 
--customers who spent this amount 

select * from (select c.customer_id,c.first_name,c.last_name,c.country,sum(total) as total_spending,row_number()
over(partition by c.country order by sum(total) desc) as finder from customer c
join invoice i
on c.customer_id=i.customer_id
group by c.customer_id,c.country,c.first_name,c.last_name) as f
where finder=1























