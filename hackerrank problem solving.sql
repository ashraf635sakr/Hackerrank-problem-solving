--Query a list of CITY names from STATION for 
--cities that have an even ID number. Print the 
--results in any order, but exclude duplicates from the answer.

SELECT DISTINCT CITY 
FROM STATION
WHERE ID % 2 = 0;

--Query the two cities in STATION with the shortest and longest CITY names, 
--as well as their respective lengths (i.e.: number of characters in the name).
--If there is more than one smallest or largest city, choose the one that comes
--first when ordered alphabetically

WITH city1 AS 
(SELECT TOP 1 CONCAT(CITY ,' ', LEN(CITY)) AS CITY_NUM
FROM STATION
ORDER BY LEN(CITY) DESC, CITY)
, city2 AS
(SELECT TOP 1 CONCAT(CITY ,' ', LEN(CITY)) AS CITY_NUM
FROM STATION
ORDER BY LEN(CITY) ASC, CITY)
SELECT * FROM city1
UNION ALL
SELECT * FROM city2

--Query the list of CITY names starting with vowels (i.e., a, e, i, o, or u) 
--from STATION. Your result cannot contain duplicates.

SELECT DISTINCT CITY 
FROM STATION 
WHERE CITY LIKE '[aeiou]%'

--Query the list of CITY names from STATION which have vowels (i.e., a, e, i, o, and u)
--as both their first and last characters. Your result cannot contain duplicates.

SELECT DISTINCT CITY 
FROM STATION 
WHERE CITY LIKE '[aeiou]%' AND CITY LIKE '%[aeiou]'

--Query the list of CITY names from STATION that do not start with vowels. 
--Your result cannot contain duplicates.

SELECT DISTINCT CITY 
FROM STATION 
WHERE CITY NOT LIKE '[aeiou]%'

--Query the list of CITY names from STATION that do not end with vowels.
--Your result cannot contain duplicates.

SELECT DISTINCT CITY 
FROM STATION 
WHERE CITY NOT LIKE '%[aeiou]'

--Query the list of CITY names from STATION that either do not start with vowels 
--or do not end with vowels. Your result cannot contain duplicates

SELECT DISTINCT CITY 
FROM STATION 
WHERE CITY NOT LIKE '%[aeiou]' OR CITY NOT LIKE '[aeiou]%'

--Query the Name of any student in STUDENTS who scored higher than  Marks. 
--Order your output by the last three characters of each name.
--If two or more students both have names ending in the same last three characters
--(i.e.: Bobby, Robby, etc.), secondary sort them by ascending ID

SELECT Name 
FROM STUDENTS
WHERE Marks > 75 
ORDER BY RIGHT(NAME,3), ID

--Write a query that prints a list of employee names (i.e.: the name attribute) 
--for employees in Employee having a salary greater than $2000 per month who have been
--employees for less than 10 months. Sort your result by ascending employee_id.

SELECT name 
FROM Employee 
WHERE salary > 2000 AND months < 10 
ORDER BY employee_id

--Given the CITY and COUNTRY tables, query the names of all cities
--where the CONTINENT is 'Africa'.
--Note: CITY.CountryCode and COUNTRY.Code are matching key columns

SELECT CI.NAME 
FROM CITY AS CI
LEFT JOIN COUNTRY AS CO
ON CI.COUNTRYCODE=CO.CODE
WHERE CONTINENT ='Africa';

--Write a query identifying the type of each record in the TRIANGLES table 
--using its three side lengths. Output one of the following statements for 
--each record in the table:

--Equilateral: It's a triangle with  sides of equal length.
--Isosceles: It's a triangle with  sides of equal length.
--Scalene: It's a triangle with  sides of differing lengths.
--Not A Triangle: The given values of A, B, and C don't form a triangle.

SELECT 
CASE 
   WHEN A=B AND A<>C AND B<>C AND (A+B) > C THEN 'Isosceles'
   WHEN A=C AND A<>B AND B<>C AND (A+C) >B THEN 'Isosceles'
   WHEN B=C AND A<>B AND B<>A AND (B+C) > A THEN 'Isosceles'
   WHEN A=B AND A=C AND B=C THEN 'Equilateral' 
   WHEN A<>B AND A<>C AND B<>C AND (A+B) > C THEN 'Scalene'
   WHEN (A+B) <= C  THEN 'Not A Triangle'
   ELSE NULL
   END AS [OUTPUT]
