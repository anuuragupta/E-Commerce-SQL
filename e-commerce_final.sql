-- -------------------------------------------------------------------------------ANALYSIS ON ECOMMERCE SITE--------------------------------------------------------------------------------------------- --

/* 
The e-commerce industry has seen tremendous growth in recent years, with more and more consumers turning to online shopping for convenience and a wider selection 
of products. As a result, understanding consumer behavior and sales trends on an e-commerce site is crucial for success. Sales analysis can provide valuable insights 
into purchasing patterns, popular products, and areas for improvement. With this information, e-commerce businesses can make informed decisions on everything from 
inventory management to marketing strategy. By staying on top of sales trends and consumer behavior, an e-commerce site can continue to grow and thrive in a competitive 
market. 
*/ 

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- --

create database ecommerce; -- createing new database
use ecommerce;

select * from `list of orders`;
select * from `order details`;
select * from `sales target`;

Describe `list of orders`; 

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- --

-- Changing the Datatype of date column which is in text convert it to date format then save it as a view.
create View `list of order` as
select 
`order id`, 
str_to_date(`order date`,'%d-%m-%Y')as `order_date`, 
CustomerName, state, City from `list of orders`;

Describe `list of order`;

-- Inner join Order Details and List of Order table.
create table sale_cust as
select a.`order id` , b.order_date, b.customername, b.state, b.city, a.amount, a.profit, a.quantity, a.Category, a.`sub-category`
from `order details` as a inner join `list of order` as b 
on a.`order id`=b.`order id`;

select * from sale_cust;

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- --

-- Creating table to show the sub-category, category by thier Total Sales.
create table Total_sales as
select Distinct `sub-category`, Category, sum(amount) over(partition by `sub-category`) as Subcat_sales, sum(amount) over(partition by category) as Category_sales, sum(amount) over() as Total_sales
from sale_cust
order by category_sales desc;

select * from total_sales;

-- Top 10 Sub-category by total_Sales
select `sub-category`, Category, Subcat_sales, Rank_subcatsales, Category_sales,Rank_catsales, Total_sales from 
(select * , 
Dense_rank() over (order by Category_sales desc) as Rank_catsales, 
Dense_rank() over ( order by subcat_sales desc) as Rank_subcatsales 
from total_sales) 
subquery
where rank_subcatsales <= 10
; 

-- Analysis on Top 10 Sub-category by Their Sales
/* 
	1. Printers: This sub-category has the highest sales among all sub-categories with 58252 units sold. It belongs to the Electronics category which also has the highest 
       sales among all categories.
	2. Bookcases: This sub-category ranks second with 56861 units sold. It belongs to the Furniture category which ranks third in terms of category sales.
	3. Saree: This Clothing sub-category ranks third with 53511 units sold. The Clothing category has the second highest sales among all categories.
	4. Phones: This Electronics sub-category ranks fourth with 46119 units sold. It belongs to the Electronics category which also has the highest sales among all categories.
	5. Electronic Games: This Electronics sub-category ranks fifth with 39168 units sold. It also belongs to the Electronics category which has the highest sales among all 
       categories.
	6. Chairs: This Furniture sub-category ranks sixth with 34222 units sold. It belongs to the Furniture category which ranks third in terms of category sales.
	7. Trousers: This Clothing sub-category ranks seventh with 30039 units sold. The Clothing category has the second highest sales among all categories.
	8. Tables: This Furniture sub-category ranks eighth with 22614 units sold. It belongs to the Furniture category which ranks third in terms of category sales.
	9. Accessories: This Electronics sub-category ranks ninth with 21728 units sold. It belongs to the Electronics category which also has the highest sales among all categories.
   10. Stole: This Clothing sub-category ranks tenth with 18546 units sold. The Clothing category has the second highest sales among all categories.
	
    Overall, we can observe that Electronics category has the highest sales among all categories, while the Clothing category and Furniture category rank second 
    and third, respectively. Among the top 10 sub-categories, Electronics dominates with 5 sub-categories, followed by Clothing and Furniture with 3 and 2 sub-categories, 
    respectively.
*/

