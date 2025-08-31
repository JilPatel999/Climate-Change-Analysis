select *
from ClimateChange.Combined_Data
where "Record ID" is null
	or "Date" is null
    or "City" is null
    or "Temperature" is null
    or "Humidity" is null
    or "Precipitation" is null
    or "Air Quality Index" is null
    or "Extreme Weather Events" is null
    or "Climate Classification" is null
    or "Climate_Zone" is null
    or "Biom_Type" is null
    or "Heat_Index" is null
    or "Wind_Direction" is null
    or "Season" is null
    or "Population_Exposure" is null
    or "Economic_Impact_Estimate" is null
    or "Infrastructure_Vulnerability_Score" is null;
    
    
select * from ClimateChange.Combined_Data;
    
    