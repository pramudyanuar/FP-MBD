import faker
import random
import pandas as pd

# Initialize the faker generator
fake = faker.Faker()

# Assuming we already have appointment_id range from previously generated data
num_appointments = 210000  # Adjust based on the actual number of appointments generated

# List of possible payment methods
payment_methods = ['Credit Card', 'Debit Card', 'Cash', 'Bank Transfer', 'Insurance']

# Function to generate a single payment record
def generate_payment():
    return {
        'payment_date': fake.date_this_year(),  # Random date within this year
        'amount': random.randint(50000, 500000),  # Random payment amount
        'payment_method': random.choice(payment_methods),
        'appointment_id': random.randint(1, num_appointments)
    }

# Generate 200,000 payment records
num_records = 200000
payments = [generate_payment() for _ in range(num_records)]

# Create a DataFrame
df_payments = pd.DataFrame(payments)

# Save the DataFrame to a CSV file
csv_file_path_payments = 'payments_data.csv'
df_payments.to_csv(csv_file_path_payments, index=False)

# Convert DataFrame to SQL insert statements
sql_statements_payments = []
for _, row in df_payments.iterrows():
    sql_statements_payments.append(
        f"INSERT INTO Payments (payment_date, amount, payment_method, appointment_id) "
        f"VALUES ('{row['payment_date']}', {row['amount']}, '{row['payment_method']}', {row['appointment_id']});"
    )

# Save the SQL insert statements to a file
sql_file_path_payments = 'payments_data.sql'
with open(sql_file_path_payments, 'w') as f:
    f.write('\n'.join(sql_statements_payments))

print(f"CSV file saved to {csv_file_path_payments}")
print(f"SQL file saved to {sql_file_path_payments}")
