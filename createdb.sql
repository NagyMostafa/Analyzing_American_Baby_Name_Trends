DROP TABLE baby_names;

CREATE TABLE baby_names (
  year INT,
  first_name VARCHAR(64),
  sex VARCHAR(64),
  num INT
);

--1
-- Select first names and the total babies with that first_name
-- Group by first_name and filter for those names that appear in all 101 years
-- Order by the total number of babies with that first_name, descending
select top(8) first_name, sum(num) as sum
from baby_names
group by first_name
order by sum desc

--2
-- Classify first names as 'Classic', 'Semi-classic', 'Semi-trendy', or 'Trendy'
-- Alias this column as popularity_type
-- Select first_name, the sum of babies who have ever had that name, and popularity_type
-- Order the results alphabetically by first_name
select first_name, sum(num) as sum, 
(case when sum(num) <= 20 then 'Classic'
when sum(num) > 20 and sum(num) <= 50 then 'Semi-classic'
when sum(num) > 50 and sum(num) <= 80 then 'Semi-trendy'
else 'Trendy' end) as popularity_type
from baby_names
group by first_name
order by first_name 

--3
-- RANK names by the sum of babies who have ever had that name (descending), aliasing as name_rank
-- Select name_rank, first_name, and the sum of babies who have ever had that name
-- Filter the data for results where sex equals 'F'
-- Limit to ten results
select top(10) first_name,
       RANK() OVER(ORDER BY SUM(num) DESC) AS name_rank,
       sum(num) as sum
from baby_names
where sex ='F'
group by first_name

--4
-- Select only the first_name column
-- Filter for results where sex is 'F', year is greater than 2015, and first_name ends in 'a'
-- Group by first_name and order by the total number of babies given that first_name
select first_name
from baby_names
where sex ='F' and year > '2015' and first_name like '%a'
group by first_name
order by SUM(num) desc

--5
-- Select year, first_name, num of Olivias in that year, and cumulative_olivias
-- Sum the cumulative babies who have been named Olivia up to that year; alias as cumulative_olivias
-- Filter so that only data for the name Olivia is returned.
-- Order by year from the earliest year to most recent
select year, first_name, num,  SUM(num) OVER (ORDER BY year) AS cumulative_olivias
from baby_names
where first_name ='Olivia' 
group by year, first_name, num

--6
-- Select year and maximum number of babies given any one male name in that year, aliased as max_num
-- Filter the data to include only results where sex equals 'M'
select year, max(num) AS max_num
from baby_names
where sex='M'
group by year

--7
-- Select year, first_name given to the largest number of male babies, and num of babies given that name
-- Join baby_names to the code in the last task as a subquery
-- Order results by year descending
select B.year, B.first_name, B.num
from baby_names AS B
INNER JOIN (SELECT year, MAX(num) as max_num
    FROM baby_names
    WHERE sex = 'M'
    GROUP BY year) AS SS
ON SS.year = B.year 
    AND SS.max_num = B.num
ORDER BY B.year DESC

--8
-- Select first_name and a count of years it was the top name in the last task; alias as count_top_name
-- Use the code from the previous task as a common table expression
-- Group by first_name and order by count_top_name descending
CREATE TABLE BABYYEAR (
  year INT,
  first_name VARCHAR(64),
  num INT
);
INSERT INTO BABYYEAR  
 select B.year, B.first_name, B.num
  from baby_names AS B
  INNER JOIN (
     SELECT year, MAX(num) as max_num
     FROM baby_names
     WHERE sex = 'M'
     GROUP BY year
	 ) AS SS
    ON SS.year = B.year AND SS.max_num = B.num
    ORDER BY B.year DESC;

SELECT first_name, COUNT(*) as count_top_name
FROM BABYYEAR
GROUP BY first_name
ORDER BY count_top_name DESC;




