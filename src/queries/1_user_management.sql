.open fittrackpro.db
.mode column

-- 1.1
SELECT member_id, first_name, last_name, email, join_date 
FROM members;

-- 1.2
UPDATE members 
    SET phone_number = '07000 100005', email = 'emily.jones.updated@email.com'
WHERE member_id = 5;

-- 1.3
SELECT COUNT(*) AS total_members
FROM members;

-- 1.4
SELECT 
    m.member_id,
    m.first_name,
    m.last_name,
    COUNT(ca.class_attendance_id) AS registration_count
FROM members AS m
JOIN class_attendance AS ca
    ON m.member_id = ca.member_id
WHERE ca.attendance_status = 'Registered'   -- only counts registered members
GROUP BY m.member_id, m.first_name, m.last_name
ORDER BY registration_count DESC LIMIT 1;   -- orders in descending order then picks the first one

-- 1.5
SELECT
    m.member_id,
    m.first_name,
    m.last_name,
    COUNT(ca.class_attendance_id) AS registration_count
FROM members AS m
LEFT JOIN class_attendance AS ca    -- left join includes members with no registrations
    ON m.member_id = ca.member_id AND ca.attendance_status = 'Registered'
GROUP BY m.member_id, m.first_name, m.last_name
ORDER BY registration_count ASC LIMIT 1;


-- 1.6
SELECT COUNT(*) AS Count 
FROM (
    SELECT member_id
    FROM class_attendance
    WHERE attendance_status = 'Attended'
    GROUP BY member_id
    HAVING COUNT(class_attendance_id) >= 2);    -- only members that attended at least 2 classes
