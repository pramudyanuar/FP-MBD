CREATE VIEW ActiveDoctorsCurrentSchedule AS
SELECT d.doctor_id, d.name, d.specialization, d.Fee, d.ratings, d.str_number, d.gender
FROM Doctors d
JOIN Doctors_sched ds ON d.doctor_id = ds.Doct
JOIN schedule s ON ds.sche = s.schedule_id
WHERE CURRENT_TIME BETWEEN s.start_hour AND s.end_hour
AND s.day = to_char(current_date, 'FMDay');
