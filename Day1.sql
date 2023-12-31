Q1 = Write an SQL query that reports the average experience years of all the employees for each project, rounded to 2 digits.
Return the result table in any order.

Ans = 

select
project_id,
round(avg(experience_years),2) average_years
from project p
join employee e
on p.employee_id =e.employee_id
group by project_id


Q2 = Write an SQL query to find the average selling price for each product. average_price should be rounded to 2 decimal places.

Ans = 

select p.product_id,
round(sum(p.price* u.units)/sum(u.units),2) as average_price
from prices p
join unitssold u
on p.product_id =u.product_id
and u.purchase_date between p.start_date and p.end_date
group by p.product_id 


Q3 = Write an SQL query to report the movies with an odd-numbered ID and a description that is not "boring".

Return the result table ordered by rating in descending order.

Ans =

select id,movie,description,rating
from cinema 
where id %2 !=0 and description != "Boring"
order by rating desc


Q4 = The confirmation rate of a user is the number of 'confirmed' messages divided by the total number of requested confirmation messages. The confirmation rate of a user that did not request any confirmation messages is 0. Round the confirmation rate to two decimal places.

Write an SQL query to find the confirmation rate of each user.

Return the result table in any order.


Ans = 

select s.user_id,
round(coalesce(conf_count,0)/coalesce(total_count,1),2) confirmation_rate
from 
(
(select distinct user_id from signups) s
left join
(select user_id ,count(*) as conf_count 
from confirmations 
where action = "confirmed"
group by user_id) c 
on s.user_id =c.user_id
left join 
(select user_id, count(*) as total_count from confirmations
group by user_id) t 
on s.user_id =t.user_id
)


Q5 = Find the managers with at least five direct reports.

Ans = select e.name
from employee e
where e.id in(
  select e2.managerid 
  from employee e2
  group by e2.managerid
  having count(*)>=5
)


Q6 =Find the number of times each student attended each exam.

Return the result table ordered by student_id and subject_name.

Ans = 
select s.student_id, s.student_name, sub.subject_name ,count(e.subject_name) as attended_exams
from students s
cross join subjects sub
left join examinations e on s.student_id = e.student_id and sub.subject_name =e.subject_name
group by s.student_id , s.student_name,sub.subject_name
order by s.student_id, s.student_name


Q7 = Write an SQL query to report the name and bonus amount of each employee with a bonus less than 1000.

Return the result table in any order.

Ans = 
select e.empid,b.bonus 
from employee e
left join bonus b
on e.empid=b.empid


Q8 =There is a factory website that has several machines each running the same number of processes. Write an SQL query to find the average time each machine takes to complete a process.

The time to complete a process is the 'end' timestamp minus the 'start' timestamp. The average time is calculated by the total time to complete every process on the machine divided by the number of processes that were run.

The resulting table should have the machine_id along with the average time as processing_time, which should be rounded to 3 decimal places.

Return the result table in any order.


Ans = 

select machine_id,round(avg(end-start),3) as processing_time
from(
  select machine_id, process_id,
  min(case when activity_type ="Start" then timestamp end ) start,
  max(case when activity_type ="end" then timestamp end ) end
  from activity
  group by machine_id, process_id
) as process_time
group by machine_id;


Q9 =Write an SQL query to report the name and bonus amount of each employee with a bonus less than 1000.

Return the result table in any order.


ans = 

select e.empid,b.bonus 
from employee e
left join bonus b
on e.empid=b.empid;



Q10 =Write an SQL query to find the percentage of the users registered in each contest rounded to two decimals.

Return the result table ordered by percentage in descending order. In case of a tie, order it by contest_id in ascending order.

Ans = 

SELECT
    contest_id,
    ROUND(COUNT(DISTINCT user_id) * 100.0 / (SELECT COUNT(DISTINCT user_id) FROM Register), 2) AS percentage
FROM
    Register
GROUP BY
    contest_id
ORDER BY
    percentage DESC,
    contest_id ASC;


Q11 = We define query quality as:
The average of the ratio between query rating and its position.
We also define poor query percentage as:
The percentage of all queries with rating less than 3.
Write an SQL query to find each query_name, the quality and poor_query_percentage.
Both quality and poor_query_percentage should be rounded to 2 decimal places.
Return the result table in any order.

Ans = 
select query_name,
round(avg(rating/position),2) as quality,
ROUND(SUM(CASE WHEN rating < 3 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS poor_query_percentage
from queries
group by query_name;
