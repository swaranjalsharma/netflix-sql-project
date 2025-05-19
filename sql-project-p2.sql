SELECT * FROM netflix

-- 1. Count the Number of Movies vs TV Shows
SELECT type,COUNT(*) FROM netflix
GROUP BY type

-- 2. Find the Most Common Rating for Movies and TV Shows
SELECT 
	type,
	rating
FROM 
(
	SELECT 
		type,
		rating,
		COUNT(*),
		RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) as ranking
	FROM netflix
	GROUP BY 1,2
	) as t1
WHERE 
	ranking = 1
	
-- List All Movies Released in a Specific Year (e.g., 2020)
SELECT COUNT(*) FROM netflix
	WHERE type = 'Movie' AND release_year = 2020

--  Find the Top 5 Countries with the Most Content on Netflix
SELECT 
	new_country,
	COUNT(*) AS most_content 
FROM (
	SELECT 
	unnest(STRING_TO_ARRAY(country,',')) AS new_country 
FROM netflix	
)
GROUP BY new_country
ORDER BY most_content DESC LIMIT 5

-- Identify the Longest Movie
SELECT * FROM netflix
WHERE type = 'Movie'
AND duration = (SELECT MAX(duration) FROM netflix)


-- Find Content Added in the Last 5 Years
SELECT *
FROM netflix
WHERE
	TO_DATE(date_added,'Month DD,YYYY') >= CURRENT_DATE - INTERVAL '5 YEARS'

-- Find All Movies/TV Shows by Director 'Rajiv Chilaka'
SELECT * FROM netflix
WHERE director LIKE '%Rajiv Chilaka%'

-- List All TV Shows with More Than 5 Seasons
SELECT * FROM netflix
WHERE type = 'TV Show'
AND 
SPLIT_PART(duration, '',1) > '5 seasons'

-- Count the Number of Content Items in Each Genre
SELECT 
	genre,
	COUNT(*) AS most_content 
FROM (
	SELECT 
	unnest(STRING_TO_ARRAY(listed_in,',')) AS genre 
FROM netflix	
)
GROUP BY genre
ORDER BY most_content DESC LIMIT 5

-- Find each year and the average numbers of content release in India on netflix.
SELECT 
	EXTRACT(YEAR FROM TO_DATE(date_added,'Month DD,YYYY')) AS year,
	COUNT(*)
FROM netflix
WHERE country = 'India'
GROUP BY 1

-- List All Movies that are Documentaries
SELECT * FROM netflix
WHERE listed_in LIKE '%Documentaries%'

--  Find All Content Without a Director
SELECT * FROM netflix
WHERE director IS NULL

-- Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years
SELECT * FROM netflix
WHERE casts LIKE '%Salman Khan%'
AND
release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10

-- Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India
SELECT 
	UNNEST(STRING_TO_ARRAY(casts,',')) AS actor,
	COUNT(*)
FROM netflix
WHERE country = 'India'
GROUP BY actor
ORDER BY COUNT(*) DESC
LIMIT 10

-- Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords
SELECT 
	category,
	COUNT(*) AS count_content
FROM 
	(SELECT 
		CASE
			WHEN Description LIKE '%Kill%' OR Description LIKE '%Violence%' THEN 'Bad'
			ELSE 'Good'
		END as category
		FROM netflix) AS categorized_content	
GROUP BY category