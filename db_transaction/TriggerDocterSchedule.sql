CREATE OR REPLACE FUNCTION check_doctor_appointment_conflict()
RETURNS TRIGGER AS $$
BEGIN
    -- Check if there is any overlapping appointment for the same doctor
    IF EXISTS (
        SELECT 1
        FROM Appointments a
        WHERE a.Doctors_doctor_id = NEW.Doctors_doctor_id
        AND a.appointment_date = NEW.appointment_date
        AND ((NEW.appointment_time BETWEEN a.appointment_time AND (a.appointment_time + INTERVAL '1 hour'))
             OR (a.appointment_time BETWEEN NEW.appointment_time AND (NEW.appointment_time + INTERVAL '1 hour')))
    ) THEN
        RAISE EXCEPTION 'Doctor already has an appointment at this time';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_appointment_conflict_trigger
BEFORE INSERT ON Appointments
FOR EACH ROW
EXECUTE FUNCTION check_doctor_appointment_conflict();
