Q1 =Write an SQL query to find for each month and country,
the number of transactions and their total amount, 
the number of approved transactions and their total amount. 

Ans = 

 SELECT
    CONCAT(YEAR(trans_date), "-", LPAD(MONTH(trans_date), 2, '0')) AS month,
    country,
    COUNT(*) AS trans_count,
    SUM(CASE WHEN state = 'Approved' THEN 1 ELSE 0 END) AS approved_count,
    SUM(amount) AS trans_total_amount,
    SUM(CASE WHEN state = 'declined' THEN 0 ELSE amount END) AS approved_total_amount
FROM
    Transactions
GROUP BY
    CONCAT(YEAR(trans_date), "-", LPAD(MONTH(trans_date), 2, '0')),
    country;


Q2 = If the customers preferred delivery date is the same as the order date, then the order is called immediate; otherwise, it is called scheduled.
The first order of a customer is the order with the earliest order date that the customer made. It is guaranteed that a customer has precisely one first order.
Write an SQL query to find the percentage of immediate orders in the first orders of all customers, rounded to 2 decimal places.



with cte as 
(
  select * from 
  (select delivery_id,customer_id,order_date,
  customer_pref_delivery_date,
  (case when order_date = customer_pref_delivery_date then 1 else 0 end) immediate,
  rank() over(partition by customer_id order by order_date) as first_order
  from delivery
  ) x
  where first_order =1
)

select round(sum(immediate)*100.0/count(first_order),2) as immediate_percentage
from cte


Q3 = Write an SQL query to report the fraction of players that logged in again on the day after the day they first logged in, 
rounded to 2 decimal places. In other words, you need to count 
the number of players that logged in for at least two consecutive days 
starting from their first login date, then divide that number by the total
 number of players.



Ans = 

SELECT ROUND(
    SUM(CASE WHEN next_login_date IS NOT NULL THEN 1 ELSE 0 END) / COUNT(DISTINCT player_id),
    2
) AS fraction
FROM (
    SELECT 
        player_id, 
        event_date,
        LEAD(event_date) OVER (PARTITION BY player_id ORDER BY event_date) AS next_login_date
    FROM activity
) AS login_dates
WHERE next_login_date is null or DATEDIFF(next_login_date, event_date) = 1;




Q4 = Write a solution to calculate the number of unique subjects each teacher teaches in the university.

Return the result table in any order.

Ans = 

select teacher_id,count(distinct subject_id) cnt
from teacher
group by teacher_id


Q5 =Write an SQL query to find the daily active user count for a period of 30 days ending 2019-07-27 inclusively.
 A user was active on someday if they made at least one activity on that day.

Ans = 

SELECT
activity_date as day,
COUNT(DISTINCT user_id) AS active_users
FROM
activity
WHERE
activity_date between DATE_SUB('2019-07-27', INTERVAL 29 DAY) AND '2019-07-27'
GROUP BY
activity_date;


Q6 =Write an SQL query that selects the product id, year, quantity, and price for the first year of every product sold.

Ans = 

select
  s.product_id,s.year as first_year,s.quantity,s.price
from(
  select s.*,
  rank()over(partition by product_id order by year asc) as rnk
  from Sales s
) s
where rnk =1



Q7 =Write a solution to find all the classes that have at least five students.

Ans = 

select class from
(select 
  class,count(student) as max_student
from courses
group by class) r
where max_student>=5


Q8 = Write an SQL query that will, for each user, return the number of followers.

Return the result table ordered by user_id in ascending order.

Ans = 

select 
  user_id,
  count(follower_id) as followers_count
from followers
group by user_id


Q9 = A single number is a number that appeared only once in the MyNumbers table.

Find the largest single number. If there is no single number, report null.

Ans = 

select max(num) as num 
from (
  select num,count(num)
  from mynumbers
  group by num
  having count(num)<=1
)r


Q10 = Write an SQL query to report the customer ids from the Customer table that bought all the products in the Product table.

Return the result table in any order.


Ans = 

WITH cte AS (
  SELECT c.customer_id, COUNT(DISTINCT c.product_key) AS counts
  FROM Customer c
  JOIN Product p ON c.product_key = p.product_key
  GROUP BY c.customer_id
)
SELECT customer_id
FROM cte
WHERE counts = (SELECT COUNT(DISTINCT product_key) FROM Product);



Q11 = For this problem, we will consider a manager an employee who has at least 1 other employee reporting to them.
Write an SQL query to report the ids and the names of all managers, the number of employees who report directly to them, and the average age of the reports rounded to the nearest integer.
Return the result table ordered by employee_id.


Ans = 

select 
m.employee_id,
m.name,
count(r.employee_id) as reports_count,
round(avg(r.age)) as average_age
from employees m
left join employees r
on m.employee_id =r.reports_to
group by m.employee_id ,m.name
having count(r.employee_id) >0
order by m.employee_id 


Q12 = Employees can belong to multiple departments. When the employee joins other departments, they need to decide which department is their primary department. Note that when an employee belongs to only one department, their primary column is 'N'.
Write an SQL query to report all the employees with their primary department. For employees who belong to one department, report their only department.
Return the result table in any order.

Ans =

WITH CTE AS 
(SELECT EMPLOYEE_ID,
DEPARTMENT_ID,PRIMARY_fLAG,
row_number() OVER(PARTITION BY EMPLOYEE_ID ORDER BY PRIMARY_FLAG ASC ) RNK
FROM EMPLOYEE)
SELECT employee_id, department_id from cte where rnk =1