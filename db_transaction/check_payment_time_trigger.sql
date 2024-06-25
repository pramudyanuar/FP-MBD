CREATE OR REPLACE FUNCTION check_payment_time()
RETURNS TRIGGER AS $$
BEGIN
    -- Periksa apakah waktu pembayaran setidaknya 24 jam sebelum janji temu
    IF NEW.payment_date >= (SELECT appointment_date
                            FROM Appointments 
                            WHERE appointment_id = NEW.appointment_id)
		AND CURRENT_TIME >= (SELECT appointment_time
							 FROM Appointments
							 WHERE appointment_id = NEW.appointment_id) THEN
        RAISE EXCEPTION 'Pembayaran harus dilakukan sebelum janji temu.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER check_payment_time_trigger
BEFORE INSERT ON Payments
FOR EACH ROW
EXECUTE FUNCTION check_payment_time();

-- SELECT * FROM Appointments LIMIT 10;

-- INSERT INTO Payments (payment_date, amount, payment_method, appointment_id) VALUES ('2024-04-11', 490637, 'Bank Transfer', 2);