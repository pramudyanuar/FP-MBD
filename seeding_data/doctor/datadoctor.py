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

# List of possible fees
fees = [20000, 25000, 30000, 35000, 45000, 50000, 55000, 60000, 65000, 70000, 75000, 80000, 85000, 90000, 95000, 100000]

# Function to generate a single doctor record
def generate_doctor():
    gender = random.choice(['Male', 'Female'])
    return {
        'name': fake.name(),
        'specialization': random.choice(specializations),
        'fee': random.choice(fees),  # Randomly select from the defined fees
        'ratings': random.randint(1, 5),  # Ratings between 1 and 5
        'str_number': fake.bothify(text='STR#####'),  # Random STR number
        'gender': gender
    }

# Generate a batch of doctor records (e.g., 1,000 for demonstration)
num_records_batch = 1000
doctors_batch = [generate_doctor() for _ in range(num_records_batch)]

# Create a DataFrame
df_doctors_batch = pd.DataFrame(doctors_batch)

# Introduce random NULL values in the DataFrame for specified columns
def introduce_nulls(df, null_fraction=0.1, columns=None):
    df = df.copy()
    if columns is None:
        columns = df.columns
    for col in columns:
        df.loc[df.sample(frac=null_fraction).index, col] = None
    return df

# Introduce NULL values to 10% of the 'specialization' and 'gender' columns
columns_with_nulls = ['ratings','specialization']
df_doctors_batch_with_nulls = introduce_nulls(df_doctors_batch, null_fraction=0.29, columns=columns_with_nulls)

# Save the batch to a CSV file
csv_file_path_doctors = 'seeding_data/doctor/doctors_data_batch.csv'
df_doctors_batch_with_nulls.to_csv(csv_file_path_doctors, index=False)

# Convert DataFrame to SQL insert statements
sql_statements_doctors_batch = []
for _, row in df_doctors_batch_with_nulls.iterrows():
    sql_statements_doctors_batch.append(
        f"INSERT INTO Doctors (name, specialization, fee, ratings, str_number, gender) "
        f"VALUES ({'NULL' if pd.isna(row['name']) else repr(row['name'])}, "
        f"{'NULL' if pd.isna(row['specialization']) else repr(row['specialization'])}, "
        f"{'NULL' if pd.isna(row['fee']) else repr(row['fee'])}, "
        f"{'NULL' if pd.isna(row['ratings']) else repr(row['ratings'])}, "
        f"{'NULL' if pd.isna(row['str_number']) else repr(row['str_number'])}, "
        f"{'NULL' if pd.isna(row['gender']) else repr(row['gender'])});"
    )

# Save the SQL insert statements to a file
sql_file_path_doctors = 'seeding_data/doctor/doctors_data_batch.sql'
with open(sql_file_path_doctors, 'w') as f:
    f.write('\n'.join(sql_statements_doctors_batch))

print(f"CSV file saved to {csv_file_path_doctors}")
print(f"SQL file saved to {sql_file_path_doctors}")
