import faker
import random
import pandas as pd

# Initialize the faker generator
fake = faker.Faker()

# Assuming we already have patient_id and doctor_id ranges from previously generated data
num_patients = 150000  # Adjust based on the actual number of patients generated
num_doctors = 1000  # Adjust based on the actual number of doctors generated

# Function to generate a single message record
def generate_message():
    return {
        'message_content': fake.text(max_nb_chars=255),  # Random message content
        'sent_date': fake.date_time_this_decade(),  # Random date within the last decade
        'sender': fake.name()[:20],  # Random sender name, truncated to 20 characters
        'patient_id': random.randint(1, num_patients),
        'doctor_id': random.randint(1, num_doctors)
    }

# Generate 300,000 message records
num_records = 300000
messages = [generate_message() for _ in range(num_records)]

# Create a DataFrame
df_messages = pd.DataFrame(messages)

# Save the DataFrame to a CSV file
csv_file_path_messages = 'messages_data.csv'
df_messages.to_csv(csv_file_path_messages, index=False)

# Convert DataFrame to SQL insert statements
sql_statements_messages = []
for _, row in df_messages.iterrows():
    sql_statements_messages.append(
        f"INSERT INTO Messages (message_content, sent_date, sender, patient_id, doctor_id) "
        f"VALUES ('{row['message_content']}', '{row['sent_date']}', '{row['sender']}', {row['patient_id']}, {row['doctor_id']});"
    )

# Save the SQL insert statements to a file
sql_file_path_messages = 'messages_data.sql'
with open(sql_file_path_messages, 'w') as f:
    f.write('\n'.join(sql_statements_messages))

print(f"CSV file saved to {csv_file_path_messages}")
print(f"SQL file saved to {sql_file_path_messages}")
