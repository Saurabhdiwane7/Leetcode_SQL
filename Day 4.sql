Q1 = You are the restaurant owner and you want to analyze a possible expansion (there will be at least one customer every day).
Compute the moving average of how much the customer paid in a seven days window (i.e., current day + 6 days before). average_amount should be rounded to two decimal places.
Return the result table ordered by visited_on in ascending order.

Ans =

select c1.visited_on, 
sum(c2.amount) as amount, 
round(avg(c2.amount), 2) as average_amount

from 

(select visited_on, sum(amount) as amount  
      from customer group by visited_on) c1   #one table
 
join 
(select visited_on, sum(amount) as amount 
      from customer group by visited_on) c2   #second table

on datediff(c1.visited_on, c2.visited_on) between 0 and 6
group by c1.visited_on
having count(c2.amount) = 7


Q2 =Write an SQL query to find the people who have the most friends and the most friends number.
The test cases are generated so that only one person has the most friends.

Ans = 

select person_id as id,
count(*) as num
from(

  select requester_id as person_id, accepter_id as friend_id
  from requestaccepted 
  union all
  select accepter_id as person_id ,requester_id as friend_id
  from requestaccepted
) friendships
group by person_id 
order by num desc
limit 1


Q3 =A company's executives are interested in seeing who earns the most money in each of the company's departments. A high earner in a department is an employee who has a salary in the top three unique salaries for that department.
Write an SQL query to find the employees who are high earners in each of the departments.
Ans = 

with cte as 
(select 
d.name as Department,
e.name as Employee,
e.salary as salary,
dense_rank() over (partition by e.departmentid order by salary desc  ) as rnk
from employee e 
join department d 
on e.departmentid = d.id )
select department,employee,salary from cte 
where rnk <=3


Q4 = Write a solution to fix the names so that only the first character is uppercase and the rest are lowercase.
Return the result table ordered by user_id.

Ans = 
select user_id,
concat(upper(substr(name,1,1)),(substr(lower(name),2))) as name
from users 
order by user_id 


Q5 =Write a solution to find the patient_id, patient_name, and conditions of the patients who have Type I Diabetes. Type I Diabetes always starts with DIAB1 prefix.
Return the result table in any order.
Ans = 

SELECT patient_id, patient_name, conditions
FROM patients
WHERE conditions LIKE '%DIAB1%'
AND conditions NOT LIKE "__DIAB1%";


Q6 = Write a solution to delete all duplicate emails, keeping only one unique email with the smallest id.
For SQL users, please note that you are supposed to write a DELETE statement and not a SELECT one.
For Pandas users, please note that you are supposed to modify Person in place.
After running your script, the answer shown is the Person table. The driver will first compile and run your piece of code and then show the Person table. The final order of the Person table does not matter.

ans = 
DELETE p1
FROM Person p1
JOIN Person p2 ON p1.email = p2.email AND p1.id > p2.id;


Q7 = Write a solution to find the second highest salary from the Employee table. If there is no second highest salary, return null (return None in Pandas).
Ans =
select(select distinct salary 
from employee
order by salary desc 
limit 1 offset 1) as secondhighestsalary


Q8 = Write a solution to find for each date the number of different products sold and their names.
The sold products names for each date should be sorted lexicographically.
Return the result table ordered by sell_date.

Ans = 
SELECT sell_date,
COUNT(DISTINCT product) AS num_sold,
GROUP_CONCAT(DISTINCT product ORDER BY product ASC) AS products
FROM Activities
GROUP BY sell_date
ORDER BY sell_date;


Q9 = Write an SQL query to get the names of products that have at least 100 units ordered in February 2020 and their amount.
Return result table in any order.

Ans =
select p.product_name,
sum(o.unit) as unit
from products p 
join orders o
on  p.product_id = o.product_id 
where o.order_date >= '2020-02-01' and o.order_date <='2020-02-29'
group by p.product_name
having sum(o.unit) >=100


Q10 = Write a solution to find the users who have valid emails.
A valid e-mail has a prefix name and a domain where:
The prefix name is a string that may contain letters (upper or lower case), digits, underscore '_', period '.', and/or dash '-'. The prefix name must start with a letter.
The domain is '@leetcode.com'.

Ans =
select 
user_id,
name,
mail
from users
where mail regexp "^[A-Z][A-Za-z0-9._-]*@leetcode\\.com$"


