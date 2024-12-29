--Step 01: Data Exploration
--View Data
SELECT * FROM dailyActivity_merged;

SELECT * FROM sleepDay_merged;

--List Column Names (Metadata inspection)
SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dailyActivity_merged';

SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'sleepDay_merged';


--Step 02: Data Cleaning
--Check for missing Values
SELECT
	SUM(CASE WHEN ActivityDate IS NULL THEN 1 ELSE 0 END) AS ActivityDate_missing,
	SUM(CASE WHEN TotalSteps IS NULL THEN 1 ELSE 0 END) AS TotalSteps_missing,
	SUM(CASE WHEN TotalDistance IS NULL THEN 1 ELSE 0 END) AS TotalDistance_missing,
	SUM(CASE WHEN TrackerDistance IS NULL THEN 1 ELSE 0 END) AS TrackerDistance_missing,
	SUM(CASE WHEN LoggedActivitiesDistance IS NULL THEN 1 ELSE 0 END) AS LoggedActivitiesDistance_missing,
	SUM(CASE WHEN VeryActiveDistance IS NULL THEN 1 ELSE 0 END) AS VeryActiveDistance_missing,
	SUM(CASE WHEN ModeratelyActiveDistance IS NULL THEN 1 ELSE 0 END) AS ModeratelyActiveDistance_missing,
	SUM(CASE WHEN LightActiveDistance IS NULL THEN 1 ELSE 0 END) AS LightActiveDistance_missing,
	SUM(CASE WHEN SedentaryActiveDistance IS NULL THEN 1 ELSE 0 END) AS SedentaryActiveDistance_missing,
	SUM(CASE WHEN VeryActiveMinutes IS NULL THEN 1 ELSE 0 END) AS VeryActiveMinutes_missing,
	SUM(CASE WHEN FairlyActiveMinutes IS NULL THEN 1 ELSE 0 END) AS FairlyActiveMinutes_missing,
	SUM(CASE WHEN LightlyActiveMinutes IS NULL THEN 1 ELSE 0 END) AS LightlyActiveMinutes_missing,
	SUM(CASE WHEN SedentaryMinutes IS NULL THEN 1 ELSE 0 END) AS SedentaryMinutes_missing,
	SUM(CASE WHEN Calories IS NULL THEN 1 ELSE 0 END) AS Calories_missing
FROM dailyActivity_merged;

CREATE TABLE cleaned_daily_activity (
    Id BIGINT,
    ActivityDate DATE,
    TotalSteps INT,
    TotalDistance FLOAT,
    TrackerDistance FLOAT,
    LoggedActivitiesDistance FLOAT,
    VeryActiveDistance FLOAT,
    ModeratelyActiveDistance FLOAT,
    LightActiveDistance FLOAT,
    SedentaryActiveDistance FLOAT,
    VeryActiveMinutes INT,
    FairlyActiveMinutes INT,
    LightlyActiveMinutes INT,
    SedentaryMinutes INT,
    Calories INT
);


-- Remove Duplicates
INSERT INTO cleaned_daily_activity
SELECT DISTINCT * FROM dailyActivity_merged;

-- Check for Duplicate IDs
SELECT Id, COUNT(*) AS record_count
FROM dailyActivity_merged
GROUP BY Id
HAVING COUNT(*) > 1;

SELECT Id, COUNT(*) AS record_count
FROM sleepDay_merged
GROUP BY Id
HAVING COUNT(*) > 1;

-- Date Format Consistency
-- Add a new column 'ActivityDate' to 'sleep_day' table
ALTER TABLE sleepDay_merged
ADD ActivityDate DATE;

-- Update 'ActivityDate' by converting 'SleepDay' to DATE format
UPDATE sleepDay_merged
SET ActivityDate = CONVERT(DATE, SleepDay, 101);
-- 101 specifies the MM/DD/YYYY format in SQL Server

-- Modify the 'ActivityDate' column in 'daily_activity' table to ensure it's a DATE type
ALTER TABLE dailyActivity_merged
ALTER COLUMN ActivityDate DATE;
-- This assumes 'ActivityDate' is already stored as a convertible type (e.g., VARCHAR or similar)

-- Data Summary
-- Count Unique Participants
SELECT COUNT(DISTINCT Id) AS unique_participants FROM dailyActivity_merged;

SELECT COUNT(DISTINCT Id) AS unique_participants FROM sleepDay_merged;

-- Count Total Observations
SELECT COUNT(*) AS total_observations FROM dailyActivity_merged;

SELECT COUNT(*) AS total_observations FROM sleepDay_merged;

-- Summary Satistics
SELECT 
    MIN(TotalSteps) AS min_steps,
    MAX(TotalSteps) AS max_steps,
    AVG(TotalSteps) AS avg_steps,
    MIN(TotalDistance) AS min_distance,
    MAX(TotalDistance) AS max_distance,
    AVG(TotalDistance) AS avg_distance,
    MIN(SedentaryMinutes) AS min_sedentary,
    MAX(SedentaryMinutes) AS max_sedentary,
    AVG(SedentaryMinutes) AS avg_sedentary
FROM dailyActivity_merged;


SELECT 
    MIN(TotalMinutesAsleep) AS min_asleep,
    MAX(TotalMinutesAsleep) AS max_asleep,
    AVG(TotalMinutesAsleep) AS avg_asleep,
    MIN(TotalTimeInBed) AS min_in_bed,
    MAX(TotalTimeInBed) AS max_in_bed,
    AVG(TotalTimeInBed) AS avg_in_bed
FROM sleepDay_merged;
