-- preview the table 
SELECT * 
FROM world_life_expectancy.worldlifeexpectancy_test
LIMIT 10;

-- data cleaning part of project

-- find duplicates - output will be the duplicates
SELECT country, year, COUNT(country)  
FROM world_life_expectancy.worldlifeexpectancy_test
GROUP BY country, year 
HAVING COUNT(country) > 1
;

-- 

-- removing duplicates
DELETE FROM world_life_expectancy.worldlifeexpectancy_test
WHERE (Country, Year) IN (
SELECT Country, Year 
FROM
(SELECT country, year, COUNT(country)  
FROM world_life_expectancy.worldlifeexpectancy_test
GROUP BY country, year 
HAVING COUNT(country) > 1
) AS duplicates
);

-- to test  if duplicates are gone use the query below, which copy and paste from the previous query
SELECT country, year, COUNT(country)  
FROM world_life_expectancy.worldlifeexpectancy_test
GROUP BY country, year 
HAVING COUNT(country) > 1
;

-- notice the status  column have  missing values
SELECT Country, year, status
FROM world_life_expectancy.worldlifeexpectancy_test
where status = ''
;

-- output format Country(year): country Afghanistan(2014), Albania(2021), Georgia(2010), Georgia(2012),
-- United State of America(2021), Vanuatu(2020), Zambia(2016), Zambia(2012)

-- to resolve I would look at each country previous year and the year after, most status are most likely the same 
SELECT country, year, status
FROM world_life_expectancy.worldlifeexpectancy_test
WHERE Country = 'Afghanistan' AND YEAR IN(2013,2014,2015)
;
-- output afghanistan status was 'Developing'

-- Update status of Afghanistan status to 'Developing'
UPDATE world_life_expectancy.worldlifeexpectancy_test
SET status = 'Developing'
WHERE Country = 'Afghanistan' AND year = 2014
;


-- look at the previous year and the year after, to determine the status to ensure consistency 
SELECT country, year, status
FROM world_life_expectancy.worldlifeexpectancy_test
WHERE Country = 'Albania' AND YEAR IN(2020,2021,2022)
;


-- update albania status to 'Developing'
UPDATE world_life_expectancy.worldlifeexpectancy_test
SET status = 'Developing'
WHERE Country = 'Albania' AND year = 2021
;

-- just to hang of things , I will examine two countries at time
SELECT country, year, status
FROM world_life_expectancy.worldlifeexpectancy_test
WHERE (Country = 'Georgia' AND YEAR IN(2009,2010,2011,2012, 2013))
OR Country = 'Vanuatu' AND YEAR IN(2019,2020,2021)
;

-- update  status for Georgia and Vanuatu
UPDATE world_life_expectancy.worldlifeexpectancy_test
SET status = 'Developing'
WHERE (Country = 'Georgia' AND year IN(2010,2012))
OR (Country = 'Vanuatu' AND year = 2020) 
;

-- evaluation of status based on previous year and one year after
SELECT country, year, status
FROM world_life_expectancy.worldlifeexpectancy_test
WHERE Country = 'Zambia' AND YEAR IN(2011,2012,2013,2014,2015,2016,2017)
OR Country = 'United States of America' AND YEAR IN (2020, 2021, 2022)
;


-- lastly United states of America and Zambia
-- Zambia update
UPDATE world_life_expectancy.worldlifeexpectancy_test
SET status = 'Developing'
WHERE (Country = 'Zambia' AND year IN(2012,2016))
;

-- united status update
UPDATE world_life_expectancy.worldlifeexpectancy_test
SET status = 'Developed'
WHERE (Country = 'United States of America' AND year = 2021)
;

-- Continue data cleaning: Life expectancy have some missing values and also check if any invalid values such as 0(zero)
SELECT Country, Year, `Life expectancy`
FROM world_life_expectancy.worldlifeexpectancy_test
WHERE `Life expectancy` = ''
;
-- output Afghanistan(2018), Albania(2018)

-- to resolve missing took the average of the previous year
-- start with afghanist I will take the average life expectancy of 
SELECT Country, Year, `Life expectancy`
FROM world_life_expectancy.worldlifeexpectancy_test
WHERE Country = 'Afghanistan'
;

-- took the average life expectancy of 2016,2017, 2019 roudn to 1 to keep standardize number set for life expectancy
SELECT ROUND(AVG(`Life expectancy`),1) as avg_life_expectancy
FROM world_life_expectancy.worldlifeexpectancy_test
WHERE Country = 'Afghanistan' AND YEAR IN(2016,2017, 2019)
;
-- output: 59 years old

-- update missing  Afghanistan life expectancy
UPDATE world_life_expectancy.worldlifeexpectancy_test
SET `Life expectancy` = 59
WHERE  Country = 'Afghanistan' AND YEAR = 2018
;

-- find the average of life expectancy 
SELECT ROUND(AVG(`Life expectancy`),1) as avg_life_expectancy
FROM world_life_expectancy.worldlifeexpectancy_test
WHERE Country = 'Albania' AND YEAR IN(2016,2017, 2019)
;
-- output 76.4

-- update albania life expectancy, based on the average 
UPDATE world_life_expectancy.worldlifeexpectancy_test
SET `Life expectancy` = 76.4
WHERE  Country = 'Albania' AND YEAR = 2018
;

/* 
Note: some column/field have zero, possible a data issue or possibly some countries didn't report
*/

