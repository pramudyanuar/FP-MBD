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

# Generate 150,000 patient records
num_records = 150000
patients = [generate_patient() for _ in range(num_records)]

# Create a DataFrame
df_patients = pd.DataFrame(patients)

# Introduce random NULL values in the DataFrame
def introduce_nulls(df, null_fraction=0.1):
    df = df.copy()
    for col in df.columns:
        df.loc[df.sample(frac=null_fraction).index, col] = None
    return df

# Introduce NULL values to 10% of the DataFrame
df_patients_with_nulls = introduce_nulls(df_patients, null_fraction=0.1)

# Save the DataFrame to a CSV file
csv_file_path = 'seeding_data/patient/patients_data_batch.csv'
df_patients_with_nulls.to_csv(csv_file_path, index=False)

# Convert DataFrame to SQL insert statements
sql_statements = []
for _, row in df_patients_with_nulls.iterrows():
    sql_statements.append(
        f"INSERT INTO Patient (name, email, password, phone_number, address, gender) "
        f"VALUES ({'NULL' if pd.isna(row['name']) else repr(row['name'])}, "
        f"{'NULL' if pd.isna(row['email']) else repr(row['email'])}, "
        f"{'NULL' if pd.isna(row['password']) else repr(row['password'])}, "
        f"{'NULL' if pd.isna(row['phone_number']) else repr(row['phone_number'])}, "
        f"{'NULL' if pd.isna(row['address']) else repr(row['address'])}, "
        f"{'NULL' if pd.isna(row['gender']) else repr(row['gender'])});"
    )

# Save the SQL insert statements to a file
sql_file_path = 'seeding_data/patient/patients_data_batch.sql'
with open(sql_file_path, 'w') as f:
    f.write('\n'.join(sql_statements))

csv_file_path, sql_file_path
