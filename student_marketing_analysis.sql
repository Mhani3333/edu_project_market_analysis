/* Adding two CTEs, TotalCounts for total number of students
and CountryCounts for students from each country,
second CTE includes a row for all nationality grouped as "Other" */
WITH TotalCounts AS (
    SELECT COUNT(*) AS total_students
    FROM students
),
CountryCounts AS (
    SELECT 'Other' AS nationality, COUNT(*) AS student_count
    FROM students
    WHERE nationality != 'Saudi Arabia'
    UNION ALL
    SELECT nationality, COUNT(*) AS student_count
    FROM students
    GROUP BY nationality
)
/*Then combining both CTEs to get ratio of (students from each country:total students)*/
SELECT 
    nationality,
    ROUND((student_count * 100.0 / total_students), 2) AS percentage
FROM CountryCounts, TotalCounts
ORDER BY student_count DESC;


/* Next step is knowing the ratio of gender and age frames, to target audience more effiently*/

/*Forming CTE of how many male or female student in each age frame (-17 or 17-24 or +24) */
WITH GenderAge AS 
	(
	SELECT gender, 
	CASE WHEN EXTRACT(YEAR FROM AGE(current_date, date_of_birth)) BETWEEN 17 AND 24 THEN '17-24'
	WHEN EXTRACT (YEAR FROM AGE(current_date, date_of_birth)) > 24 THEN '+24'
	ELSE '-17' 
	END AS age_frame,
	COUNT (*) AS count_age
FROM students
GROUP BY gender, age_frame),
/* Then forming another CTE of total number of students */	
	TotalCounts AS 
	(
    SELECT COUNT(*) AS total_students
    FROM students
	)
/* Finally combinig both CTEs to get the ratio of (how many male or female in each age frame:total students) */	
SELECT gender, age_frame, 
	ROUND((count_age*100/total_students), 2) AS percentage
FROM GenderAge, TotalCounts
ORDER BY percentage DESC