import faker
import random
import pandas as pd

# Initialize the faker generator
fake = faker.Faker()

# Define possible statuses
statuses = ['Scheduled', 'Completed', 'Cancelled']

# Assuming we already have patient_id, doctor_id, and reviews_id ranges from previously generated data
num_patients = 150000  # Adjust based on the actual number of patients generated
num_doctors = 1000  # Adjust based on the actual number of doctors generated
num_reviews = 200000  # Adjust based on the actual number of reviews generated

# Function to generate a single appointment record
def generate_appointment():
    return {
        'appointment_date': fake.date_this_year(),  # Random date within this year
        'appointment_time': fake.time(),  # Random time
        'status': random.choice(statuses),
        'patient_id': random.randint(1, num_patients),
        'doctor_id': random.randint(1, num_doctors),
        'reviews_id': random.randint(1, num_reviews)
    }

# Generate a batch of appointment records (e.g., 10,000 for demonstration)
num_records_batch = 210000
appointments_batch = [generate_appointment() for _ in range(num_records_batch)]

# Create a DataFrame
df_appointments_batch = pd.DataFrame(appointments_batch)

# Save the batch to a CSV file
csv_file_path_appointments = 'appointments_data_batch.csv'
df_appointments_batch.to_csv(csv_file_path_appointments, index=False)

# Convert DataFrame to SQL insert statements
sql_statements_appointments_batch = []
for _, row in df_appointments_batch.iterrows():
    sql_statements_appointments_batch.append(
        f"INSERT INTO Appointments (appointment_date, appointment_time, status, patient_id, doctor_id, reviews_id) "
        f"VALUES ('{row['appointment_date']}', '{row['appointment_time']}', '{row['status']}', {row['patient_id']}, {row['doctor_id']}, {row['reviews_id']});"
    )

# Save the SQL insert statements to a file
sql_file_path_appointments = 'appointments_data_batch.sql'
with open(sql_file_path_appointments, 'w') as f:
    f.write('\n'.join(sql_statements_appointments_batch))

print(f"CSV file saved to {csv_file_path_appointments}")
print(f"SQL file saved to {sql_file_path_appointments}")
