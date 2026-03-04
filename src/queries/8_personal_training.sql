.open fittrackpro.db
.mode column

-- 8.1 
SELECT 
    pts.session_id,
    CONCAT(m.first_name, ' ', m.last_name) AS member_name,  -- combine first and last name of member
    pts.session_date,
    pts.start_time,
    pts.end_time
FROM personal_training_sessions AS pts
JOIN members AS m   -- join members table to get name
    ON pts.member_id = m.member_id
JOIN staff AS s -- join staff table to identify who the trainer is
    ON pts.staff_id = s.staff_id
WHERE s.first_name = 'Ivy' AND s.last_name = 'Irwin';