-- Bottom 3 Sub-category by Sales.
select * from total_sales
order by subcat_sales limit 3 ;


/* 
	1. Skirt    :This sub-category of clothing has the lowest sub-category sales among the products listed. 
                    However, it still contributes to a significant portion of the overall category sales.
	2. Leggings :This sub-category of clothing has the second lowest sub-category sales among the products listed. 
					However, it still contributes to a significant portion of the overall category sales.
	3. Kurti    :This sub-category of clothing has the third lowest sub-category sales among the products listed. 
					However, it still contributes to a significant portion of the overall category sales.
    
    These three products have the lowest sub-category sales among all the products listed in the table, with Leggings having the lowest sub-category sales. However, 
    it is important to note that all of these products still have relatively high category sales and contribute significantly to the total sales of their respective 
    categories.
*/

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- --

-- Creating table to show the sub-category, category by thier Total Revenue.
create table Total_Revenue as
select Distinct `sub-category`, Category, sum(profit) over(partition by `sub-category`) as Subcat_Revenue, sum(profit) over(partition by category) as Category_Revenue, sum(profit) over() as Total_Revenue
from sale_cust
order by category_Revenue desc;

select * from total_revenue;

-- Top 3 Sub-category by Total_Revenue
select `sub-category`, Category, Subcat_Revenue, Rank_subcatrevenue, Category_revenue,Rank_catrevenue, Total_revenue from 
(select * , 
Dense_rank() over (order by Category_revenue desc) as Rank_catrevenue, 
Dense_rank() over ( order by subcat_revenue desc) as Rank_subcatrevenue 
from total_revenue) 
subquery
where rank_subcatrevenue <= 3
; 

-- Bottom 3 Sub-category by Total_Revenue
select `sub-category`, Category, Subcat_Revenue, Rank_subcatrevenue, Category_revenue,Rank_catrevenue, Total_revenue from 
(select * , 
Dense_rank() over (order by Category_revenue ) as Rank_catrevenue, 
Dense_rank() over ( order by subcat_revenue ) as Rank_subcatrevenue 
from total_revenue) 
subquery
where rank_subcatrevenue <= 3
; 

-- Analysis on Category, Sub-Category by Revenue
/*
	1. The total revenue generated across all categories and subcategories is 23955.
	2. The top three subcategories by revenue are Printers in Electronics, Bookcases in Furniture, and Accessories in Electronics.
	3. The bottom three subcategories by revenue are Tables in Furniture, Electronic Games in Electronics, and Kurti in Clothing.
	4. Among all the categories, Electronics generates the highest revenue of 10494, followed by Clothing with 11163 and Furniture with 2298.
	5. The subcategories with negative revenue are Tables in Furniture and Electronic Games in Electronics. This indicates that these subcategories 
	   are not performing well and are incurring losses.
	6. The subcategory with the highest negative revenue is Tables in Furniture, indicating that it is performing poorly and is a major contributor to 
       the negative revenue in the Furniture category.
	
    The subcategory with the highest positive revenue is Printers in Electronics, indicating that it is performing well and is a major contributor to the 
    positive revenue in the Electronics category. Overall, the Clothing category generates the highest revenue among all categories, with a total revenue of 11163, 
    followed by Electronics with a revenue of 10494.
*/

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- --

-- Creating table to show the sub-category, category by thier Profit Gain.
create table profit_margin as
select subquery1.*,subquery2.profit_margin_c from
(select `Sub-category`,Category,round(sum(profit)/sum(amount)*100,0) as profit_margin_sc from sale_cust group by `sub-category`,category) subquery1  inner join
(select  Category, round(sum(profit)/sum(amount)*100,0) as profit_margin_c from sale_cust group by Category)subquery2  on subquery1.category=subquery2.category
order by profit_margin_sc desc;

select * from profit_margin;

