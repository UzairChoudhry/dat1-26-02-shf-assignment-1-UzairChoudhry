.open fittrackpro.db
.mode column

-- 6.1 
INSERT INTO attendance
(member_id, location_id, check_in_time)
VALUES 
(7, 1, '2025-02-14 16:30:00');

-- 6.2 
SELECT 
    DATE(check_in_time) AS visit_date, 
    check_in_time, 
    check_out_time
FROM attendance
WHERE member_id = 5
ORDER BY check_in_time;

-- 6.3 
SELECT
    CASE strftime('%w', check_in_time)  -- gives the weekday as a numeric value
        WHEN '0' THEN 'Sunday'  -- assign days to each number
        WHEN '1' THEN 'Monday'
        WHEN '2' THEN 'Tuesday'
        WHEN '3' THEN 'Wednesday'
        WHEN '4' THEN 'Thursday'
        WHEN '5' THEN 'Friday'
        WHEN '6' THEN 'Saturday'
    END AS day_of_week,
    COUNT(*) AS visit_count
FROM attendance
GROUP BY strftime('%w', check_in_time)
ORDER BY visit_count DESC LIMIT 1;  -- only reutn the dat with the most visits

-- 6.4 
SELECT 
    l.name AS location_name,
    AVG(daily_visits) AS avg_daily_attendance   -- average number of visits per day
FROM locations AS l 
LEFT JOIN(  -- show all results even without any visits
    SELECT
        location_id,
        DATE(check_in_time) AS visit_date,
        COUNT(*) AS daily_visits    -- number of rows is the number of visits
    FROM attendance
    GROUP BY location_id, DATE(check_in_time)) AS dc
ON l.location_id = dc.location_id
GROUP BY location_name;