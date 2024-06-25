DROP FUNCTION IF EXISTS MakeReview(VARCHAR, INT, INT, VARCHAR);

CREATE OR REPLACE FUNCTION MakeReview(
    sessionToken VARCHAR,
    appointment_id_param INT,
    rating INT,
    review_content VARCHAR
)
RETURNS VARCHAR AS $$
DECLARE
    validSession INT;
    patientId INT;
    appointmentOwnerId INT;
    appointmentStatus VARCHAR;
    paymentStatus VARCHAR;
    doctorId INT;
BEGIN
    -- Validasi session token
    SELECT COUNT(*), patient_id INTO validSession, patientId
    FROM UserSessions
    WHERE session_token = sessionToken
    GROUP BY patient_id;

    IF validSession > 0 THEN
        -- User is authenticated, check if the user is the owner of the appointment
        SELECT a.patient_id, a.appointment_status, a.payment_status, a.doctor_id INTO appointmentOwnerId, appointmentStatus, paymentStatus, doctorId
        FROM Appointments a
        WHERE a.appointment_id = appointment_id_param;

        IF appointmentOwnerId = patientId THEN
            -- Check if the appointment is scheduled and the payment status is completed
            IF appointmentStatus = 'Scheduled' AND paymentStatus = 'Completed' THEN
                -- Insert the review record
                INSERT INTO Reviews (rating, review_content, review_date, patient_id, doctor_id, appointment_id)
                VALUES (rating, review_content, CURRENT_TIMESTAMP, patientId, doctorId, appointment_id_param);

                RETURN 'Review submitted successfully';
            ELSE
                RETURN 'Appointment must be scheduled and payment must be completed to leave a review';
            END IF;
        ELSE
            RETURN 'You can only review your own appointments';
        END IF;
    ELSE
        -- User is not authenticated
        RETURN 'Access Denied';
    END IF;
END;
$$ LANGUAGE plpgsql;

SELECT MakeReview('b9422b149e1e65b64f53a460add365b0', 9187, 5, 'good bro');