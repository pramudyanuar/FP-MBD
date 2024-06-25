DROP FUNCTION IF EXISTS MakePayment(VARCHAR, INT, INT, VARCHAR);

CREATE OR REPLACE FUNCTION MakePayment(sessionToken VARCHAR, appointment_id_param INT, amount INT, payment_method VARCHAR)
RETURNS VARCHAR AS $$
DECLARE
    validSession INT;
    patientId INT;
    appointmentOwnerId INT;
    doctorFee INT;
BEGIN
    -- Validasi session token
    SELECT COUNT(*), patient_id INTO validSession, patientId
    FROM UserSessions
    WHERE session_token = sessionToken
    GROUP BY patient_id;

    IF validSession > 0 THEN
        -- User is authenticated, check if the user is the owner of the appointment
        SELECT a.patient_id, d.fee INTO appointmentOwnerId, doctorFee
        FROM Appointments a
        JOIN Doctors d ON a.doctor_id = d.doctor_id
        WHERE a.appointment_id = appointment_id_param;

        IF appointmentOwnerId = patientId THEN
            -- Check if the amount matches the doctor's fee
            IF amount = doctorFee THEN
                -- Insert the payment record
                INSERT INTO Payments (payment_date, amount, payment_method, appointment_id)
                VALUES (CURRENT_DATE, amount, payment_method, appointment_id_param);

                RETURN 'Payment made successfully';
            ELSE
                RETURN 'The amount must match the doctor''s fee';
            END IF;
        ELSE
            RETURN 'You can only pay for your own appointments';
        END IF;
    ELSE
        -- User is not authenticated
        RETURN 'Access Denied';
    END IF;
END;
$$ LANGUAGE plpgsql;

SELECT MakePayment('ed15fa7a62e9a586987cdf7599615b53', 210002, 80000, 'QRIS');

SELECT * FROM Payments ORDER BY payment_id DESC LIMIT 2