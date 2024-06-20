-- Get Doctor Details
DROP FUNCTION IF EXISTS GetDoctorDetails(VARCHAR, INT);

CREATE OR REPLACE FUNCTION GetDoctorDetails(sessionToken VARCHAR, doctor_id_param INT)
RETURNS TABLE (
    doctor_id INT,
    name VARCHAR,
    specialization VARCHAR,
    fee INT,
    ratings INT,
    str_number VARCHAR,
    gender VARCHAR
) AS $$
DECLARE
    validSession INT;
BEGIN
    SELECT COUNT(*) INTO validSession
    FROM UserSessions
    WHERE session_token = sessionToken;

    IF validSession > 0 THEN
        -- User is authenticated, return doctor details
        RETURN QUERY
        SELECT d.doctor_id, d.name, d.specialization, d.fee, d.ratings, d.str_number, d.gender
        FROM Doctors d
        WHERE d.doctor_id = doctor_id_param;
    ELSE
        -- User is not authenticated
        RAISE EXCEPTION 'Access Denied';
    END IF;
END;
$$ LANGUAGE plpgsql;


SELECT * FROM GetDoctorDetails('b63250d45c65d38225ab7590619cc7f2', 122);

