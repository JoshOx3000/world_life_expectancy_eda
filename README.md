# world_life_expectancy_eda
SQL EDA project for World Life Expectancy



# World Life Expectancy Analysis

## Project Overview

This project analyzes life expectancy data across different countries and explores correlations between life expectancy and various factors such as GDP, schooling, and BMI. The goal of the analysis is to uncover potential reasons behind lower or higher life expectancies in different countries and offer recommendations based on these insights.

## Dataset

The dataset used in this analysis includes data on:
- Life Expectancy: The average number of years a person is expected to live in a specific country.
- GDP: Gross Domestic Product per country.
- Schooling: The average number of years of education per person in a country.
- BMI: Body Mass Index, indicating the average BMI across the population of each country.
- Status: Whether the country is considered developed or developing.

## Key Findings

1. **Life Expectancy vs. GDP**:
   - Countries with higher GDP tend to have better health systems and, as a result, higher life expectancy. 
   - Developing nations generally have lower GDP and tend to fall below the world average life expectancy of 69 years.
   - Countries with a GDP range of 55.8 to 57,363.1 are the most likely to have below-average life expectancy.

2. Life Expectancy vs. Schooling:
   - Countries with higher levels of education tend to have longer life expectancy. Education is crucial for raising health awareness, hygiene practices, and access to better jobs, all of which contribute to longer lives.
   - Countries with **below-average education** could benefit from health education programs aimed at increasing life expectancy.

3. **Life Expectancy vs. BMI**:
   - Countries with higher BMI levels tend to have longer life expectancy. This could be attributed to access to abundant food resources and potentially better healthcare.
   - Some countries in the dataset had missing or zero values for life expectancy, which could be due to a lack of reporting.

4. **Data Cleaning**:
   - During the analysis, **data cleaning** was performed to remove records where **life expectancy was zero**. These rows were excluded from the analysis to ensure that the results reflect accurate data.
   - This cleaning process ensures the integrity of the data and provides more meaningful insights.

## Analysis Approach

The following SQL queries were used to explore the relationships between life expectancy and various factors:

- **Average Life Expectancy by Country**:
  ```sql
  SELECT Country, ROUND(AVG(`Life expectancy`), 1) AS country_life_expectancy
  FROM world_life_expectancy.worldlifeexpectancy_test
  GROUP BY country;
  ```

- **World Average Life Expectancy**:
  ```sql
  SELECT ROUND(AVG(`Life expectancy`), 1) AS avg_world_life_expectancy
  FROM world_life_expectancy.worldlifeexpectancy_test;
  ```

- **Categorizing Countries by Life Expectancy**:
  Countries were categorized as having **Above Average**, **Average**, or **Below Average** life expectancy based on the world average:
  ```sql
  SELECT DISTINCT Country, 
         Status,
         ROUND(AVG(`Life expectancy`), 1) AS avg_life_expectancy,
         AVG(GDP) AS avg_gdp,
         CASE 
            WHEN ROUND(AVG(`Life expectancy`), 1) > 69 THEN 'Above Average'
            WHEN ROUND(AVG(`Life expectancy`), 1) = 69 THEN 'Average'
            ELSE 'Below Average'
         END AS 'Life Expectancy Categorized'
  FROM world_life_expectancy.worldlifeexpectancy_test
  GROUP BY Country, Status;
  ```

- **Life Expectancy vs. Schooling**:
  ```sql
  SELECT DISTINCT country, 
         ROUND(AVG(`Life expectancy`),1) AS avg_life_expectancy, 
         ROUND(AVG(Schooling), 1) AS avg_schooling
  FROM world_life_expectancy.worldlifeexpectancy_test
  GROUP BY country
  HAVING avg_life_expectancy <> 0 AND avg_schooling <> 0;
  ```

- **Life Expectancy vs. BMI**:
  ```sql
  SELECT Country,
         ROUND(AVG(`Life expectancy`),1) AS avg_life_expectancy,
         ROUND(AVG(BMI),1) AS avg_bmi,
         MAX(BMI) AS max_bmi,
         MIN(BMI) AS min_bmi
  FROM world_life_expectancy.worldlifeexpectancy_test
  WHERE `Life expectancy` > 0
  GROUP BY country
  ORDER BY avg_bmi DESC;
  ```

## Recommendations

1. **Health System Investments**: Countries with **lower GDP** and **below-average life expectancy** should focus on investing in health infrastructure. More resources can improve access to healthcare and increase life expectancy.
   
2. **Health Education**: Countries with **lower education levels** tend to have lower life expectancy. Implementing **health education programs** that focus on hygiene, nutrition, and preventive healthcare can positively impact the population’s overall health and longevity.

3. **BMI Awareness**: While a higher BMI correlates with longer life expectancy, this may reflect access to abundant food and healthcare in wealthier nations. Developing countries should balance BMI and health promotion to avoid issues related to both malnutrition and obesity.

4. **Data Integrity**: Countries with missing or zero life expectancy data should work to improve their health data reporting systems to provide more accurate health statistics for future research.

## Future Work

- Further analysis of other health indicators such as **disease prevalence**, **access to clean water**, and **pollution levels**.
- More in-depth analysis of specific countries or regions to identify localized health challenges and opportunities for improvement.

