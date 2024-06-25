CREATE OR REPLACE FUNCTION GetAllDoctors(sessionToken VARCHAR)
RETURNS TABLE (
    doctor_id INT,
    doctor_name VARCHAR,
    specialization VARCHAR,
    fee INT,
    ratings INT,
    gender VARCHAR,
    status VARCHAR
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
        -- User is authenticated, return active doctors
        RETURN QUERY
        SELECT adv.doctor_id, adv.doctor_name, adv.specialization, adv.fee, adv.ratings, adv.gender, adv.status
        FROM Active_Doctors_View adv;
    ELSE
        -- User is not authenticated
        RAISE EXCEPTION 'Access Denied';
    END IF;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM GetAllDoctors('ed15fa7a62e9a586987cdf7599615b53');