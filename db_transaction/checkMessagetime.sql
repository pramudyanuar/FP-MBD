CREATE OR REPLACE FUNCTION check_message_within_consultation_time()
RETURNS TRIGGER AS $$
DECLARE
    appointment_start TIMESTAMP;
    appointment_end TIMESTAMP;
BEGIN
    -- Ambil waktu mulai dan akhir konsultasi
    SELECT (appointment_date + appointment_time::interval) AS start_time,
           (appointment_date + appointment_time::interval + INTERVAL '1 hour') AS end_time
    INTO appointment_start, appointment_end
    FROM Appointments
    WHERE appointment_id = NEW.appointment_id;

    -- Periksa apakah waktu pengiriman pesan berada dalam rentang waktu konsultasi
    IF NEW.sent_date < appointment_start THEN
        RAISE EXCEPTION 'It is not yet time for the consultation.';
    ELSIF NEW.sent_date > appointment_end THEN
        RAISE EXCEPTION 'The message must be sent within the consultation time limit (1 hour).';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER message_within_consultation_time_trigger
BEFORE INSERT ON Messages
FOR EACH ROW
EXECUTE FUNCTION check_message_within_consultation_time();