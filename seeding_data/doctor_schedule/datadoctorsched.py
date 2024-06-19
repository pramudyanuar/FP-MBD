import faker
import random
import pandas as pd
import os

# Initialize the faker generator
fake = faker.Faker()

# Assuming we already have doctor_id and schedule_id ranges from previously generated data
num_doctors = 1000  # Adjust based on the actual number of doctors generated
num_schedules = 168  # We know there are 168 schedule slots

# Function to generate doctor schedule combinations and randomize them
def generate_randomized_doctor_schedule_combinations(num_doctors, num_schedules):
    doctor_schedule_combinations = []
    for doctor_id in range(1, num_doctors + 1):
        schedules = list(range(1, num_schedules + 1))
        random.shuffle(schedules)  # Shuffle the schedule for each doctor
        for schedule_id in schedules:
            doctor_schedule_combinations.append({
                'doctor_id': doctor_id,
                'schedule_id': schedule_id
            })
    random.shuffle(doctor_schedule_combinations)  # Shuffle the entire list to randomize assignments further
    return doctor_schedule_combinations

# Generate randomized doctor schedule combinations
doctor_schedule_combinations = generate_randomized_doctor_schedule_combinations(num_doctors, num_schedules)

# Create a DataFrame
df_doctor_sched = pd.DataFrame(doctor_schedule_combinations)

# Ensure the directory exists
os.makedirs('doctor_schedule', exist_ok=True)

# Save the DataFrame to a CSV file
csv_file_path_doctor_sched = 'doctor_schedule/doctor_sched_data.csv'
df_doctor_sched.to_csv(csv_file_path_doctor_sched, index=False)

# Convert DataFrame to SQL insert statements
sql_statements_doctor_sched = []
for _, row in df_doctor_sched.iterrows():
    sql_statements_doctor_sched.append(
        f"INSERT INTO Doctors_sched (doctor_id, schedule_id) "
        f"VALUES ({row['doctor_id']}, {row['schedule_id']});"
    )

# Save the SQL insert statements to a file
sql_file_path_doctor_sched = 'doctor_schedule/doctor_sched_data.sql'
with open(sql_file_path_doctor_sched, 'w') as f:
    f.write('\n'.join(sql_statements_doctor_sched))

print(f"CSV file saved to {csv_file_path_doctor_sched}")
print(f"SQL file saved to {sql_file_path_doctor_sched}")