-- Top 3 Sub-category by Profit_margin
select `sub-category`, Category, profit_margin_sc, Rank_subcatpm, profit_margin_c,Rank_catpm from 
(select * , 
Dense_rank() over (order by profit_margin_c desc) as Rank_catpm, 
Dense_rank() over ( order by profit_margin_sc desc) as Rank_subcatpm 
from profit_margin) 
subquery
where rank_subcatpm <= 3
; 

-- Bottom 3 Sub-category by Profit_margin
select `sub-category`, Category, profit_margin_sc, Rank_subcatpm, profit_margin_c,Rank_catpm from 
(select * , 
Dense_rank() over (order by profit_margin_c ) as Rank_catpm, 
Dense_rank() over ( order by profit_margin_sc ) as rank_subcatpm 
from Profit_margin) 
subquery
where rank_subcatpm <= 3
; 

-- Analysis on Category, Sub-Category by Profit Margin
/*
	1. The highest profit margin sub-category is T-shirt in the Clothing category with a profit margin of 20%, followed by Accessories in the 
       Electronics category with a profit margin of 16%.
	2. The lowest profit margin sub-category is Tables in the Furniture category with a negative profit margin of -18%, which means the company 
       is incurring losses for this sub-category.
	3. Most sub-categories have a higher profit margin than their corresponding category, which suggests that these sub-categories are performing 
       better than the category they belong to.
	4. Electronic Games in the Electronics category have a negative profit margin, which means the company is incurring losses in this sub-category. 
       This suggests that the company might need to re-evaluate its strategy for this sub-category or consider discontinuing it.
	5. The Furniture category has the lowest average profit margin compared to other categories, with an average profit margin of 2%. This indicates 
       that the company needs to focus on improving the profitability of this category.
	6. The Clothing category has the highest average profit margin compared to other categories, with an average profit margin of 8%. This suggests that 
       the company is performing well in this category and might consider investing more resources into it.
*/

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- --

show tables;

-- Creating table to show month by sales , revenue of Category and sub-Category
create table month_data as
select Order_month, Totalsales_month,Totalrevenue_month, Category, Totalsales_cm, Totalrevenue_cm, `sub-category`, Totalsales_scm,Totalrevenue_scm, total_sales,Total_revenue  from
(select distinct Month(order_date) as Order_month , `sub-category`, Category,
sum(amount) over() as Total_sales, 
sum(profit) over() as Total_revenue,
sum(amount) over (partition by month(order_date)) as Totalsales_month,
sum(profit) over (partition by month(order_date)) as Totalrevenue_month,
sum(amount) over (partition by month(order_date), `sub-category`) as Totalsales_scm,
sum(profit) over (partition by month(order_date), `sub-category`) as Totalrevenue_scm,
sum(amount) over (partition by month(order_date), category) as Totalsales_cm,
sum(profit) over (partition by month(order_date), category) as Totalrevenue_cm
from sale_cust)
subquery;

select * from month_data;

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- --

-- Month by Sales and Revenue.
Select distinct order_month, totalsales_month , rank_monthsales, totalrevenue_month, rank_monthrevenue from
(select distinct order_month, 
Totalsales_month, Dense_rank() over ( order by totalsales_month desc) as Rank_monthSales , 
totalrevenue_month, Dense_rank() over (order by totalrevenue_month desc) as rank_monthrevenue,
Category, Totalsales_cm, Dense_rank() over (partition by order_month order by Totalsales_cm desc) as Rank_salescatmonth ,
Totalrevenue_cm, Dense_rank() over (partition by order_month order by Totalrevenue_cm desc) as Rank_revenuecatmonth ,
`sub-category`,Totalsales_scm, Dense_rank() over (partition by order_month order by Totalsales_scm  desc) as rank_salesscmonth,
Totalrevenue_scm, Dense_rank() over (partition by order_month order by Totalrevenue_scm  desc) as rank_revenuescmonth from month_data)subquery;
-- where rank_monthsales<=5
-- order by rank_monthSales;

