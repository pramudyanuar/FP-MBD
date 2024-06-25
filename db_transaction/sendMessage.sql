CREATE OR REPLACE FUNCTION SendMessage(sessionToken VARCHAR, doctor_id INT, message_content VARCHAR, appointment_id INT)
RETURNS VARCHAR AS $$
DECLARE
    validSession INT;
    patientId INT;
    paymentStatus VARCHAR;
BEGIN
    -- Validasi session token
    SELECT COUNT(*), patient_id INTO validSession, patientId
    FROM UserSessions
    WHERE session_token = sessionToken
    GROUP BY patient_id;

    IF validSession > 0 THEN
        -- User is authenticated, check if the payment status is completed
        SELECT p.status INTO paymentStatus
        FROM Payments p
        JOIN Appointments a ON p.appointment_id = a.appointment_id
        WHERE a.appointment_id = appointment_id AND a.patient_id = patientId;

        IF paymentStatus = 'completed' THEN
            -- Insert the message
            INSERT INTO Messages (message_content, sent_date, sender, patient_id, doctor_id, appointment_id)
            VALUES (message_content, CURRENT_TIMESTAMP, 'patient', patientId, doctor_id, appointment_id);

            RETURN 'Message sent successfully';
        ELSE
            RETURN 'Payment for the appointment is not completed';
        END IF;
    ELSE
        -- User is not authenticated
        RETURN 'Access Denied';
    END IF;
END;
$$ LANGUAGE plpgsql;

SELECT SendMessage('ed15fa7a62e9a586987cdf7599615b53', 1, 'hello');