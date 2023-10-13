
Select * From movies
Order by genres;

--Genres stored as JSON Objects
--Using JSON functions in sql
Select JSON_VALUE(genres, '$[0].name') as genre1,
	   JSON_VALUE(genres, '$[1].name') as genre2,
	   JSON_VALUE(genres, '$[2].name') as genre3,
	   JSON_VALUE(genres, '$[3].name') as genre4,
	   JSON_VALUE(genres, '$[4].name') as genre5,
	   JSON_VALUE(genres, '$[5].name') as genre6
From movies;

--Create a new column 'genre_list' to store the genres as comma-separated string
Alter table movies
Add genre_list nvarchar(max);
--Insert the data extracted
UPDATE movies
SET genre_list = (
    SELECT STRING_AGG(JSON_VALUE(value, '$.name'), ', ')
    FROM OPENJSON(genres)
);

--Check for the inconsistent data
Select *
From movies 
Where budget < 7000
Order by budget desc;

--Delete the inconsistent data
Delete From movies
Where budget < 7000;

--Extract months and assign seasons
Select Month(release_date), 
	   CASE 
		WHEN Month(release_date) in (12,1,2) THEN 'Winter'
		WHEN Month(release_date) in (3,4,5) THEN 'Spring'
		WHEN Month(release_date) in (6,7,8) THEN 'Summer'
		ELSE 'Fall'
		END as Season
From movies;

--Add a season column
Alter table movies
Add Season nvarchar(55);
--Update the data using case statements
Update movies
Set Season = CASE 
		WHEN Month(release_date) in (12,1,2) THEN 'Winter'
		WHEN Month(release_date) in (3,4,5) THEN 'Spring'
		WHEN Month(release_date) in (6,7,8) THEN 'Summer'
		ELSE 'Fall'
END;