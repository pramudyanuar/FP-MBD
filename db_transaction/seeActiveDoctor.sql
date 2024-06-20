-- Melihat Dokter Yang Sedang Aktif
DROP FUNCTION IF EXISTS GetActiveDoctor(VARCHAR);
CREATE OR REPLACE FUNCTION GetActiveDoctor(sessionToken VARCHAR)
RETURNS SETOF ActiveDoctorsCurrentSchedule AS $$
DECLARE
    validSession INT;
BEGIN
    SELECT COUNT(*) INTO validSession
    FROM UserSessions
    WHERE session_token = sessionToken;

    IF validSession > 0 THEN
        RETURN QUERY SELECT * FROM ActiveDoctorsCurrentSchedule;
    ELSE
        RAISE EXCEPTION 'Access Denied';
    END IF;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM GetActiveDoctor('b63250d45c65d38225ab7590619cc7f2');