FROM  TRIANGLES

--(1) Query an alphabetically ordered list of all names in OCCUPATIONS, 
--immediately followed by the first letter of each profession as a 
--parenthetical (i.e.: enclosed in parentheses). For example: AnActorName(A), 
--ADoctorName(D), AProfessorName(P), and ASingerName(S).

--(2) Query the number of ocurrences of each occupation in OCCUPATIONS. 
--Sort the occurrences in ascending order, and output them in the following format:

--There are a total of [occupation_count] [occupation]s.
--where [occupation_count] is the number of occurrences of an occupation 
--in OCCUPATIONS and [occupation] is the lowercase occupation name. 
--If more than one Occupation has the same [occupation_count], 
--they should be ordered alphabetically.

--Note: There will be at least two entries in the table for each type of occupation.

WITH query1 AS
(SELECT TOP 100 CONCAT(Name ,'(', LEFT(Occupation,1) ,')') AS A 
FROM OCCUPATIONS 
ORDER BY Name)
,query2 AS
(SELECT TOP 100 CONCAT ('There are a total of',' ',COUNT(Occupation),' ',LOWER(Occupation),'s.') AS B
FROM OCCUPATIONS
GROUP BY Occupation
ORDER BY COUNT(Name),Occupation  )
SELECT *FROM query1
UNION ALL
SELECT *FROM query2

--PIVOT the Occupation column in OCCUPATIONS so that each Name is sorted alphabetically
--and displayed underneath its corresponding Occupation. The output column headers 
--should be Doctor, Professor, Singer, and Actor, respectively.
--Note: Print NULL when there are no more names corresponding to an occupation.

select
    Doctor,
    Professor,
    Singer,
    Actor
from (
    select
        NameOrder,
        max(case Occupation when 'Doctor' then Name end) as Doctor,
        max(case Occupation when 'Professor' then Name end) as Professor,
        max(case Occupation when 'Singer' then Name end) as Singer,
        max(case Occupation when 'Actor' then Name end) as Actor
    from (
            select
                Occupation,
                Name,
                row_number() over(partition by Occupation order by Name ASC) as NameOrder
            from Occupations
         ) as NameLists
    group by NameOrder
    ) as Names

--You are given a table, BST, containing two columns: N and P, where N represents the 
--value of a node in Binary Tree, and P is the parent of N.
--Write a query to find the node type of Binary Tree ordered by the value of the node. 
--Output one of the following for each node:

--Root: If node is root node.
--Leaf: If node is leaf node.
--Inner: If node is neither root nor leaf node.


SELECT N , CASE
                WHEN N IS NOT NULL AND P IS  NULL THEN 'Root'
                WHEN N IN (SELECT P FROM BST) THEN 'Inner'
                ELSE 'Leaf'                                     
                END 
FROM BST
ORDER BY N;

--Amber's conglomerate corporation just acquired some new companies. 
--Each of the companies follows this hierarchy:
--Given the table schemas below, write a query to print the company_code, founder name, 
--total number of lead managers, total number of senior managers, total number of managers, 
--and total number of employees. Order your output by ascending company_code.

--Note:

--The tables may contain duplicate records.
--The company_code is string, so the sorting should not be numeric. For example, 
--if the company_codes are C_1, C_2, and C_10, then the ascending company_codes 
--will be C_1, C_10, and C_2.

SELECT C.company_code , C.founder , COUNT(DISTINCT L.lead_manager_code),
COUNT(DISTINCT S.senior_manager_code ), COUNT(DISTINCT M.manager_code ), 
COUNT(DISTINCT E.employee_code)
FROM Company AS C
LEFT JOIN Lead_Manager AS L
ON C.company_code=L.company_code
LEFT JOIN Senior_Manager AS S
ON C.company_code=S.company_code
LEFT JOIN Manager AS M
ON C.company_code=M.company_code
LEFT JOIN Employee AS E
ON C.company_code=E.company_code
GROUP BY C.company_code , C.founder
ORDER BY C.company_code

-- how to insert into a table with while loop