/*
	1. The highest total sales were recorded in January with a value of 61,439, and the lowest total sales were recorded in July with a value of 12,966.
	2. The highest total revenue was recorded in November with a value of 11,619, and the lowest total revenue was recorded in June with a value of -4,970. 
	   A negative value for revenue indicates a loss.
	3. The rank of total sales and total revenue does not always match. For example, in December, the total sales were ranked 5th, while the total revenue was 
	   ranked 5th as well. However, in November, the total sales were ranked 3rd, while the total revenue was ranked 1st.
	4. It can be observed that the total sales and total revenue are not always directly proportional to each other. For example, in November, the total sales were 
       lower than January, but the total revenue was higher than January.
	5. The rank of total sales and total revenue is the same in only 5 months, i.e., in March, May, August, December, February.
	6. The months with the highest total sales also generally have the highest total revenue, except for July and June.
    
	* Overall, we can conclude that the highest performing months in terms of sales and revenue are November, January, and March. Whereas the lowest performing months 
	  are June and July.
*/

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- --

select * from month_Data;


-- Month by Sales and Revenue of Catgeories
Select distinct order_month, category, totalsales_cm,Rank_salescatmonth, totalrevenue_cm,Rank_revenuecatmonth from
(select distinct order_month, 
Totalsales_month, Dense_rank() over ( order by totalsales_month desc) as Rank_monthSales , 
totalrevenue_month, Dense_rank() over (order by totalrevenue_month desc) as rank_monthrevenue,
Category, Totalsales_cm, Dense_rank() over (partition by order_month order by Totalsales_cm desc) as Rank_salescatmonth ,
Totalrevenue_cm, Dense_rank() over (partition by order_month order by Totalrevenue_cm desc) as Rank_revenuecatmonth ,
`sub-category`,Totalsales_scm, Dense_rank() over (partition by order_month order by Totalsales_scm  desc) as rank_salesscmonth,
Totalrevenue_scm, Dense_rank() over (partition by order_month order by Totalrevenue_scm  desc) as rank_revenuescmonth from month_data)subquery;


-- Categories whose sales in a particular month is Maximum
select distinct subquery1.order_month, subquery2.Category, subquery1.total_sales, dense_rank() over (order by Total_sales desc) as rank_sales,
dense_rank() over (partition by category order by Total_sales desc) as rank_cat from
(select distinct Order_month, max(totalsales_cm) over ( partition by  order_month) as total_sales from month_data)subquery1 inner join
(select order_month,category, totalsales_cm from month_sales)subquery2 on subquery1.total_sales=subquery2.totalsales_cm;

/*
	1. Electronics is the most sold category overall, with sales in 7 out of 12 months.
	2. Clothing is the second most sold category, with sales in 4 out of 12 months.
	3. Furniture is the least sold category, with sales only in the month of February.
	4. Electronics had the highest sales in the months of January, November and December, and the lowest sales in July.
	5. Clothing had the highest sales in the month of August, and the lowest sales in the month of April.
	6. The sales of Furniture, Clothing and Electronics seem to fluctuate across the year, with no clear pattern or trend.
*/

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- --

-- Categories whose revenue in a particular month is Maximum
select distinct subquery1.order_month, subquery2.Category, subquery1.total_revenue, dense_rank() over (order by Total_revenue desc) as rank_revenue,
dense_rank() over (partition by category order by Total_revenue desc) as rank_cat from
(select distinct Order_month, max(totalrevenue_cm) over ( partition by  order_month) as total_revenue from month_data)subquery1 inner join
(select order_month,category, totalrevenue_cm from month_data)subquery2 on subquery1.total_revenue=subquery2.totalrevenue_cm;

