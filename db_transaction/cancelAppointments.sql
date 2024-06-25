CREATE OR REPLACE FUNCTION CancelAppointment(sessionToken VARCHAR, appointmentId INT)
RETURNS VARCHAR AS $$
DECLARE
    validSession INT;
    patientId INT;
    appointmentOwnerId INT;
    appointmentDateTime TIMESTAMP;
BEGIN
    -- Validasi session token
    SELECT COUNT(*), patient_id INTO validSession, patientId
    FROM UserSessions
    WHERE session_token = sessionToken
    GROUP BY patient_id;

    IF validSession > 0 THEN
        -- Dapatkan pemilik janji temu dan waktu janji temu
        SELECT patient_id, appointment_date + appointment_time::TIME INTO appointmentOwnerId, appointmentDateTime
        FROM Appointments
        WHERE appointment_id = appointmentId;

        -- Periksa apakah janji temu milik user yang sedang login
        IF appointmentOwnerId = patientId THEN
            -- Periksa apakah janji temu dapat dibatalkan (setidaknya 12 jam sebelumnya)
            IF appointmentDateTime > NOW() + INTERVAL '12 hours' THEN
                -- Ubah status janji temu menjadi "cancelled"
                UPDATE Appointments
                SET status = 'Cancelled'
                WHERE appointment_id = appointmentId;

                RETURN 'Appointment cancelled successfully';
            ELSE
                RETURN 'Appointment cannot be cancelled within 12 hours of the scheduled time';
            END IF;
        ELSE
            RETURN 'You can only cancel your own appointments';
        END IF;
    ELSE
        -- User is not authenticated
        RAISE EXCEPTION 'Access Denied';
    END IF;
END;
$$ LANGUAGE plpgsql;


SELECT CancelAppointment('ed15fa7a62e9a586987cdf7599615b53', 67);
SELECT CancelAppointment('ed15fa7a62e9a586987cdf7599615b53', 122667);
