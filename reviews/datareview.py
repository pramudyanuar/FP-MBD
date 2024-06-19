import faker
import random
import pandas as pd

# Initialize the faker generator
fake = faker.Faker()

# Function to generate a single review record
def generate_review():
    return {
        'rating': random.randint(1, 5),  # Ratings between 1 and 5
        'review_content': fake.text(max_nb_chars=255),  # Random review content
        'review_date': fake.date_time_this_decade()  # Random date within the last decade
    }

# Generate a batch of review records (e.g., 10,000 for demonstration)
num_records_batch = 200000
reviews_batch = [generate_review() for _ in range(num_records_batch)]

# Create a DataFrame
df_reviews_batch = pd.DataFrame(reviews_batch)

# Save the batch to a CSV file
csv_file_path_reviews = 'reviews_data_batch.csv'
df_reviews_batch.to_csv(csv_file_path_reviews, index=False)

# Convert DataFrame to SQL insert statements
sql_statements_reviews_batch = []
for _, row in df_reviews_batch.iterrows():
    sql_statements_reviews_batch.append(
        f"INSERT INTO Reviews (rating, review_content, review_date) "
        f"VALUES ({row['rating']}, '{row['review_content']}', '{row['review_date']}');"
    )

# Save the SQL insert statements to a file
sql_file_path_reviews = 'reviews_data_batch.sql'
with open(sql_file_path_reviews, 'w') as f:
    f.write('\n'.join(sql_statements_reviews_batch))

print(f"CSV file saved to {csv_file_path_reviews}")
print(f"SQL file saved to {sql_file_path_reviews}")
