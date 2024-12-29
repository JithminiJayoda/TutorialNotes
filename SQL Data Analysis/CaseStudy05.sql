-- Step 1: Inspect the first few rows of the dataset
SELECT TOP 10 * FROM avocado;

-- Step 2: Check for missing values in the entire dataset
SELECT 
	SUM(CASE WHEN [Date] IS NULL THEN 1 ELSE 0 END) AS MissingDates,
	SUM(CASE WHEN [AveragePrice] IS NULL THEN 1 ELSE 0 END) AS MissingAveragePrice,
	SUM(CASE WHEN [Total_Volume] IS NULL THEN 1 ELSE 0 END) AS MissingTotalVolume
FROM avocado;

-- Step 3: Clean and prepare data
-- Remove rows with missing values
DELETE FROM avocado
WHERE [Date] IS NULL OR [AveragePrice] IS NULL OR [Total_Volume] IS NULL;

-- Remove duplicate rows
WITH CTE AS (
	SELECT *, ROW_NUMBER() OVER (PARTITION BY [Date], [AveragePrice], [Total_Volume] ORDER BY [XLarge_Bags]) AS RowNum
	FROM avocado
)
DELETE FROM CTE WHERE RowNum > 1;

-- Add Year and Month columns for trend analysis
ALTER TABLE avocado
ADD [Year] INT, [Month] NVARCHAR(20);

UPDATE avocado
SET [Year] = YEAR([Date]),
	[Month] = FORMAT([Date], 'MMM');

-- Step 4: Summary Statistics
-- Summary for AveragePrice
SELECT MIN(AveragePrice) AS MinPrice,
	PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY AveragePrice) AS FirstQuartile,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY AveragePrice) AS MedianPrice,
	PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY AveragePrice) AS ThirdQuartile,
	MAX(AveragePrice) AS MaxPrice
FROM avocado;

-- Summary for Total Volume
SELECT MIN(Total_Volume) AS MinVolume,
       PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY TotalVolume) AS FirstQuartile,
       PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY TotalVolume) AS MedianVolume,
       PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY TotalVolume) AS ThirdQuartile,
       MAX(Total_Volume) AS MaxVolume
FROM avocado;

-- Step 5: Total sales per region and type
SELECT [region], [type],
	   SUM(Total_Volume) AS TotalSales,
	   AVG(AveragePrice) AS AvgPrice
FROM avocado
GROUP BY [region], [type]
ORDER BY [region], [type];

-- Step 6: Visualizations (generate plots in your BI tool or Python using SQL queries as input)
-- Example for a time series query for Average Price over time
SELECT [Date], AVG(AveragePrice) AS AvgPrice
FROM avocado
GROUP BY [Date]
ORDER BY [Date];

-- Total Volume of Avocados Sold by Region
SELECT [region], SUM(Total_Volume) AS TotalVolume
FROM avocado
GROUP BY [region]
ORDER BY [region];

-- Average Price vs. Total Volume
SELECT Total_Volume, AveragePrice, [type]
FROM avocado;

-- Average Price by Type
SELECT [type], AVG(AveragePrice) AS AvgPrice
FROM avocado
GROUP BY [type];

-- Monthly Price Trends
SELECT [Year], [Month], AVG(AveragePrice) AS AvgPrice
FROM avocado
GROUP BY [Year], [Month]
ORDER BY [Year], [Month];
