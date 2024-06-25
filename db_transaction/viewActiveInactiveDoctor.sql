DROP VIEW IF EXISTS Active_Doctors_View;

CREATE OR REPLACE VIEW Active_Doctors_View AS
SELECT 
    d.doctor_id,
    d.name AS doctor_name,
    d.specialization,
    d.fee,
    d.ratings,
    d.gender,
    CASE 
        WHEN s.day = TO_CHAR(CURRENT_DATE, 'FMDay')
        AND CURRENT_TIME BETWEEN s.start_hour AND s.end_hour
        THEN 'Active'::VARCHAR
        ELSE 'Inactive'::VARCHAR
    END AS status
FROM 
    Doctors d
JOIN 
    Doctors_sched ds ON d.doctor_id = ds.doctor_id
JOIN 
    Schedule s ON ds.schedule_id = s.schedule_id;