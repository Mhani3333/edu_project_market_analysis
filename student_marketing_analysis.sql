WITH TotalCounts AS
	( SELECT COUNT(*) AS total_students
    FROM students ),
CountryCounts AS
	( SELECT 'Other' AS nationality, COUNT(*) AS student_count
    FROM students
    WHERE nationality != 'Saudi Arabia'
    UNION ALL
    SELECT nationality, COUNT(*) AS student_count
    FROM students
    GROUP BY nationality )
SELECT 
    nationality,
    ROUND(student_count * 100.0 / total_students) AS nationality_ratio
FROM CountryCounts, TotalCounts
ORDER BY student_count DESC;



WITH GenderAge AS 
	( SELECT gender, 
	CASE WHEN EXTRACT(YEAR FROM AGE(current_date, date_of_birth)) BETWEEN 17 AND 24 THEN '17-24'
	WHEN EXTRACT (YEAR FROM AGE(current_date, date_of_birth)) > 24 THEN '+24'
	ELSE '-17' 
	END AS age_frame,
	COUNT (*) AS count_age
	FROM students
	GROUP BY gender, age_frame ),
TotalCounts AS (
    SELECT COUNT(*) AS total_students
    FROM students )
SELECT gender, age_frame, 
	ROUND((count_age*100/total_students)) AS gender_age_ratio
FROM GenderAge, TotalCounts
ORDER BY gender_age_ratio DESC



WITH TotalCounts AS (
    SELECT COUNT(*) AS total_students
    FROM students ),
students_in_city AS (
	SELECT city_of_residence, count (*) AS stu_count
	FROM students
	GROUP BY city_of_residence )
SELECT city_of_residence,
	ROUND(stu_count*100/total_students) AS cities_ratio
FROM students_in_city, TotalCounts
ORDER BY cities_ratio DESC



WITH TotalCounts AS (
    SELECT COUNT(*) AS total_students
    FROM students ),
StudyFields AS (
	SELECT desired_studying_field, count(*) AS fields_count
	FROM students
	GROUP BY desired_studying_field )
SELECT desired_studying_field,
	ROUND(fields_count*100/total_students) AS fields_ratio
FROM TotalCounts, StudyFields
ORDER BY fields_ratio DESC