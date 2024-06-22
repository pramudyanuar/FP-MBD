-- Buat fungsi trigger untuk mengubah status appointment
CREATE OR REPLACE FUNCTION update_appointment_status()
RETURNS TRIGGER AS $$
BEGIN
    -- Update status appointment menjadi 'Completed'
    UPDATE Appointments
    SET status = 'Completed'
    WHERE appointment_id = NEW.appointment_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Buat trigger untuk memanggil fungsi di atas setelah insert pada tabel Reviews
CREATE TRIGGER review_insert_trigger
AFTER INSERT ON Reviews
FOR EACH ROW
WHEN (NEW.review_content IS NOT NULL)
EXECUTE FUNCTION update_appointment_status();