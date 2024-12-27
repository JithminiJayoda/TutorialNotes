CREATE DATABASE DivvyTripsDB;
GO
USE DivvyTripsDB;

CREATE TABLE Divvy_Trips_2019_Q1 (
	trip_id INT,
	start_time DATETIME,
	end_time DATETIME,
	bikeid INT,
	tripduration INT,
	from_station_id INT,
	from_station_name VARCHAR(100),
	to_station_id INT,
	to_station_name VARCHAR(100),
	usertype CHAR(20),
	gender CHAR(10),
	birthyear INT,
);

CREATE TABLE Divvy_Trips_2020_Q1 (
	ride_id VARCHAR(100),
	rideable_type VARCHAR(100),
	started_at DATETIME,
	ended_at DATETIME,
	start_station_name VARCHAR(100),
	start_station_id INT,
	end_station_name VARCHAR(100),
	end_station_id INT,
	start_lat INT,
	start_lng INT,
	end_lat INT,
	end_lng INT,
	member_casual CHAR(10)
);

--To read data into SQL
--Query data from the 2019 Q1 table
SELECT * FROM Divvy_Trips_2019_Q1_new;


--Query data from the 2020 Q1 table
SELECT * FROM Divvy_Trips_2020_Q1_new;


SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Divvy_Trips_2019_Q1_new';

SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Divvy_Trips_2020_Q1_new';


EXEC sp_rename 'dbo.Divvy_Trips_2019_Q1_new.trip_id', 'ride_id', 'COLUMN';
EXEC sp_rename 'Divvy_Trips_2019_Q1_new.bikeid', 'rideable_type', 'COLUMN';
EXEC sp_rename 'Divvy_Trips_2019_Q1_new.start_time', 'started_at', 'COLUMN';
EXEC sp_rename 'Divvy_Trips_2019_Q1_new.end_time', 'ended_at', 'COLUMN';
EXEC sp_rename 'Divvy_Trips_2019_Q1_new.from_station_name', 'start_station_name', 'COLUMN';
EXEC sp_rename 'Divvy_Trips_2019_Q1_new.from_station_id', 'start_station_id', 'COLUMN';
EXEC sp_rename 'Divvy_Trips_2019_Q1_new.to_station_name', 'end_station_name', 'COLUMN';
EXEC sp_rename 'Divvy_Trips_2019_Q1_new.to_station_id', 'end_station_id', 'COLUMN';
EXEC sp_rename 'Divvy_Trips_2019_Q1_new.usertype', 'member_casual', 'COLUMN';


SELECT 
    CAST(ride_id AS VARCHAR(MAX)) AS ride_id, 
    CAST(rideable_type AS VARCHAR(MAX)) AS rideable_type, 
    *
FROM Divvy_Trips_2019_Q1_new;


SELECT ride_id, started_at, ended_at, rideable_type, start_station_id, start_station_name, end_station_id, end_station_name, member_casual
FROM Divvy_Trips_2019_Q1_new
UNION ALL
SELECT ride_id, started_at, ended_at, rideable_type, start_station_id, start_station_name, end_station_id, end_station_name, member_casual
FROM Divvy_Trips_2020_Q1_new;


-- Check the structure of 2019 data
EXEC sp_help 'Divvy_trips_2019_Q1_new';

-- Check the structure of 2020 data
EXEC sp_help 'Divvy_trips_2020_Q1_new';

-- Combine data from 2019 and 2020
SELECT 
    ride_id, 
    started_at, 
    ended_at, 
    rideable_type, 
    tripduration, 
    start_station_id, 
    start_station_name, 
    end_station_id, 
    end_station_name, 
    member_casual, 
    gender, 
    birthyear
FROM Divvy_Trips_2019_Q1_new
UNION ALL
SELECT 
    ride_id, 
    started_at, 
    ended_at, 
    rideable_type, 
    NULL AS tripduration, 
    start_station_id, 
    start_station_name, 
    end_station_id, 
    end_station_name, 
    member_casual, 
    NULL AS gender, 
    NULL AS birthyear
FROM Divvy_Trips_2020_Q1_new;


-- Add a computed column for trip duration in minutes
ALTER TABLE Divvy_Trips_2019_Q1_new
ADD trip_duration_minutes AS (tripduration / 60.0);
