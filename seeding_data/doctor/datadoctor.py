import faker
import random
import pandas as pd

# Initialize the faker generator
fake = faker.Faker()

# List of possible specializations
specializations = [
    'Cardiology', 'Dermatology', 'Endocrinology', 'Gastroenterology', 
    'Neurology', 'Oncology', 'Pediatrics', 'Psychiatry', 'Radiology', 
    'Surgery', 'Urology'
]

# Function to generate a single doctor record
def generate_doctor():
    gender = random.choice(['Male', 'Female'])
    return {
        'name': fake.name(),
        'specialization': random.choice(specializations),
        'fee': random.randint(50000, 500000),  # Assuming fee in local currency
        'ratings': random.randint(1, 5),  # Ratings between 1 and 5
        'str_number': fake.bothify(text='STR#####'),  # Random STR number
        'gender': gender
    }

# Generate a batch of doctor records (e.g., 10,000 for demonstration)
num_records_batch = 1000
doctors_batch = [generate_doctor() for _ in range(num_records_batch)]

# Create a DataFrame
df_doctors_batch = pd.DataFrame(doctors_batch)

# Save the batch to a CSV file
csv_file_path_doctors = 'doctors_data_batch.csv'
df_doctors_batch.to_csv(csv_file_path_doctors, index=False)

# Convert DataFrame to SQL insert statements
sql_statements_doctors_batch = []
for _, row in df_doctors_batch.iterrows():
    sql_statements_doctors_batch.append(
        f"INSERT INTO Doctors (name, specialization, fee, ratings, str_number, gender) "
        f"VALUES ('{row['name']}', '{row['specialization']}', {row['fee']}, {row['ratings']}, '{row['str_number']}', '{row['gender']}');"
    )

# Save the SQL insert statements to a file
sql_file_path_doctors = 'doctors_data_batch.sql'
with open(sql_file_path_doctors, 'w') as f:
    f.write('\n'.join(sql_statements_doctors_batch))

print(f"CSV file saved to {csv_file_path_doctors}")
print(f"SQL file saved to {sql_file_path_doctors}")
