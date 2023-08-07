Q1 = Find all dates Id with higher temperatures compared to its previous dates (yesterday).
Return the result table in any order.

Ans = 
select w1.id from weather w1
join weather w2 
on w1.recorddate =date_add(w2.recorddate,interval 1 Day)
where w1.temperature > w2.temperature


Q2 =Write an SQL query to report the name and bonus amount of each employee with a bonus less than 1000.
Return the result table in any order.

Ans = 
select 
e.name,
b.bonus
from employee e
left join bonus b on e.empid =b.empid
where b.bonus < 1000 or b.bonus is null


Q3 =Write a solution to find the percentage of the users registered in each contest rounded to two decimals.
Return the result table ordered by percentage in descending order. In case of a tie, order it by contest_id in ascending order.

Ans = 

SELECT contest_id,
       ROUND(COUNT(DISTINCT user_id) * 100.0 / (SELECT COUNT(DISTINCT user_id) FROM Users), 2) AS percentage
FROM Register
GROUP BY contest_id
ORDER BY percentage DESC, contest_id ASC;


Q4 = Write a SQL query to find the IDs of the users who visited without making any transactions and the number of times they made these types of visits.
Return the result table sorted in any order.

Ans =
select v.customer_id,count(v.visit_id) as count_no_trans 
from visits v
left join transactions t
on (v.visit_id =t.visit_id)
where t.transaction_id is null
group by v.customer_id
order by count_no_trans  desc


Q5 =
Two pairs (X1, Y1) and (X2, Y2) are said to be symmetric pairs 
if X1 = Y2 and X2 = Y1.

Write a query to output all such symmetric pairs in ascending order 
by the value of X. List the rows such that X1 ≤ Y1.

Ans = 

SELECT f1.X, f1.Y FROM Functions AS f1 
WHERE f1.X = f1.Y AND
(SELECT COUNT(*) FROM Functions WHERE X = f1.X AND Y = f1.Y) > 1   # count for similar pairs
UNION
SELECT f1.X, f1.Y from Functions AS f1
WHERE EXISTS(SELECT X, Y FROM Functions WHERE f1.X = Y AND f1.Y = X AND f1.X < X)  #condition if there is pair of (x1 =y2 or x2 =y1)
ORDER BY X;


Q6 = 
You are given three tables: Students, Friends and Packages.
 Students contains two columns: ID and Name. 
Friends contains two columns: ID and Friend_ID (ID of the ONLY best friend). 
Packages contains two columns: ID and Salary (offered salary in $ thousands per month).


Write a query to output the names of those students whose best friends got offered
 a higher salary than them. Names must be ordered by the salary amount offered to the best friends.
 It is guaranteed that no two students got same salary offer.


ANS = 


SELECT S.NAME 
FROM STUDENTS S 
JOIN FRIENDS F ON S.ID =F.ID
JOIN PACKAGES P ON F.FRIEND_ID = P.ID                            # Join friendsid on packasge id 
WHERE P.SALARY >(SELECT SALARY FROM PACKAGES WHERE ID = S.ID ) # package sal > sal where id = studentid
ORDER BY P.SALARY ASC


Q7 =Q4=

You are given a table, Projects, containing three columns: Task_ID, Start_Date and End_Date.
 It is guaranteed that the difference between the End_Date and the Start_Date is equal to 1 day for each row in the table.



If the End_Date of the tasks are consecutive, then they are part of the same project. 
Samantha is interested in finding the total number of different projects completed.

Write a query to output the start and end dates of projects listed by the number of days 
it took to complete the project in ascending order. If there is more than one project that have the same number
 of completion days, then order by the start date of the project.

ANS-

SELECT MIN(Start_Date) AS Start_Date, MAX(End_Date) AS End_Date
FROM (
    SELECT Task_ID, Start_Date, End_Date,
        ROW_NUMBER() OVER (ORDER BY Start_Date) - 
        ROW_NUMBER() OVER (PARTITION BY DATE_SUB(Start_Date, INTERVAL Task_ID DAY) ORDER BY Start_Date) AS project_group
    FROM Projects
) AS project_groups
GROUP BY project_group
ORDER BY DATEDIFF(End_Date, Start_Date), Start_Date;


#---The first ROW_NUMBER() function assigns a sequential number to each row ordered by the Start_Date.
 #The second ROW_NUMBER() function assigns a sequential number to each row within the same 
#group based on the difference between the Start_Date and the Task_ID day interval



select start_date,min(end_date)
from
(
select task_ID,
start_date from projects
where start_date not in (select end_date from projects)) a,
(select end_date from projects 
 where  end_date not in (select start_date from projects))b

where start_date < end_date
group by start_date 
order by datediff(min(end_date),start_date) asc,start_date asc;