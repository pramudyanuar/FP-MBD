CREATE TABLE UserSessions (
    session_id SERIAL PRIMARY KEY,
    patient_id INT REFERENCES Patient(patient_id),
    login_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    session_token VARCHAR(255)
);

DROP FUNCTION IF EXISTS HandleLogin(VARCHAR, VARCHAR);
DROP FUNCTION IF EXISTS GetProtectedData(VARCHAR);

-- HandleLogin
CREATE OR REPLACE FUNCTION HandleLogin(userEmail VARCHAR, userPassword VARCHAR)
RETURNS VARCHAR AS $$
DECLARE
    userId INT;
    sessionToken VARCHAR(255);
BEGIN
    -- Cari user dengan email dan password yang diberikan
    SELECT patient_id INTO userId
    FROM Patient
    WHERE email = userEmail AND password = userPassword;

    IF userId IS NOT NULL THEN
        -- Generate a session token (simple version, in practice use a more secure method)
        sessionToken := md5(random()::text || clock_timestamp()::text);

        -- Insert into UserSessions
        INSERT INTO UserSessions (patient_id, session_token)
        VALUES (userId, sessionToken);

        RETURN sessionToken;
    ELSE
        RETURN NULL;
    END IF;
END;
$$ LANGUAGE plpgsql;

SELECT HandleLogin('angelicatownsend@example.net', '%Z6NyQTI');