CREATE TABLE Table_5 (NUMBER INT)
DECLARE @START INT =1
DECLARE @END INT = 1000
WHILE @START<= @END
BEGIN
INSERT INTO Table_5 VALUES(@START)
SET @START=@START+1
END

--Write a query to print all prime numbers less than or equal to 1000 .
--Print your result on a single line, and use the ampersand (&) character
--as your separator (instead of a space).
--For example, the output for all prime numbers <= 10  would be 2&3&5&7

DECLARE @I INT=2
DECLARE @PRIME INT
DECLARE @OUTPUT TABLE (NUM INT)
WHILE @I<=1000
BEGIN
    DECLARE @J INT = ((@I/2)+1)-1 --((@I/2)+1) to improve performance
    SET @PRIME=1
    WHILE @J>1
    BEGIN
        IF @I % @J=0
        BEGIN
            SET @PRIME=0
        END
        SET @J=@J-1   
    END
    IF @PRIME =1
    BEGIN
        INSERT @OUTPUT VALUES (@I)
    END
    SET @I=@I+1
END
SELECT STRING_AGG(NUM,'&') FROM @OUTPUT

--Samantha was tasked with calculating the average monthly salaries for all employees in the 
--EMPLOYEES table, but did not realize her keyboard's 0 key was broken until after completing 
--the calculation. She wants your help finding the difference between her miscalculation 
--(using salaries with any zeros removed), and the actual average salary.

--Write a query calculating the amount of error (i.e.:actual-miscalculated  average monthly salaries), 
--and round it up to the next integer.

Select round(avg(salary),0)-round(avg(CAST(replace(salary, '0', '')AS INT)),0) from Employees;

--We define an employee's total earnings to be their monthly salary*months worked, and the maximum total 
--earnings to be the maximum total earnings for any employee in the Employee table. Write a query to find the 
--maximum total earnings for all employees as well as the total number of employees who have maximum 
--total earnings. Then print these values as 2 space-separated integers.

SELECT TOP 1 CONCAT(earnings,' ',COUNT(earnings))
FROM (SELECT employee_id,MAX(months*salary) AS earnings
      FROM Employee 
      GROUP BY employee_id) AS B
GROUP BY earnings
ORDER BY earnings DESC

--Query the following two values from the STATION table:
--The sum of all values in LAT_N rounded to a scale of 2 decimal places.
--The sum of all values in LONG_W rounded to a scale of 2 decimal places.

select CAST(ROUND(SUM(LAT_N), 2)AS NUMERIC(7,2)), CAST(ROUND(SUM(LONG_W), 2) AS NUMERIC(7,2)) from STATION;

--Query the sum of Northern Latitudes (LAT_N) from STATION having values greater than  38.7880
--and less than 137.2345. Truncate your answer to 4 decimal places.

SELECT CAST(SUM(LAT_N) AS NUMERIC (9,4))
FROM STATION 
WHERE LAT_N>38.7880 AND LAT_N<137.2345

--Query the Western Longitude (LONG_W) for the largest Northern Latitude (LAT_N) in STATION that 
--is less than 137.2345. Round your answer to 4 decimal places.

SELECT CAST(LONG_W AS NUMERIC(9,4))
FROM STATION 
WHERE LAT_N IN (SELECT MAX(LAT_N) FROM STATION WHERE LAT_N <137.2345)


--Query the smallest Northern Latitude (LAT_N) from STATION that is greater than 38.7780. 
--Round your answer to 4 decimal places.

SELECT CAST(MIN(LAT_N) AS NUMERIC (9,4))
FROM STATION 
WHERE LAT_N>38.7780

--Consider P1(a,c)  and P2(b,d) to be two points on a 2D plane.

--* a happens to equal the minimum value in Northern Latitude (LAT_N in STATION).
--* b happens to equal the minimum value in Western Longitude (LONG_W in STATION).
--* c happens to equal the maximum value in Northern Latitude (LAT_N in STATION).
--* d happens to equal the maximum value in Western Longitude (LONG_W in STATION).
-- Query the Manhattan Distance between points P1 and P2 and round it to a scale of 4 decimal places.

SELECT CAST(((MAX(LAT_N)-MIN(LAT_N))+(MAX(LONG_W)-MIN(LONG_W)))AS NUMERIC (7,4))
FROM STATION

