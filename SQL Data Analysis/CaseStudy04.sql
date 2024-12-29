-- 1. Data Wrangling and Cleaning
-- Remove rows with invalid or missing IDs
SELECT *
INTO CleanedMovies
FROM MoviesMetadata
WHERE id IS NOT NULL AND id <> '';

-- Convert budget and revenue to numeric (Assuming columns are already numeric in SQL)
-- Filter out rows with zero or missing budget and revenue
DELETE FROM CleanedMovies
WHERE budget IS NULL OR budget <= 0 OR revenue IS NULL OR revenue <= 0;

-- Extract year from release_date and filter rows
ALTER TABLE CleanedMovies ADD release_year INT;

UPDATE CleanedMovies
SET release_year = YEAR(CAST(release_date AS DATE));

DELETE FROM CleanedMovies
WHERE release_year IS NULL OR release_year > 2017;

-----------------------------------------------------
-- 2. Parse Genres into Separate Rows
-- Extract genre names (assuming JSON parsing is required)
SELECT 
    id,
    JSON_VALUE(genres, '$.name') AS genre
INTO ParsedGenres
FROM CleanedMovies
CROSS APPLY OPENJSON(genres) WITH (name NVARCHAR(MAX) '$.name');

-- Clean extracted genres
UPDATE ParsedGenres
SET genre = REPLACE(genre, '''', '');

-----------------------------------------------------
-- 3. Data Transformation
-- Create ROI Column and Aggregate Data by Genre
-- Add ROI column
ALTER TABLE CleanedMovies ADD ROI FLOAT;

UPDATE CleanedMovies
SET ROI = (revenue - budget) / budget;

-- Aggregate data by genre
SELECT 
    g.genre,
    AVG(m.revenue) AS avg_revenue,
    AVG(m.budget) AS avg_budget,
    AVG(m.ROI) AS avg_ROI,
    COUNT(*) AS movie_count
INTO GenreSummary
FROM CleanedMovies m
JOIN ParsedGenres g ON m.id = g.id
GROUP BY g.genre
ORDER BY avg_revenue DESC;

-----------------------------------------------------
-- 4. Data Analysis and Visualization
-- Prepare Top 10 Genres by Average Revenue
SELECT TOP 10 *
FROM GenreSummary
ORDER BY avg_revenue DESC;

-- Prepare Data for ROI vs Budget
SELECT budget, ROI
FROM CleanedMovies
WHERE budget > 0 AND ROI IS NOT NULL;

-- Prepare Data for Revenue Distribution by Release Year
SELECT release_year, AVG(revenue) AS avg_revenue
FROM CleanedMovies
GROUP BY release_year
ORDER BY release_year;

-----------------------------------------------------
-- 5. Save Cleaned Data
-- Save Cleaned Movies Data
-- Save cleaned movies data to a CSV file
EXEC xp_cmdshell 'bcp "SELECT * FROM CleanedMovies" queryout "C:\Path\To\CleanedMoviesData.csv" -c -T';

-- Save Genre Summary Data
-- Save genre summary data to a CSV file
EXEC xp_cmdshell 'bcp "SELECT * FROM GenreSummary" queryout "C:\Path\To\GenreSummary.csv" -c -T';

-----------------------------------------------------
-- 6. Completion Message
PRINT 'Data cleaning, analysis, and preparation for visualization complete. Cleaned data and summaries saved.';
