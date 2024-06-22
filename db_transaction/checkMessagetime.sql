-- Buat fungsi trigger untuk memeriksa waktu pengiriman pesan
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
        RAISE EXCEPTION 'Belum waktu untuk konsultasi.';
    ELSIF NEW.sent_date > appointment_end THEN
        RAISE EXCEPTION 'Pesan harus dikirim dalam batasan waktu konsultasi (1 jam).';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Buat trigger untuk memanggil fungsi di atas sebelum insert pada tabel Messages
CREATE TRIGGER message_within_consultation_time_trigger
BEFORE INSERT ON Messages
FOR EACH ROW
EXECUTE FUNCTION check_message_within_consultation_time();


INSERT INTO Messages (message_content, sent_date, sender, patient_id, doctor_id, appointment_id) VALUES ('Sport American wait author still none worker child. Air describe serious one chance. Five property human cause increase right fill house.
Set past central serious. Myself free since capital indeed. Decide feeling happy.', '2024-06-22 23:48:15', 'Alice Woodard', 1, 1, 8);

INSERT INTO Messages (message_content, sent_date, sender, patient_id, doctor_id, appointment_id) VALUES ('Sport American wait author still none worker child. Air describe serious one chance. Five property human cause increase right fill house.
Set past central serious. Myself free since capital indeed. Decide feeling happy.', '2024-06-23 01:00:15', 'Alice Woodard', 1, 1, 8);

INSERT INTO Messages (message_content, sent_date, sender, patient_id, doctor_id, appointment_id) VALUES ('Sport American wait author still none worker child. Air describe serious one chance. Five property human cause increase right fill house.
Set past central serious. Myself free since capital indeed. Decide feeling happy.', '2024-06-22 23:55:15', 'Alice Woodard', 1, 1, 8);