--Consider P1(a,c) and P2(b,d) to be two points on a 2D plane where (a,b) are the respective 
--minimum and maximum values of Northern Latitude (LAT_N) and (c,d) are the respective minimum 
--and maximum values of Western Longitude (LONG_W) in STATION.

--Query the Euclidean Distance between points P1 and P2 and format your answer to display 
--4 decimal digits.

SELECT CAST((SQRT(((POWER((MAX(LAT_N)-MIN(LAT_N)),2))+(POWER((MAX(LONG_W)-MIN(LONG_W)),2))))) AS NUMERIC (7,4))
FROM STATION ;

--A median is defined as a number separating the higher half of a data set from the lower half.
--Query the median of the Northern Latitudes (LAT_N) from STATION and round your answer to 4 decimal places.

SELECT CAST ((SELECT 
(
 (SELECT MAX(LAT_N) FROM
   (SELECT TOP 50 PERCENT LAT_N FROM STATION ORDER BY LAT_N) AS BottomHalf)
 +
 (SELECT MIN(LAT_N) FROM
   (SELECT TOP 50 PERCENT LAT_N FROM STATION ORDER BY LAT_N DESC) AS TopHalf)
) / 2 AS Median)AS NUMERIC (6,4)) 

--Given the CITY and COUNTRY tables, query the sum of the populations of all cities where 
--the CONTINENT is 'Asia'.
--Note: CITY.CountryCode and COUNTRY.Code are matching key columns.

SELECT SUM(CI.POPULATION)
FROM CITY AS CI
LEFT JOIN COUNTRY AS CO
ON CI.COUNTRYCODE=CO.CODE
WHERE CONTINENT ='Asia'

--Given the CITY and COUNTRY tables, query the names of all the continents (COUNTRY.Continent) 
--and their respective average city populations (CITY.Population) rounded down to the nearest integer.
--Note: CITY.CountryCode and COUNTRY.Code are matching key columns.

SELECT CO.CONTINENT , ROUND(AVG(CI.POPULATION),0) AS CI_POPULATION
FROM COUNTRY AS CO
LEFT JOIN CITY AS CI
ON CO.CODE=CI.COUNTRYCODE
WHERE CI.POPULATION IS NOT NULL
GROUP BY CO.CONTINENT
ORDER BY CI_POPULATION  

--Ketty gives Eve a task to generate a report containing three columns: Name, Grade and Mark. 
--Ketty doesn't want the NAMES of those students who received a grade lower than 8. The report must 
--be in descending order by grade -- i.e. higher grades are entered first. If there is more than 
--one student with the same grade (8-10) assigned to them, order those particular students by their
--name alphabetically. Finally, if the grade is lower than 8, use "NULL" as their name and list them
--by their grades in descending order. If there is more than one student with the same grade (1-7) 
--assigned to them, order those particular students by their marks in ascending order.

SELECT CASE WHEN g.Grade < 8 THEN NULL ELSE s.Name END as Name,
    g.Grade, s.Marks 
FROM Students AS s 
INNER JOIN Grades AS g 
ON s.Marks BETWEEN g.Min_Mark AND g.Max_Mark
ORDER BY g.Grade DESC, s.Name;

--Julia just finished conducting a coding contest, and she needs your help assembling the leaderboard! 
--Write a query to print the respective hacker_id and name of hackers who achieved full scores for more
--than one challenge. Order your output in descending order by the total number of challenges in which 
--the hacker earned a full score. If more than one hacker received full scores in same number of challenges, 
--then sort them by ascending hacker_id.

SELECT h.hacker_id , h.name
FROM submissions s
INNER JOIN hackers h on h.hacker_id = s.hacker_id
INNER JOIN challenges c on c.challenge_id = s.challenge_id
INNER JOIN difficulty d on d.difficulty_level = c.difficulty_level
WHERE s.score = d.score
AND c.difficulty_level = d.difficulty_level            
GROUP BY h.hacker_id ,h.name
HAVING COUNT(s.submission_id) > 1
ORDER BY COUNT(s.submission_id) DESC, h.hacker_id ASC


