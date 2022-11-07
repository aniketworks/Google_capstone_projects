--    ============================================================
--  ||   Dialect of SQL: BigQuery(Google Standard SQL dialect)    ||
--  ||   Project Name: BellaBeat, part of Google Capstone Project ||
--  ||   Author: Aniket Parab                                     ||
--  ||   Last Updated on: 07-11-2022                              ||
--    ============================================================

-- Checking number of unique user data to work with

-- 1. dailyActivity
SELECT
  DISTINCT Id
FROM
  `Fitabase_Data_4_12_16_5_12_16.dailyActivity_merged`
;
-- It has 33 users

-- 1.1 Looking for possible duplicate data
SELECT
  Id, ActivityDate, COUNT(*) AS rowNum
FROM
  `Fitabase_Data_4_12_16_5_12_16.dailyActivity_merged`
GROUP BY
  Id, ActivityDate
HAVING
  rowNum > 1
;
-- No duplicate rows, Nothing displayed

-- 1.2 Checking if there are any records with zero steps day in dailyActivity_merged

SELECT
  *
FROM
  `Fitabase_Data_4_12_16_5_12_16.dailyActivity_merged`
WHERE
  TotalSteps = 0
;
-- There are 77 entries with 0 TotalSteps. We can say that these are the days when
-- users forgot to wear Fitbit. Hence removing the records to clean the table

SELECT
  *
FROM
  `Fitabase_Data_4_12_16_5_12_16.dailyActivity_merged`
WHERE
  TotalSteps <> 0
;
-- Saved result of the above query as dailyActivity_merged_cleaned
--================================================================================

-- 2. sleepDay
SELECT
  DISTINCT Id
FROM
  `Fitabase_Data_4_12_16_5_12_16.sleepDay_merged`
;
-- It has 24 users

-- 2.1 Checking if there are any duplicate records in this table
SELECT *, COUNT(*) AS rowNum
FROM
  `Fitabase_Data_4_12_16_5_12_16.sleepDay_merged`
GROUP BY
  Id, SleepDay, TotalSleepRecords, TotalMinutesAsleep, TotalTimeInBed
HAVING
  rowNum = 1
;
-- Three duplicate records were found


-- Selecting distinct records to remove duplicate records
SELECT
  DISTINCT *
FROM
  `Fitabase_Data_4_12_16_5_12_16.sleepDay_merged`
;

-- Saved the result as new table in BigQuery
-- The new table is called sleepDay_merged_cleaned
--================================================================================

-- 3. weightLogInfo
SELECT
  DISTINCT Id
FROM
  `Fitabase_Data_4_12_16_5_12_16.weightLogInfo_merged`
;
-- It has 8 users


-- 3.1 Checking if there are any duplicate records in this table
SELECT
  *, COUNT(*) AS rowNum
FROM
  `Fitabase_Data_4_12_16_5_12_16.weightLogInfo_merged`
GROUP BY
  1,2,3,4,5,6,7,8
HAVING
  rowNum > 1
;
#-- No Duplicate data to be displayed
--================================================================================


SELECT
  ActivityDate, EXTRACT(DAYOFWEEK FROM ActivityDate) AS DayOfWeek
FROM 
  `Fitabase_Data_4_12_16_5_12_16.dailyActivity_merged_cleaned`
;

SELECT
  ActivityDate,
  CASE
    WHEN DayOfWeek = 1 THEN 'Monday'
    WHEN DayOfWeek = 2 THEN 'Tuesday'
    WHEN DayOfWeek = 3 THEN 'Wednesday'
    WHEN DayOfWeek = 4 THEN 'Thursday'
    WHEN DayOfWeek = 5 THEN 'Friday'
    WHEN DayOfWeek = 6 THEN 'Saturday'
    WHEN DayOfWeek = 7 THEN 'Sunday'
  END AS weekdays
FROM
  (
  SELECT
    ActivityDate, EXTRACT(DAYOFWEEK FROM ActivityDate) AS DayOfWeek
  FROM 
    `Fitabase_Data_4_12_16_5_12_16.dailyActivity_merged_cleaned`
  ) AS temp
;