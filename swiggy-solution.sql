--select * from swiggy

--1. How many restaurants have a rating greater than 4.5?
select count(distinct restaurant_name) as toprated_restaurants
from swiggy
where rating>4.5;

--2. Which is the top 1 city with the highest number of restaurants?
with cte as(
select city ,count(distinct restaurant_name) as cnt
,rank() over(order by count(distinct restaurant_name) desc ) as rnk
from swiggy
group by city)

select * from cte
where rnk=1

--3. How many restaurants have the word "pizza" in their name?
select count(distinct restaurant_name) as Pizza_restaurant 
from swiggy
where upper(restaurant_name) like '%PIZZA%'

--4. What is the most common cuisine among the restaurants in the dataset?

select cuisine,count(*) as cuisine_count
from swiggy
group by cuisine
order by cuisine_count desc
limit 1;

--5. What is the average rating of restaurants in each city?
select city, avg(rating) as average_rating
from swiggy
group by city

--6. What is the highest price of an item under the 'Recommended' menu category for each restaurant?
with price_rank as (select *
,dense_rank()over(partition by restaurant_no order by price desc) as d_rnk
from swiggy
where menu_category='Recommended')

select restaurant_no, restaurant_name,item,price
from price_rank
where d_rnk=1

7. Find the top 5 most expensive restaurants that offer cuisine other than Indian cuisine.

with exp_restaurants as (select restaurant_no,restaurant_name,cost_per_person
,dense_rank() over(order by cost_per_person desc) as drnk
from swiggy
where cuisine<>'Indian'
group by restaurant_no,restaurant_name,cost_per_person)

select * from exp_restaurants
where drnk<=5


8. Find the restaurants that have an average cost higher than the total average cost of all restaurants together

select distinct restaurant_name,cost_per_person
from swiggy where cost_per_person>(
select avg(cost_per_person) from swiggy)

9. Retrieve the details of restaurants that have the same name but are located in different cities.

;select distinct t1.restaurant_name,t1.city,t2.city
from swiggy t1 join swiggy t2 
on t1.restaurant_name=t2.restaurant_name and
t1.city<>t2.city

10. Which restaurant offers the most number of items in the 'Main Course' category?

with most_no_item_ranking as (select restaurant_name,count(distinct item) as cnt
,rank() over( order by count(item) desc) as rnk
from swiggy
where menu_category='Main Course'
group by restaurant_name)

select * from most_no_item_ranking
where rnk=1


11. List the names of restaurants that are 100% vegetarian in alphabetical order of restaurant name.

select distinct restaurant_name
,(count(case when veg_or_nonveg='Veg' then 1 end)*100/count(*)) as vegetarian_percetage
from swiggy
group by restaurant_name
having vegetarian_percetage=100.00
order by restaurant_name


12. Which is the restaurant providing the lowest average price for all items?

select restaurant_name,avg(price) as averagePrice
from swiggy
group by restaurant_name
order by avg(price) 
limit 1




  