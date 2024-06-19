import random
import faker
import pandas as pd

# Initialize the faker generator
fake = faker.Faker()

# Function to generate a single patient record
def generate_patient():
    gender = random.choice(['Male', 'Female'])
    phone_number = '+62' + ''.join([str(random.randint(0, 9)) for _ in range(11)])
    return {
        'name': fake.name(),
        'email': fake.unique.email(),
        'password': fake.password(length=8),
        'phone_number': phone_number,
        'address': fake.address(),
        'gender': gender
    }

# Generate 10,000 patient records
num_records = 150000
patients = [generate_patient() for _ in range(num_records)]

# Create a DataFrame
df_patients = pd.DataFrame(patients)

# Save the DataFrame to a CSV file
csv_file_path = 'patients_data_batch.csv'
df_patients.to_csv(csv_file_path, index=False)

# Convert DataFrame to SQL insert statements
sql_statements = []
for _, row in df_patients.iterrows():
    sql_statements.append(
        f"INSERT INTO Patient (name, email, password, phone_number, address, gender) "
        f"VALUES ('{row['name']}', '{row['email']}', '{row['password']}', '{row['phone_number']}', '{row['address']}', '{row['gender']}');"
    )

# Save the SQL insert statements to a file
sql_file_path = 'patients_data_batch.sql'
with open(sql_file_path, 'w') as f:
    f.write('\n'.join(sql_statements))

csv_file_path, sql_file_path