/*
	1. Clothing was the highest revenue-generating category in March, whereas Electronics was the highest revenue-generating category in December.
	2. Furniture was the highest revenue-generating category in November and ranked 3rd overall across all the months.
	3. Clothing and Electronics were consistently among the top 4 revenue-generating categories across all the months.
	4. While Clothing generated the most revenue in March, it also generated negative revenue in May and June. This suggests that the company may have 
	   experienced losses or refunded orders in these months.
	5. Electronics generated negative revenue in September and ranked last across all the months in terms of revenue generated. This indicates that the 
	   company may have experienced losses or low sales in this category in that particular month.
*/

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- --

select * from month_data;

-- The subcategories that had the highest sales in a particular month 
select subquery1.order_month, subquery2.`sub-category`, subquery1.total_sales from
(select distinct order_month, max(Totalsales_scm)over ( partition by  order_month) as total_sales from month_data)subquery1 inner join
(select order_month, `sub-category`, totalsales_scm from month_data)subquery2 on subquery1.total_sales=subquery2.totalsales_scm;

/*
	January: Bookcases
	February: Tables
	March: Printers
	April: Saree
	May: Saree
	June: Saree
	July: Phones
	August: Bookcases
	September: Saree
	October: Saree
	November: Printers
	December: Phones
*/

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- --

-- The subcategories that had the highest Revenue in a particular month 
select subquery1.order_month, subquery2.`sub-category`, subquery1.total_revenue from
(select distinct order_month, max(Totalrevenue_scm)over ( partition by  order_month) as total_revenue from month_data)subquery1 inner join
(select order_month, `sub-category`, totalrevenue_scm from month_data)subquery2 on subquery1.total_revenue=subquery2.totalrevenue_scm;

/*
	January: Bookcases
	February: Accessories
	March: Printers
	April: Phones
	May: T-shirt
	June: Trousers
	July: Printers
	August: Bookcases
	September: Bookcases
	October: Printers
	November: Printers
	December: Phones
*/

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- --

select * from month_data;

show tables;

select * from sale_cust;
select * from `list of order`;

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- --
 
-- This query provides an overview of the state-wise distribution of orders and their contribution to the total Orders.
select Ranked, State, State_orders, round((state_orders/Total_orders)*100) as `%total_orders` from(select *, dense_rank() over (order by State_orders desc) as ranked from
(select distinct state, count(`order id`) over (partition by  state ) as State_orders ,count(`order id`) over() as Total_orders 
from sale_cust order by state_orders desc)
subquery)subquery2;

/*
	* The top five states cover almost 65% of total sales with the highest number of state orders are 
      Madhya Pradesh, Maharashtra, Gujarat, Delhi, and Rajasthan. Madhya Pradesh has the highest number 
      of state orders with 340, which is 23% of the total sales.
	* The states with the lowest number of state orders are Tamil Nadu, Sikkim, Haryana, and Himachal Pradesh. 
	  Tamil Nadu has the lowest number of state orders with only 25, which is 2% of the total sales.
*/

-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------- --

-- This query provides an overview of the state-wise distribution of sales and their contribution to the total sales.
select Ranked, State, State_sales, round((state_sales/Total_sales)*100) as `%total_sales` from(select *, dense_rank() over (order by State_sales desc) as ranked from
(select distinct state, sum(amount) over (partition by  state ) as State_sales ,sum(amount) over() as Total_sales 
from sale_cust order by state_sales desc)
subquery)subquery2;

/*
	This query shows the ranking of Indian states based on their total sales and percentage of total sales. Madhya Pradesh and Maharashtra 
	were the top two states in terms of total sales, with 24% and 22% of the total sales respectively. Delhi, Uttar Pradesh, and Rajasthan 
	were the next three states with around 5% of the total sales each. Gujarat, Punjab, and Karnataka followed closely with 5%, 4%, and 3% 
	of the total sales respectively. The remaining states had less than 3% of the total sales each.
*/

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- --

