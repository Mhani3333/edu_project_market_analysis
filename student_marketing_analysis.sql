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