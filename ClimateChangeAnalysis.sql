-- Monthly Temp Trends 

SELECT 
    Month_Year,
    round(AVG(Temperature), 1) AS Avg_Temperature
FROM (
    SELECT 
        STR_TO_DATE(`Date`, '%m/%d/%y') AS ParsedDate,
        DATE_FORMAT(STR_TO_DATE(`Date`, '%m/%d/%y'), '%M %Y') AS Month_Year,
        `Temperature`
    FROM ClimateChange.Combined_Data
    WHERE `Date` IS NOT NULL 
      AND `Date` <> '' 
      AND `Date` <> '0000-00-00'
) AS sub
GROUP BY Month_Year
ORDER BY MIN(ParsedDate) desc;

-- Avg Temperature per country on a any select date
select
	Country,
	round(avg(Temperature), 1) as Avg_Temperature
from ClimateChange.Combined_Data
where STR_TO_DATE(`Date`, '%m/%d/%y') BETWEEN '2025-02-14' AND '2025-02-22'
	and Temperature IS NOT NULL
group by Country
order by Avg_Temperature DESC;

-- Extreme Weather Events per month
SELECT 
    DATE_FORMAT(STR_TO_DATE(`Date`, '%m/%d/%y'), '%M') AS Month_Name,
    COUNT(*) AS Event_Count
FROM 
    ClimateChange.Combined_Data
WHERE 
    `Extreme Weather Events` <> 'None'
    AND `Date` IS NOT NULL
    AND `Date` <> ''
    AND `Date` <> '0000-00-00'
GROUP BY 
    DATE_FORMAT(STR_TO_DATE(`Date`, '%m/%d/%y'), '%M'),
    MONTH(STR_TO_DATE(`Date`, '%m/%d/%y'))
ORDER BY 
    MIN(STR_TO_DATE(`Date`, '%m/%d/%y'));
    
    
-- Extreme Weather Events Trend per country    
select Country,
	count(*) as Event_Count
from ClimateChange.Combined_Data
where `Extreme Weather Events` <> 'None'
group by Country
order by Event_Count desc;

-- Relationship between Temp and extreme weather
select
	case
		when Temperature < 10 then 'Very Cold(<10 C)'
        when Temperature between 10 and 15 then 'Cold(10-15 C)'
		when Temperature between 15 and 20 then 'Moderate(10-20 C)'
		when Temperature between 20 and 25 then 'Warm(20-25 C)'
        End as Temperature_Range,
        `Extreme Weather Events`,
        count(*) as Event_Count
from ClimateChange.Combined_Data
where `Extreme Weather Events` <> 'None'
group by Temperature_Range, `Extreme Weather Events`
order by Temperature_Range, Event_Count desc;

-- Finding which cities are experiencing extreme weather events this week and what is their economic and population impact
SELECT
    Country,
    City,
    STR_TO_DATE(`Date`, '%m/%d/%y') AS Parsed_Date,
    `Extreme Weather Events`,
    COUNT(*) AS Event_Type,
    ROUND(AVG(Temperature), 1) AS Avg_Temperature,
    SUM(`Population_Exposure`) AS Total_Economic_Impact,
    ROUND(AVG(`Infrastructure_Vulnerability_Score`), 0) AS Average_Vulnerability
FROM ClimateChange.Combined_Data
WHERE 
    STR_TO_DATE(`Date`, '%m/%d/%y') BETWEEN '2025-08-24' AND '2025-08-31'
    AND `Extreme Weather Events` <> 'None'
GROUP BY 
    Parsed_Date, Country, City, `Extreme Weather Events`
ORDER BY 
    Parsed_Date, Country, City;


-- Top 5 cities with the highest air quality concerns and their associated risks
SELECT 
    Country,
    City,
    STR_TO_DATE(`Date`, '%m/%d/%y') AS Parsed_Date,
    ROUND(AVG(`Air Quality Index`), 0) AS Avg_AQI,
    SUM(CASE WHEN `Air Quality Index` > 200 THEN 1 ELSE 0 END) AS Days_Above_200_AQI,
    SUM(`Population_Exposure`) AS Total_Population_Exposure,
    ROUND(AVG(Temperature), 1) AS Avg_Temperature
FROM ClimateChange.Combined_Data
WHERE STR_TO_DATE(`Date`, '%m/%d/%y') BETWEEN '2025-08-14' AND '2025-08-22'
GROUP BY Parsed_Date, Country, City
HAVING Avg_AQI > 100
ORDER BY Avg_AQI DESC
LIMIT 5;

-- biome types that are most risk from extreme weather events this week
SELECT
    `Biom_Type`,
    COUNT(*) AS Total_Records,
    COUNT(DISTINCT CONCAT(Country, '-', City)) AS Locations_Affected,
    COUNT(CASE WHEN `Extreme Weather Events` <> 'None' THEN 1 END) AS Extreme_Weather_Count,
    GROUP_CONCAT(DISTINCT `Extreme Weather Events` ORDER BY `Extreme Weather Events` SEPARATOR ', ') AS Event_Types,
    ROUND(AVG(Temperature), 1) AS Avg_Temperature,
    SUM(`Economic_Impact_Estimate`) AS Total_Economic_Impact_Estimate,
    ROUND(AVG(`Infrastructure_Vulnerability_Score`), 0) AS Avg_Vulnerability
FROM ClimateChange.Combined_Data
WHERE STR_TO_DATE(`Date`, '%m/%d/%y') BETWEEN '2025-05-14' AND '2025-05-22'
GROUP BY `Biom_Type`
ORDER BY Total_Economic_Impact_Estimate DESC
LIMIT 5;

    
