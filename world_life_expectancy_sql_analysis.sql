SELECT * 
FROM world_life_expectancy.worldlifeexpectancy_test
;


-- look at the average  life expectancy by country
SELECT Country, ROUND(AVG(`Life expectancy`), 1) as country_life_expectancy
FROM world_life_expectancy.worldlifeexpectancy_test
GROUP BY country
;


-- average world life- 
SELECT ROUND(AVG(`Life expectancy`), 1) as avg_world_life_expectancy
FROM world_life_expectancy.worldlifeexpectancy_test
;

-- output average age 69

-- now I will categorize countries life expectancy based on the world average
-- to later find why countries above average and below average

SELECT DISTINCT Country, 
	   Status,
       ROUND(AVG(`Life expectancy`), 1) AS avg_life_expectancy,
       AVG(GDP) AS avg_gdp,
CASE 
	WHEN ROUND(AVG(`Life expectancy`),1) > 69 THEN 'Above Average'
    WHEN ROUND(AVG(`Life expectancy`), 1) = 69 THEN 'Average'
    WHEN ROUND(AVG(`Life expectancy`), 1) < 69 THEN 'Below Average'
END AS 'Life Expectancy Categorized'
FROM world_life_expectancy.worldlifeexpectancy_test
GROUP BY Country, Status
HAVING AVG(`Life expectancy`) <> 0 -- excluding life expectancy = 0 
AND AVG(GDP) <> 0
;



-- count of the 
SELECT 
    `Life Expectancy Categorized`, 
    COUNT(DISTINCT Country) AS country_count
FROM (
    SELECT DISTINCT 
           Country, 
           Status,
           ROUND(AVG(`Life expectancy`), 1) AS avg_life_expectancy,
           AVG(GDP) AS avg_gdp,
           CASE 
               WHEN ROUND(AVG(`Life expectancy`), 1) > 69 THEN 'Above Average'
               WHEN ROUND(AVG(`Life expectancy`), 1) = 69 THEN 'Average'
               WHEN ROUND(AVG(`Life expectancy`), 1) < 69 THEN 'Below Average'
           END AS 'Life Expectancy Categorized'
    FROM world_life_expectancy.worldlifeexpectancy_test
    GROUP BY Country, Status
    HAVING AVG(`Life expectancy`) <> 0
    AND AVG(GDP) <> 0
) AS categorized_data
GROUP BY `Life Expectancy Categorized`;

-- output Above Average: 95, Below Average:63



SELECT 
    `Life Expectancy Categorized`, 
    status,
    avg_gdp
    -- COUNT(DISTINCT Country) AS country_count
FROM (
    SELECT DISTINCT 
           Country, 
           Status,
           ROUND(AVG(`Life expectancy`), 1) AS avg_life_expectancy,
           ROUND(AVG(GDP),1) AS avg_gdp,
           CASE 
               WHEN ROUND(AVG(`Life expectancy`), 1) > 69 THEN 'Above Average'
               WHEN ROUND(AVG(`Life expectancy`), 1) = 69 THEN 'Average'
               WHEN ROUND(AVG(`Life expectancy`), 1) < 69 THEN 'Below Average'
           END AS 'Life Expectancy Categorized'
    FROM world_life_expectancy.worldlifeexpectancy_test
    GROUP BY Country, Status
    HAVING AVG(`Life expectancy`) <> 0
    AND AVG(GDP) <> 0
) AS categorized_data
WHERE `Life Expectancy Categorized` = 'Below Average'
GROUP BY `Life Expectancy Categorized`, Status, avg_gdp;

-- commonly outcome developing nations have below average of world life expectancy


-- Next look  at the range of the average gdp, 
SELECT  
	 MIN(avg_gdp) AS min_range,
	MAX(avg_gdp) AS high_range
FROM (
	 SELECT DISTINCT 
           Country, 
           Status,
           ROUND(AVG(`Life expectancy`), 1) AS avg_life_expectancy,
           ROUND(AVG(GDP),1) AS avg_gdp
	  FROM world_life_expectancy.worldlifeexpectancy_test
      GROUP BY Country, Status
      HAVING AVG(`Life expectancy`) <> 0
      AND AVG(GDP) <> 0
      ) AS categorized_data
;
-- the gdp range of below average  life expectancy, focal point of countries that gdp fit in this range
-- out put  gdp range of 55.8 - 57363.1 are the most likely to have below average life expectancy

-- next look at another factor education, education will affect health awareness, hygiene practice and access to better jobs 
SELECT DISTINCT country, 
		ROUND(AVG(`Life expectancy`),1) AS avg_life_expectancy, 
        ROUND(AVG(Schooling), 1) AS avg_schooling
FROM world_life_expectancy.worldlifeexpectancy_test
GROUP BY country
HAVING avg_life_expectancy <> 0
AND avg_schooling <> 0
;
-- output notice a common patterns, the higher education level the higher life expectancy



-- I would like to look at the BMI maybe thats a factor in health and life expectancy
SELECT  
	   Country,
	   ROUND(AVG(`Life expectancy`),1) AS avg_life_expectancy,
	   ROUND(AVG(BMI),1) AS avg_bmi,
       MAX(BMI) AS max_bmi,
       MIN(BMI) AS min_bmi
FROM world_life_expectancy.worldlifeexpectancy_test
WHERE `Life expectancy` > 0 -- exclude life_exptectancy whre it = 0
GROUP BY country
ORDER BY avg_bmi DESC

;

-- note: not avg_life_expectancy contain 0, which is data issue, some countries didn't report it 
-- finding countries with higher bmi  have longer life expectancy
-- this could be related  to the mass amount food resource.