--Julia asked her students to create some coding challenges. Write a query to print the hacker_id, name, 
--and the total number of challenges created by each student. Sort your results by the total number of
--challenges in descending order. If more than one student created the same number of challenges, 
--then sort the result by hacker_id. If more than one student created the same number of challenges 
--and the count is less than the maximum number of challenges created, then exclude those students
--from the result.

SELECT H.hacker_id,name,COUNT(challenge_id) AS num_challenges
FROM Hackers AS H
LEFT JOIN Challenges AS C
ON H.hacker_id=C.hacker_id
GROUP BY H.hacker_id,name
HAVING COUNT(challenge_id) =(SELECT MAX(NUM) 
                             FROM (SELECT COUNT(challenge_id) AS NUM
                                   FROM Hackers AS H
                                   LEFT JOIN Challenges AS C
                                   ON H.hacker_id=C.hacker_id
                                   GROUP BY H.hacker_id,name) AS D) 
       OR COUNT(challenge_id) IN (SELECT Z 
	                              FROM (SELECT DISTINCT num_challenges AS Z,COUNT(num_challenges) AS A 
								        FROM (SELECT H.hacker_id,name,COUNT(challenge_id) AS  num_challenges 
								              FROM Hackers AS H 
                                              LEFT JOIN Challenges AS C
                                              ON H.hacker_id=C.hacker_id
                                              GROUP BY H.hacker_id,name) AS X
                                              GROUP BY num_challenges
                                 HAVING COUNT(num_challenges)=1)AS H)
ORDER BY num_challenges DESC , hacker_id;


--The total score of a hacker is the sum of their maximum scores for all of the challenges. 
--Write a query to print the hacker_id, name, and total score of the hackers ordered by the descending score.
--If more than one hacker achieved the same total score, then sort the result by ascending hacker_id. 
--Exclude all hackers with a total score of O from your result.


SELECT Z.hacker_id,name,TOTAL_SCORE FROM (SELECT hacker_id,SUM(MAX_SCORE)AS TOTAL_SCORE 
                                          FROM(SELECT hacker_id,challenge_id,MAX(score) AS MAX_SCORE
                                               FROM Submissions 
                                               GROUP BY hacker_id,challenge_id) AS X
                                          GROUP BY hacker_id
                                          HAVING SUM(MAX_SCORE)<>0) AS Z
LEFT JOIN Hackers AS H
ON Z.hacker_id=H.hacker_id
ORDER BY TOTAL_SCORE DESC,hacker_id


--You are given a table, Projects, containing three columns: Task_ID, Start_Date and End_Date. 
--It is guaranteed that the difference between the End_Date and the Start_Date is equal to 1 day
--for each row in the table.

--If the End_Date of the tasks are consecutive, then they are part of the same project. 
--Samantha is interested in finding the total number of different projects completed.
--Write a query to output the start and end dates of projects listed by the number of days it 
--took to complete the project in ascending order. If there is more than one project that have 
--the same number of completion days, then order by the start date of the project.

SELECT Start_Date,End_Date
FROM
    (SELECT Start_Date,End_Date,DATEDIFF (DAY,Start_Date,End_Date) AS B 
     FROM
         (SELECT Start_Date,End_Date
          FROM
             (SELECT End_Date,ROW_NUMBER() OVER(ORDER BY End_Date) AS ROW_NUM 
              FROM Projects
              WHERE End_Date NOT IN (SELECT Start_Date FROM Projects)) AS X
              LEFT JOIN 
             (SELECT Start_Date,ROW_NUMBER() OVER(ORDER BY Start_Date) AS ROW_NUM
              FROM Projects
              WHERE Start_Date NOT IN (SELECT End_Date FROM Projects)) AS Z
              ON X.ROW_NUM=Z.ROW_NUM) AS Y)AS M
ORDER BY B ,Start_Date 

--You are given three tables: Students, Friends and Packages. Students contains two columns: ID and Name. 
--Friends contains two columns: ID and Friend_ID (ID of the ONLY best friend). Packages contains two columns:
--ID and Salary (offered salary in $ thousands per month).

--Write a query to output the names of those students whose best friends got offered a higher salary
--than them. Names must be ordered by the salary amount offered to the best friends. It is guaranteed
--that no two students got same salary offer.

