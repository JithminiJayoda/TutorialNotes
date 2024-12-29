-- Step 1: Inspect the Data Structure
SELECT TOP 10 * FROM [AmazonCaseStudy].[dbo].[bestsellers];

-- Step 2: Check for Missing Values
SELECT
	SUM(CASE WHEN Name IS NULL THEN 1 ELSE 0 END) AS Missing_Name,
	SUM(CASE WHEN Author IS NULL THEN 1 ELSE 0 END) AS Missing_Author,
	SUM(CASE WHEN User_Rating IS NULL THEN 1 ELSE 0 END) AS Missing_User_Rating,
	SUM(CASE WHEN Reviews IS NULL THEN 1 ELSE 0 END) AS Missing_Reviews,
	SUM(CASE WHEN Year IS NULL THEN 1 ELSE 0 END) AS Missing_Year,
	SUM(CASE WHEN Genre IS NULL THEN 1 ELSE 0 END) AS Missing_Genre
FROM [AmazonCaseStudy].[dbo].[bestsellers];

-- Step 3: Check for Duplicates
SELECT *
FROM [AmazonCaseStudy].[dbo].[bestsellers]
GROUP BY Name, Author, [User_Rating], Reviews, Price, Year, Genre
HAVING COUNT(*) > 1;

-- Step 4: Data Analysis
-- 1. Genre Distribution
SELECT Genre, COUNT(*) AS Count
FROM [AmazonCaseStudy].[dbo].[bestsellers]
GROUP BY Genre;

-- 2. Top Authors by Number of Books
SELECT Top 10 Author, COUNT(*) AS Book_Count
FROM [AmazonCaseStudy].[dbo].[bestsellers]
GROUP BY Author
ORDER BY Book_Count DESC;

-- 3. Average User Ratig by Genre
SELECT Genre, AVG(User_Rating) AS Avg_Rating
FROM [AmazonCaseStudy].[dbo].[bestsellers]
GROUP BY Genre;

-- 4. Yearly Trends in Bestsellers
SELECT Year, Genre, COUNT(*) AS Count
FROM [AmazonCaseStudy].[dbo].[bestsellers]
GROUP BY Year, Genre
ORDER BY Year, Genre;

-- 5. Yearly Trends in Bestsellers
SELECT Year, Genre, COUNT(*) AS Count
FROM [AmazonCaseStudy].[dbo].[bestsellers]
GROUP BY Year, Genre
ORDER BY Year, Genre;

-- Step 5: Save Cleaned Data
-- (Optional: Export to a new table or export cleaned data to a CSV file using external tools)
SELECT * INTO cleaned_bestsellers FROM [AmazonCaseStudy].[dbo].[bestsellers];