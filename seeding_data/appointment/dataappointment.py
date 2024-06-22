import faker
import random
import pandas as pd

# Initialize the faker generator
fake = faker.Faker()

# Assuming we already have patient_id, doctor_id, and reviews_id ranges from previously generated data
num_patients = 150000  # Adjust based on the actual number of patients generated
num_doctors = 1000  # Adjust based on the actual number of doctors generated
num_reviews = 200000  # Adjust based on the actual number of reviews generated

# Function to generate a single appointment record
def generate_appointment(status):
    return {
        'appointment_date': fake.date_this_year(),  # Random date within this year
        'appointment_time': fake.time(),  # Random time
        'status': status,
        'patient_id': random.randint(1, num_patients),
        'doctor_id': random.randint(1, num_doctors),
        'reviews_id': None if status == 'Scheduled' else random.randint(1, num_reviews)
    }

# Number of scheduled and completed appointments
num_scheduled = 10000
num_completed = 210000 - num_scheduled

# Generate scheduled appointments
scheduled_appointments = [generate_appointment('Scheduled') for _ in range(num_scheduled)]

# Generate completed appointments
completed_appointments = [generate_appointment('Completed') for _ in range(num_completed)]

# Combine both lists
appointments = scheduled_appointments + completed_appointments

# Shuffle the appointments to mix scheduled and completed
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
        f"INSERT INTO Appointments (appointment_date, appointment_time, status, patient_id, doctor_id, reviews_id) "
        f"VALUES ('{row['appointment_date']}', '{row['appointment_time']}', '{row['status']}', {row['patient_id']}, {row['doctor_id']}, {row['reviews_id'] if row['reviews_id'] is not None else 'NULL'});"
    )

# Save the SQL insert statements to a file
sql_file_path_appointments = 'seeding_data/appointment/appointments_data.sql'
with open(sql_file_path_appointments, 'w') as f:
    f.write('\n'.join(sql_statements_appointments))

print(f"CSV file saved to {csv_file_path_appointments}")
print(f"SQL file saved to {sql_file_path_appointments}")