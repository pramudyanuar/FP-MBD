import pandas as pd

# Define the days of the week
days_of_week = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']

# Define the hours of the day
hours_of_day = [f'{hour:02d}:00' for hour in range(24)]

# Generate the schedule data
schedule_data = [{'day': day, 'hour': hour} for day in days_of_week for hour in hours_of_day]

# Create a DataFrame
df_schedule = pd.DataFrame(schedule_data)

# Save the DataFrame to a CSV file
csv_file_path_schedule = 'schedule_data.csv'
df_schedule.to_csv(csv_file_path_schedule, index=False)

# Convert DataFrame to SQL insert statements
sql_statements_schedule = []
for _, row in df_schedule.iterrows():
    sql_statements_schedule.append(
        f"INSERT INTO Schedule (day, hour) "
        f"VALUES ('{row['day']}', '{row['hour']}');"
    )

# Save the SQL insert statements to a file
sql_file_path_schedule = 'schedule_data.sql'
with open(sql_file_path_schedule, 'w') as f:
    f.write('\n'.join(sql_statements_schedule))

print(f"CSV file saved to {csv_file_path_schedule}")
print(f"SQL file saved to {sql_file_path_schedule}")
