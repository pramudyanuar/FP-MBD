-- Melihat Semua Dokter
DROP FUNCTION IF EXISTS GetDoctor(VARCHAR);
CREATE OR REPLACE FUNCTION GetDoctor(sessionToken VARCHAR)
RETURNS SETOF Doctors AS $$
DECLARE
    validSession INT;
BEGIN
    SELECT COUNT(*) INTO validSession
    FROM UserSessions
    WHERE session_token = sessionToken;

    IF validSession > 0 THEN
        RETURN QUERY SELECT * FROM Doctors;
    ELSE
        RAISE EXCEPTION 'Access Denied';
    END IF;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM GetDoctor('b63250d45c65d38225ab7590619cc7f2');