-- This query provides an overview of the state-wise distribution of Revenue and their contribution to the total revenue.
select Ranked, State, State_Revenue, round((state_Revenue/Total_Revenue)*100) as `%total_Revenue` from(select *, dense_rank() over (order by State_Revenue desc) as ranked from
(select distinct state, sum(profit) over (partition by  state ) as State_Revenue ,sum(profit) over() as Total_Revenue
from sale_cust order by state_Revenue desc)
subquery)subquery2;

/*
	* Maharashtra and Madhya Pradesh are the top two states in terms of state revenue, contributing to 49% of the total revenue.
	* Uttar Pradesh, Delhi, and West Bengal are also among the top states contributing significantly to the revenue.
	* Tamil Nadu has the lowest revenue and is the only state with a negative percentage of total revenue.
	* Bihar, Andhra Pradesh, and Punjab are the other states with negative revenue growth.
	* Jammu and Kashmir has the lowest revenue growth but still has a positive percentage of total revenue.
*/

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- --

-- This query provides an overview of the state-wise distribution of Users and their contribution to the total Users.
select dense_rank() over (order by State_Users desc) as ranked, State, State_users, round((state_users/total_user)*100) as `%total_Users` from
(select *,sum(state_users) over() as Total_user  from (select  state, count(distinct `order id`)  as State_Users from 
sale_cust group by state order by state_users desc)subquery)subquery2;

/*
	* Madhya Pradesh and Maharashtra have the highest number of users, with 101 and 90 users respectively.
	* The top 6 states (Madhya Pradesh, Maharashtra, Rajasthan, Gujarat, Punjab, and Delhi/Uttar Pradesh/West 
	  Bengal, tied at 22 users each) account for over half of the total users.
	* The percentage of users in each state is relatively evenly distributed, with no state having more than 
	  20% of the total users.
	* Tamil Nadu has the lowest number of users, with only 8 users.
	* Sikkim, with 12 users, has the lowest number of users among the states with at least 2% of the total users.
*/

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- --

select * from sale_cust;

-- Craeting a View to show State-wise Category Sales with Their rank
create view sales_cat_state as
select state, Furniture_sales,   Dense_rank() over (order by Furniture_sales desc)   as Fur_ranked,
              Clothing_sales,    Dense_rank() over (order by clothing_sales desc)    as clo_ranked,
              Electronics_sales, Dense_rank() over (order by Electronics_sales desc) as ele_ranked,
total_sales, Dense_rank() over (order by total_sales desc) as ranked 
from
(select subquery.state, subquery.Furniture_sales, subquery2.Clothing_sales, subquery3.Electronics_sales, subquery4.total_sales from
(select state, sum(amount) as Furniture_sales   from sale_cust where category = 'Furniture'   group by state)subquery                                       inner join
(select state, sum(amount) as Clothing_sales    from sale_cust where category = 'Clothing'    group by state)subquery2 on subquery.state = subquery2.state  inner join 
(select state, sum(amount) as Electronics_sales from sale_cust where category = 'Electronics' group by state)subquery3 on subquery2.state = subquery3.state inner join 
(select state, sum(amount) as total_sales       from sale_cust                                group by state)subquery4 on subquery3.state=subquery4.state
order by total_sales desc)subquery5;

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- --

select * from sales_cat_state;

-- State where Furniture Sales is Highest
select state, Furniture_sales, fur_ranked from sales_cat_state
where fur_ranked<=10 order by fur_ranked;

-- Showing which Sub-Category is performing well on Top 3 state where category is Furniture
select * , Dense_rank() over (partition by state order by sales desc ) as rank_state_sale from (select state, category, `sub-category` , sum(amount) as sales 
from sale_cust 
where category='Furniture' and state in ('Madhya pradesh' ,'Maharashtra' ,'Delhi')
group by state, category,`sub-category`
order by state)subquery;

-- State where Clothing Sales is Highest
select state, Clothing_sales, clo_ranked from sales_cat_state
where clo_ranked<=10 order by clo_ranked;


