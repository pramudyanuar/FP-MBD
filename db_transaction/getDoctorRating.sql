DROP FUNCTION IF EXISTS GetDoctorRating(VARCHAR, INT);
CREATE OR REPLACE FUNCTION GetDoctorRating(sessionToken VARCHAR, doctor_id_param INT)
RETURNS TABLE (
    doctor_id INT,
    name VARCHAR,
    average_rating DECIMAL
) AS $$
DECLARE
    validSession INT;
    patientId INT;
BEGIN
    -- Validasi session token
    SELECT COUNT(*), patient_id INTO validSession, patientId
    FROM UserSessions
    WHERE session_token = sessionToken
    GROUP BY patient_id;

    IF validSession > 0 THEN
        -- User is authenticated, return doctor rating
        RETURN QUERY
        SELECT d.doctor_id, d.name, COALESCE(AVG(r.rating)::DECIMAL(2, 1), 0) AS average_rating
        FROM Doctors d
        LEFT JOIN Appointments a ON d.doctor_id = a.doctor_id
        LEFT JOIN Reviews r ON a.appointment_id = r.reviews_id
        WHERE d.doctor_id = doctor_id_param
        GROUP BY d.doctor_id, d.name;
    ELSE
        -- User is not authenticated
        RAISE EXCEPTION 'Access Denied';
    END IF;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM GetDoctorRating('ed15fa7a62e9a586987cdf7599615b53', 55);