SELECT Nameofbestfriend 
FROM (SELECT X.Name,X.Salary AS friendSalary ,Y.Name AS Nameofbestfriend,Y.Salary AS Friend_salary 
      FROM (SELECT S.ID,Name,Salary,Friend_ID
            FROM Students AS S
            LEFT JOIN Friends AS F
            ON S.ID=F.ID
            LEFT JOIN Packages AS P
            ON P.ID=S.ID) AS X
            LEFT JOIN 
           (SELECT S.ID,Name,Salary,Friend_ID
            FROM Students AS S
            LEFT JOIN Friends AS F
            ON S.ID=F.ID
            LEFT JOIN Packages AS P
            ON P.ID=S.ID) AS Y
            ON X.ID=Y.Friend_ID
      WHERE X.Salary>Y.Salary) AS F
ORDER BY friendSalary


--You are given a table, Functions, containing two columns: X and Y.
--Two pairs (X1, Y1) and (X2, Y2) are said to be symmetric pairs if X1 = Y2 and X2 = Y1.
--Write a query to output all such symmetric pairs in ascending order by the value of X. 
--List the rows such that X1 <= Y1.

SELECT X,Y
FROM Functions
WHERE X=Y
GROUP BY X,Y
HAVING count(*) = 2
UNION
SELECT F1.X, F1.Y
FROM functions AS F1
    INNER JOIN functions AS F2
    ON F1.X = F2.Y AND F1.Y = F2.X
WHERE F1.X < F1.Y
ORDER BY X ;

--Samantha interviews many candidates from different colleges using coding challenges and contests.
--Write a query to print the contest_id, hacker_id, name, and the sums of total_submissions, 
--total_accepted_submissions, total_views, and total_unique_views for each contest sorted by contest_id. 
--Exclude the contest from the result if all four sums are .

--Note: A specific contest can be used to screen candidates at more than one college, but each college 
--only holds  screening contest.

SELECT C.contest_id,hacker_id,name,SUM(S.total_submissions),SUM(S.total_accepted_submissions),
       SUM(V.total_views),SUM(V.total_unique_views)
FROM Contests AS C
LEFT JOIN Colleges AS CO
ON CO.contest_id=C.contest_id
LEFT JOIN Challenges AS CH
ON CO.college_id=CH.college_id
LEFT JOIN (SELECT challenge_id,SUM(total_views)AS total_views,SUM(total_unique_views)AS total_unique_views
           FROM View_Stats GROUP BY challenge_id) AS V
ON V.challenge_id=CH.challenge_id
LEFT JOIN (SELECT challenge_id,SUM(total_submissions)AS total_submissions,SUM(total_accepted_submissions)AS total_accepted_submissions
           FROM Submission_Stats GROUP BY challenge_id ) AS S
ON CH.challenge_id=S.challenge_id
GROUP BY C.contest_id,hacker_id,name
HAVING SUM(total_submissions)>0 OR SUM(total_accepted_submissions)>0 OR
       SUM(total_views)>0 OR SUM(total_unique_views)>0
ORDER BY  C.contest_id 



--Julia conducted a 15 days of learning SQL contest. The start date of the contest was March 01, 2016 and 
--the end date was March 15, 2016.
--Write a query to print total number of unique hackers who made at least 1 submission each day 
--(starting on the first day of the contest), and find the hacker_id and name of the hacker who made 
--maximum number of submissions each day. If more than one such hacker has a maximum number of submissions, 
--print the lowest hacker_id. The query should print this information for each day of the contest,
--sorted by the date.

select X.submission_date, X.NUM_HACKER, Z.hacker_id, h.name
from
(select submission_date, count(distinct hacker_id) as NUM_HACKER
from 
(select s.*, dense_rank() over(order by submission_date) as date_rank, 
dense_rank() over(partition by hacker_id order by submission_date) as hacker_rank 
from Submissions s ) a 
where date_rank = hacker_rank 
group by submission_date) X 
join 
(select submission_date,hacker_id, 
 rank() over(partition by submission_date order by HACKER_COUNT desc, hacker_id) as max_rank 
from (select submission_date, hacker_id, count(*) as HACKER_COUNT 
      from Submissions 
      group by submission_date, hacker_id) b ) Z
on X.submission_date = Z.submission_date and Z.max_rank = 1 
join hackers h on h.hacker_id = Z.hacker_id 
order by 1 ;
 