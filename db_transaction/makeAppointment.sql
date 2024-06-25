CREATE OR REPLACE FUNCTION MakeAppointment(sessionToken VARCHAR, appointment_date DATE, appointment_time TIME, doctor_id INT)
RETURNS VARCHAR AS $$
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
        -- User is authenticated, attempt to create appointment
        BEGIN
            INSERT INTO Appointments (appointment_date, appointment_time, status, patient_id, doctor_id)
            VALUES (appointment_date, appointment_time, 'scheduled', patientId, doctor_id);

            RETURN 'Appointment created successfully';
        EXCEPTION
            WHEN OTHERS THEN
                RETURN 'Error: ' || SQLERRM;
        END;
    ELSE
        -- User is not authenticated
        RETURN 'Access Denied';
    END IF;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM MakeAppointment('ed15fa7a62e9a586987cdf7599615b53', '2024-06-26', '11:00', 1);