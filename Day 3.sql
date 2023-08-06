Q1 =

 Report for every three line segments whether they can form a triangle.
Return the result table in any order.

Ans = 
select x,y,z,
case 
when (x+y>z) and (y+z>x) and (x+z>y) then 'Yes' else 'No' end as triangle
from triangle



Q2 = Find all numbers that appear at least three times consecutively.

Return the result table in any order.

Ans = 

select distinct l1.num as consecutivenums
from logs l1
join logs l2 on l1.id =l2.id+1
join logs l3 on l2.id =l3.id +1
where l1.num =l2.num and l2.num =l3.num 


Q3 = There is a queue of people waiting to board a bus. However, the bus has a weight limit of 1000 kilograms, so there may be some people who cannot board.
Write an SQL query to find the person_name of the last person that can fit on the bus without exceeding the weight limit. The test cases are generated such that the first person does not exceed the weight limit.

Ans = 

WITH CTE AS 
(
  SELECT 
PERSON_ID,PERSON_NAME,TURN,WEIGHT,
SUM(WEIGHT) OVER(ORDER BY TURN) AS TOTAL_WEIGHT
FROM QUEUE
)
SELECT PERSON_NAME FROM CTE WHERE TOTAL_WEIGHT<=1000 ORDER BY TOTAL_WEIGHT DESC LIMIT 1


Q4 = Write a solution to calculate the number of bank accounts for each salary category. The salary categories are:

"Low Salary": All the salaries strictly less than $20000.
"Average Salary": All the salaries in the inclusive range [$20000, $50000].
"High Salary": All the salaries strictly greater than $50000.
The result table must contain all three categories. If there are no accounts in a category, return 0.


Ans = 

SELECT 
  Categories.Category,
  COUNT(CategorizedAccounts.account_id) AS accounts_count
FROM (
  SELECT 
    account_id,
    CASE 
      WHEN income > 50000 THEN 'High Salary'
      WHEN income >= 20000 AND income <= 50000 THEN 'Average Salary'
      ELSE 'Low Salary' 
    END AS Category
  FROM accounts
) AS CategorizedAccounts
RIGHT JOIN (
  SELECT 'Low Salary' AS Category
  UNION ALL
  SELECT 'Average Salary'
  UNION ALL
  SELECT 'High Salary'
) AS Categories
ON CategorizedAccounts.Category = Categories.Category
GROUP BY Categories.Category;


Q5 = Find the IDs of the employees whose salary is strictly less than $30000 and whose manager left the company. When a manager leaves the company, their information is deleted from the Employees table, but the reports still have their manager_id set to the manager that left.
Return the result table ordered by employee_id.


Ans = 

SELECT e1.employee_id
FROM employees e1
LEFT JOIN employees e2 ON e1.manager_id = e2.employee_id
WHERE e1.salary < 30000 AND e2.employee_id IS NULL
ORDER BY e1.employee_id;



Q6 = Find the IDs of the employees whose salary is strictly less than $30000 and whose manager left the company. When a manager leaves the company, their information is deleted from the Employees table, but the reports still have their manager_id set to the manager that left.
Return the result table ordered by employee_id.

Ans = 

select 
employee_id from employees 
where salary< 30000 and manager_id not in (select employee_id from employees)
order by employee_id



Q7 =  Write a solution to swap the seat id of every two consecutive students. If the number of students is odd, the id of the last student is not swapped.
Return the result table ordered by id in ascending order.

Ans = 

select case 
when id % 2 = 1 and id <(select max(id) from seat) then id + 1
when id % 2 = 0 then id - 1
else id 
end as id,
student
from seat
order by id




Q8 =Find the name of the user who has rated the greatest number of movies. In case of a tie, return the lexicographically smaller user name.
Find the movie name with the highest average rating in February 2020. In case of a tie, return the lexicographically smaller movie name.

Ans =

SELECT name as results
FROM Users u
JOIN (
    SELECT user_id, COUNT(*) AS num_ratings
    FROM MovieRating
    GROUP BY user_id
    ORDER BY num_ratings DESC, user_id ASC
    LIMIT 1
) AS ratings_count
ON u.user_id = ratings_count.user_id
union
SELECT title
FROM Movies m
JOIN (
    SELECT movie_id, AVG(rating) AS avg_rating
    FROM MovieRating
    WHERE created_at >= '2020-02-01' AND created_at < '2020-03-01'
    GROUP BY movie_id
    ORDER BY avg_rating DESC, movie_id ASC
    LIMIT 1
) AS avg_ratings_feb
ON m.movie_id = avg_ratings_feb.movie_id;


Q9 = 
Julia asked her students to create some coding challenges. Write a query to print the hacker_id, name, 
and the total number of challenges created by each student. Sort your results by the total number of
challenges in descending order. If more than one student created the same number of challenges,
then sort the result by hacker_id. If more than one student created the same number of challenges and
the count is less than the maximum number of challenges created, then exclude those students from the result.




SELECT h.hacker_id, 
       h.name, 
       COUNT(c.challenge_id) AS challenge_count
FROM Hackers h
JOIN Challenges c ON c.hacker_id = h.hacker_id
GROUP BY h.hacker_id, h.name
HAVING challenge_count = 
    (SELECT COUNT(challenge_id) AS count_max  --- max count of challenges ---
     FROM Challenges
     GROUP BY hacker_id 
     ORDER BY count_max DESC limit 1)
OR challenge_count IN 
    (SELECT DISTINCT c_compare AS c_unique    ---distinct count od challenges ---
     FROM (SELECT h2.hacker_id, 
                  h2.name, 
                  COUNT(challenge_id) AS c_compare
           FROM Hackers h2
           JOIN Challenges c ON c.hacker_id = h2.hacker_id
           GROUP BY h2.hacker_id, h2.name) counts
     GROUP BY c_compare
     HAVING COUNT(c_compare) = 1)
ORDER BY challenge_count DESC, h.hacker_id;


Q10 = You did such a great job helping Julia with her last coding contest challenge that she wants you to work on this one, too!

The total score of a hacker is the sum of their maximum scores for all of the challenges. 
Write a query to print the hacker_id, name, and total score of the hackers ordered by the descending score. 
If more than one hacker achieved the same total score, then sort the result by ascending hacker_id.
 Exclude all hackers with a total score of  from your result.



select h.hacker_id,
h.name,
sum(S.max_score) as total_score
from hackers h 
join(
    select 
    S.hacker_id, max(S.score) as max_score
    from submissions S
    group by S.hacker_id, S.challenge_id
) S
on h.hacker_id = S.hacker_id
group by  h.hacker_id, h.name
having  total_score > 0
order by total_score desc, h.Hacker_id asc