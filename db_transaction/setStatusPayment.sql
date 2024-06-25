-- Function to update payment_status in Appointments table
CREATE OR REPLACE FUNCTION update_payment_status() RETURNS TRIGGER AS $$
BEGIN
    -- Update payment_status in Appointments table to 'Completed' if a payment exists
    UPDATE Appointments
    SET payment_status = 'Completed'
    WHERE appointment_id = NEW.appointment_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to call the function after insert on Payments table
CREATE TRIGGER trg_update_payment_status
AFTER INSERT ON Payments
FOR EACH ROW
EXECUTE FUNCTION update_payment_status();

-- Function to check and update payment_status in Appointments table on delete
CREATE OR REPLACE FUNCTION check_payment_status_on_delete() RETURNS TRIGGER AS $$
BEGIN
    -- Check if there are no payments left for the given appointment_id
    IF NOT EXISTS (SELECT 1 FROM Payments WHERE appointment_id = OLD.appointment_id) THEN
        -- Update payment_status in Appointments table to 'Pending'
        UPDATE Appointments
        SET payment_status = 'Pending'
        WHERE appointment_id = OLD.appointment_id;
    END IF;

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

-- Trigger to call the function after delete on Payments table
CREATE TRIGGER trg_check_payment_status_on_delete
AFTER DELETE ON Payments
FOR EACH ROW
EXECUTE FUNCTION check_payment_status_on_delete();