-- Showing which Sub-Category is performing well on Top 3 state where category is Clothing
select * , Dense_rank() over (partition by state order by sales desc ) as rank_state_sale from (select state, category, `sub-category` , sum(amount) as sales 
from sale_cust 
where category='Clothing' and state in ('Madhya pradesh' ,'Maharashtra' ,'Punjab')
group by state, category,`sub-category`
order by state)subquery;

-- State where Electronics Sales is Highest
select state, Electronics_sales, ele_ranked from sales_cat_state
where ele_ranked<=10 order by ele_ranked;

-- Showing which Sub-Category is performing well on Top 3 state where category is Electronics
select * , Dense_rank() over (partition by state order by sales desc ) as rank_state_sale from (select state, category, `sub-category` , sum(amount) as sales 
from sale_cust 
where category='Electronics' and state in ('Madhya pradesh' ,'Maharashtra' ,'Uttar Pradesh')
group by state, category,`sub-category`
order by state)subquery;

/*
	* Madhya Pradesh has the highest total sales at 105,140 and is ranked 1st, followed by Maharashtra with total sales of 95,348 and ranked 2nd.
	* In terms of furniture sales, Madhya Pradesh is ranked 1st with sales of 34,045, followed by Maharashtra with sales of 24,313 and ranked 2nd.
	* For clothing sales, Madhya Pradesh and Maharashtra are ranked 1st with sales of 30,566 and 28,542 respectively.
	* For electronics sales, Maharashtra is ranked 1st with sales of 42,493, followed by Madhya Pradesh with sales of 40,529 and ranked 2nd.
	* Punjab has the highest clothing sales with sales of 8,419 and is ranked 3rd in total sales.
	* Bihar has the highest electronics sales with sales of 7,357 and is ranked 12th in total sales.
	* Delhi has the lowest total sales at 22,531 and is ranked 3rd last, with only Sikkim and Tamil Nadu having lower sales.
	* Sikkim has the lowest furniture sales at 610 and is ranked last in total sales.
	* Himachal Pradesh has the lowest clothing sales at 1,337.
	*Tamil Nadu has the lowest electronics sales at 1,090.
*/

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- --

CREATE VIEW CUSTOMER AS
SELECT A.*, B.`Order_Date`,B.CUSTOMERNAME,B.STATE,B.CITY FROM `ORDER DETAILS` AS A LEFT OUTER JOIN `LIST OF ORDER` AS B ON A.`ORDER ID`=B.`ORDER ID`;

SELECT * FROM CUSTOMER;

CREATE VIEW LOYALC AS
SELECT DISTINCT `ORDER ID`, CUSTOMERNAME,STATE,CITY, COUNT(`ORDER ID`) AS VISIT_CNT, COUNT(DISTINCT `SUB-CATEGORY`) AS TYPES_SUBCATEGORY FROM CUSTOMER
GROUP BY CUSTOMERNAME,`ORDER ID`,STATE,CITY
HAVING VISIT_CNT>=3
ORDER BY VISIT_CNT DESC;
/* TO FIND LOYAL CUSTOMER I COUNT CUSTOMER WHO VISITS MORE THAN 5 TIME AND BUY MORE THAN 3 SUB-CATEGORY */

SELECT COUNT(*) FROM LOYALC;
-- THERE ARE 237 LOYAL CUSTOMER.

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- --

show tables;

select * from `sales target`;

Describe `sales target`;

select * from sale_cust;

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- --

-- Creating view to change data type of `Month of order date`
create view sales_target_temp  as #3
select str_to_date(string_date,"%d-%b-%y") as datee,Category, Target from #2
(select concat("01-",`Month of order date`)as string_date, Category, Target from `sales target`) #1
subquery;

/*
	#1 The `Month of order date` column is in string format like 'Apr-18' so first i concat "01-" to make it actual date format.
    #2 Then convert it it Date Format.
    #3 Then creating a view 
*/

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- --

