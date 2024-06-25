CREATE OR REPLACE FUNCTION check_single_payment()
RETURNS TRIGGER AS $$
BEGIN
    -- Check if there is already a payment for the same appointment
    IF EXISTS (
        SELECT 1
        FROM Payments p
        WHERE p.appointment_id = NEW.appointment_id
    ) THEN
        RAISE EXCEPTION 'This appointment has already been paid for';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_payment_trigger
BEFORE INSERT ON Payments
FOR EACH ROW
EXECUTE FUNCTION check_single_payment();