CREATE OR REPLACE FUNCTION RegisterUser(
    userName VARCHAR,
    userEmail VARCHAR,
    userPassword VARCHAR,
    userPhoneNumber VARCHAR,
    userAddress VARCHAR,
    userGender VARCHAR
)
RETURNS VARCHAR AS $$
DECLARE
    userId INT;
BEGIN
    -- Check if the email already exists
    SELECT patient_id INTO userId
    FROM Patient
    WHERE email = userEmail;

    IF userId IS NOT NULL THEN
        -- Email already exists
        RETURN 'Email already registered';
    ELSE
        -- Insert new user
        INSERT INTO Patient (name, email, password, phone_number, address, gender)
        VALUES (userName, userEmail, userPassword, userPhoneNumber, userAddress, userGender)
        RETURNING patient_id INTO userId;

        -- Return success message
        RETURN 'Registration successful';
    END IF;
END;
$$ LANGUAGE plpgsql;

SELECT RegisterUser('Yanuar Eka', 'yanuar@eka.com', 'password123', '1234567890', '123 Main St', 'Male');