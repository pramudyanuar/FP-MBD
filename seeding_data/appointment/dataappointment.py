import faker
import random
import pandas as pd

# Initialize the faker generator
fake = faker.Faker()

# Assuming we already have patient_id and doctor_id ranges from previously generated data
num_patients = 150000  # Adjust based on the actual number of patients generated
num_doctors = 1000  # Adjust based on the actual number of doctors generated

# Function to generate a single appointment record
def generate_appointment(appointment_status, payment_status):
    return {
        'appointment_date': fake.date_this_year(),  # Random date within this year
        'appointment_time': fake.time(),  # Random time
        'appointment_status': appointment_status,
        'payment_status': payment_status,
        'patient_id': random.randint(1, num_patients),
        'doctor_id': random.randint(1, num_doctors)
    }

# Number of scheduled, scheduled but paid, and completed appointments
num_scheduled = 10000
num_scheduled_paid = 5000
num_completed = 200000

# Generate scheduled appointments
scheduled_appointments = [generate_appointment('Scheduled', 'Pending') for _ in range(num_scheduled)]

# Generate scheduled but paid appointments
scheduled_paid_appointments = [generate_appointment('Scheduled', 'Completed') for _ in range(num_scheduled_paid)]

# Generate completed appointments
completed_appointments = [generate_appointment('Completed', 'Completed') for _ in range(num_completed)]

# Combine all lists
appointments = scheduled_appointments + scheduled_paid_appointments + completed_appointments

# Shuffle the appointments to mix different types
random.shuffle(appointments)

# Create a DataFrame
df_appointments = pd.DataFrame(appointments)

# Save the DataFrame to a CSV file
csv_file_path_appointments = 'seeding_data/appointment/appointments_data.csv'
df_appointments.to_csv(csv_file_path_appointments, index=False)

# Convert DataFrame to SQL insert statements
sql_statements_appointments = []
for _, row in df_appointments.iterrows():
    sql_statements_appointments.append(
        f"INSERT INTO Appointments (appointment_date, appointment_time, appointment_status, payment_status, patient_id, doctor_id) "
        f"VALUES ('{row['appointment_date']}', '{row['appointment_time']}', '{row['appointment_status']}', '{row['payment_status']}', {row['patient_id']}, {row['doctor_id']});"
    )

# Save the SQL insert statements to a file
sql_file_path_appointments = 'seeding_data/appointment/appointments_data.sql'
with open(sql_file_path_appointments, 'w') as f:
    f.write('\n'.join(sql_statements_appointments))

print(f"CSV file saved to {csv_file_path_appointments}")
print(f"SQL file saved to {sql_file_path_appointments}")

# Print the DataFrame
df_appointments.head()
