-- Buat fungsi trigger untuk memeriksa waktu reservasi
CREATE OR REPLACE FUNCTION check_reservation_time()
RETURNS TRIGGER AS $$
BEGIN
    -- Periksa apakah waktu reservasi kurang dari 24 jam sebelum waktu konsultasi
    IF (NEW.appointment_date + NEW.appointment_time::interval - CURRENT_TIMESTAMP) < INTERVAL '24 hours' THEN
        RAISE EXCEPTION 'Reservasi harus dilakukan setidaknya 24 jam sebelum janji konsultasi.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Buat trigger untuk memanggil fungsi di atas sebelum insert pada tabel Appointments
CREATE TRIGGER reservation_time_trigger
BEFORE INSERT OR UPDATE ON Appointments
FOR EACH ROW
EXECUTE FUNCTION check_reservation_time();

INSERT INTO Appointments (appointment_date, appointment_time, status, patient_id, doctor_id) VALUES ('2024-06-22', '18:04:54', 'Scheduled', 1, 1);

INSERT INTO Appointments (appointment_date, appointment_time, status, patient_id, doctor_id) VALUES ('2024-06-22', '23:50:54', 'Scheduled', 1, 1);