-- Creating a Table to show the Furniture category Target sales and their actual sale.
Create table Furniture_target_sales as
select a.monthee, a.yearee, a.category, a.Target, b.Actual_saless from 
(select month(datee) as Monthee, year(datee) as yearee , Category, Target from sales_target_temp where category='Furniture')a left join
(select month(order_date) as monthee, year(order_date) as yearee, category, sum(amount) as actual_saless 
 from sale_cust
 where category='Furniture'
 group by monthee, yearee, category)b
 on a.monthee=b.monthee;

select * from Furniture_target_sales;

select Monthee, Yearee, Category, Target, Actual_saless,concat(round((Actual_saless/target)*100),"%") as Percent_achieved,
       CASE 
		   when Actual_saless >= Target then '✔️'
		   else '❌'
	   End as Target_achieve_status
from Furniture_target_sales;

/*
	* The sales of furniture category in the first half of the year 2018 are not up to the mark as the actual sales 
	  are lower than the target sales.
	* In the second half of the year 2018, the actual sales have been achieved and even exceeded the target sales in 
	  the month of November.
	* In the year 2019, the actual sales have been higher than the target sales in all three months.
	* The percent achieved is also given in the table, which shows the percentage of target sales achieved in each month. 
	  From this column, we can see that the sales were below the target in most of the months in 2018, but were significantly 
	  higher than the target in all three months of 2019.
*/

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- --

-- Creating a Table to show the Clothing category Target sales and their actual sale.
Create table Clothing_target_sales as
select a.monthee, a.yearee, a.category, a.Target, b.Actual_saless from 
(select month(datee) as Monthee, year(datee) as yearee , Category, Target from sales_target_temp where category='Clothing')a left join
(select month(order_date) as monthee, year(order_date) as yearee, category, sum(amount) as actual_saless 
 from sale_cust
 where category='Clothing'
 group by monthee, yearee, category)b
 on a.monthee=b.monthee;

select * from Clothing_target_sales;

select Monthee, Yearee, Category, Target, Actual_saless, concat(round((Actual_saless/target)*100),"%") as Percent_achieved,
       CASE 
		   when Actual_saless >= Target then '✔️'
		   else '❌'
	   End as Target_achieve_status
from Clothing_target_sales;

/*
	* Looking at the data, we can see that there were several months where the target was not achieved, indicated by the 
	  cross mark in the Target Achieve Status column. Specifically, months 2, 5, 6, 7, 8, 9, 10, 12 in 2018 and months 1 
	  and 2 in 2019 all failed to meet their sales targets.

	* On the other hand, months 3 and 11 in 2018, as well as month 3 in 2019, exceeded their sales targets, as indicated by 
	  the check mark in the Target Achieve Status column.
*/

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- --

-- Creating a Table to show the Electronics category Target sales and their actual sale.
Create table Electronics_target_sales as
select a.monthee, a.yearee, a.category, a.Target, b.Actual_saless from 
(select month(datee) as Monthee, year(datee) as yearee , Category, Target from sales_target_temp where category='Electronics')a left join
(select month(order_date) as monthee, year(order_date) as yearee, category, sum(amount) as actual_saless 
 from sale_cust
 where category='Electronics'
 group by monthee, yearee, category)b
 on a.monthee=b.monthee;

select * from Electronics_target_sales;

select Monthee, Yearee, Category, Target, Actual_saless,concat(round((Actual_saless/target)*100),"%") as Percent_achieved,
       CASE 
		   when Actual_saless >= Target then '✔️'
		   else '❌'
	   End as Target_achieve_status
from Electronics_target_sales;

/*
	* Looking at the table, we can see that the Electronics category has performed very well, with most months achieving well 
	  above their sales targets. In fact, all months except for two (July and September of 2018) achieved at least 100% of their 
	  targets, with some months even achieving over 200%. This suggests that the Electronics category is a strong performer and 
	  a good area to focus on in the future. However, it's worth noting that the sales targets for this category are relatively 
	  low compared to the other categories, so it's possible that the targets may need to be adjusted to reflect the category's 
	  strong performance.
*/
-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- --
























































