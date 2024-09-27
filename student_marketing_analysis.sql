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
ORDER BY student_count DESC
LIMIT 3;
/*
 Sample data:
   | nationality   | nationality_ratio |
   |---------------|-------------------|
   | Other         | 76                |
   | Saudi Arabia  | 24                |
   | Sudan         | 20                |
*/


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
LIMIT 3;

/*
Sample data:
   | gender  | age_frame | gender_age_ratio |
   |---------|-----------|------------------|
   | Female  | 17-24     | 56               |
   | Male    | 17-24     | 30               |
   | Male    | +24       | 7                |
*/



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
LIMIT 3;
/*
Sample data:
   | city_of_residence | cities_ratio |
   |-------------------|--------------|
   | Riyadh, KSA       | 35           |
   | Jeddah, KSA       | 30           |
   | Medina, KSA       | 9            |
*/



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
LIMIT 3;

/*
Sample data:
   | desired_studying_field | fields_ratio |
   |------------------------|--------------|
   | Medicine               | 50           |
   | Engineering            | 17           |
   | Other                  | 15           |
*/