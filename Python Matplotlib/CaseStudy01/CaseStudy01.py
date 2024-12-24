# Step 1: Import Libraries

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from datetime import datetime

#########################################

# Step 2: Load the Data

# Load datasets

q1_2019 = pd.read_csv("D:/Data Analytics certificates/Case Study Files/CaseStudy01/Analyze Phase files/Divvy_Trips_2019_Q1.csv")
q1_2020 = pd.read_csv("D:/Data Analytics certificates/Case Study Files/CaseStudy01/Analyze Phase files/Divvy_Trips_2020_Q1.csv")

# Display the first few rows of each dataset

print(q1_2019.head())
print(q1_2020.head())

#########################################

# Step 3: Renaming Columns for Consistency

# Rename columns to make them consistent

q1_2019 = q1_2019.rename(columns={
    'trip_id' : 'ride_id',
    'start_time' : 'started_at',
    'end_time' : 'ended_at',
    'bikeid' : 'rideable_type',
    'from_station_id' : 'start_station_id',
    'from_station_name' : 'start_station_name',
    'to_station_id' : 'end_station_id',
    'to_station_name' : 'end_station_name',
    'usertype' : 'member_casual'
    })

q1_2020 = q1_2020.rename(columns={
    'ride_id' : 'ride_id',
    'rideable_type' : 'rideable_type',
    'started_at' : 'started_at',
    'ended_at' : 'ended_at',
    'start_station_name' : 'start_station_name',
    'start_station_id' : 'start_station_id',
    'end_station_name' : 'end_station_name',
    'end_station_id' : 'end_station_id',
    'member_casual' : 'member_casual'
    })

# Check the updated column names

print(q1_2019.columns)
print(q1_2020.columns)

#########################################

# Step 4: Ensure Correct Data Types

# Convert ride_id and rideable_type to string type for consistency

q1_2019['ride_id'] = q1_2019['ride_id'].astype(str)
q1_2020['ride_id'] = q1_2020['ride_id'].astype(str)

# Convert datetime columns to datetime type

q1_2019['started_at'] = pd.to_datetime(q1_2019['started_at'])
q1_2019['ended_at'] = pd.to_datetime(q1_2019['ended_at'])
q1_2020['started_at'] = pd.to_datetime(q1_2020['started_at'])
q1_2020['ended_at'] = pd.to_datetime(q1_2020['ended_at'])

# Check the data types

print(q1_2019.dtypes)
print(q1_2020.dtypes)

#########################################

# Step 5: Combine the Datasets

# Concatenate the data

all_trips = pd.concat([q1_2019, q1_2020],
                      ignore_index=True)

# Check the resulting dataset

print(all_trips.head())
print(f"Total rows: {len(all_trips)}")

#########################################

# Step 6: Data Cleaning and Transformation

# Drop columns not needed for analysis

all_trips = all_trips.drop(columns=['start_lat', 'start_lng', 'end_lat', 'end_lng', 'birthyear',  'gender', 'tripduration'])


# Check for missing values

print(all_trips.isnull().sum())


# Drop rows with missing critical values if necessary (e.g., missing ride_id, member_casual)

all_trips = all_trips.dropna(subset=['ride_id', 'member_casual'])


# Check again for missing values

print(all_trips.isnull().sum())


#########################################


# Step 7: Analysis

# Display the counts of each category in the 'member_casual' column
print(all_trips['member_casual'].value_counts())

# Recode the 'member_casual' column
all_trips['member_casual'] = all_trips['member_casual'].replace({
    'Subscriber' : 'member',
    'Customer' : 'casual'
    })

# Display the counts of each category again after recoding
print(all_trips['member_casual'].value_counts())

# Convert 'started_at' to datetime
all_trips['date'] = pd.to_datetime(all_trips['started_at'])

# Extract month, day, year, and day of the week
all_trips['month'] = all_trips['date'].dt.month.astype(str).str.zfill(2) # To ensure two-digit format
all_trips['day'] = all_trips['date'].dt.day.astype(str).str.zfill(2)
all_trips['year'] = all_trips['date'].dt.year.astype(str)
all_trips['day_of_week'] = all_trips['date'].dt.day_name()

# Calculate ride length
all_trips['ended_at'] = pd.to_datetime(all_trips['ended_at']) # Ennsure 'ended_at' is also datetime
all_trips['ride_length'] = (all_trips['ended_at'] - all_trips['started_at']).dt.total_seconds()

# Display structure of DataFrame
print(all_trips.info)


#########################################


# Check if 'ride_length' is of type category (equivalent to factor in R)
is_factor = pd.api.types.is_categorical_dtype(all_trips['ride_length'])
print(is_factor)

# Convert 'ride_length' column to numeric
all_trips['ride_length'] = pd.to_numeric(all_trips['ride_length'], errors='coerce')

# Check if 'ride_length' is numeric
is_numeric = pd.api.types.is_numeric_dtype(all_trips['ride_length'])
print(is_numeric)

# Filter rows where 'start_station_name' is not "HQ QR" and 'ride_length' is >= 0
all_trips_v2 = all_trips[
    ~((all_trips['start_station_name'] == "HQ QR") | (all_trips['ride_length'] < 0))
]


#########################################

# Assuming all_trips_v2 is a pandas DataFrame
mean_ride_length = all_trips_v2['ride_length'].mean()
median_ride_length = all_trips_v2['ride_length'].median()
max_ride_length = all_trips_v2['ride_length'].max()
min_ride_length = all_trips_v2['ride_length'].min()
summary_ride_length = all_trips_v2['ride_length'].describe()

# Printing the results
print(f"Mean: {mean_ride_length}")
print(f"Median: {median_ride_length}")
print(f"Max: {max_ride_length}")
print(f"Min: {min_ride_length}")
print("Summary:")
print(summary_ride_length)

################################################

# Assuming `all_trips_v2` is a DataFrame in Python
# Mean ride length grouped by member_casual
mean_ride_length = all_trips_v2.groupby('member_casual')['ride_length'].mean()

# Median ride length grouped by member_casual
median_ride_length = all_trips_v2.groupby('member_casual')['ride_length'].median()

# Maximum ride length grouped by member_casual
max_ride_length = all_trips_v2.groupby('member_casual')['ride_length'].max()

# Minimum ride length grouped by member_casual
min_ride_length = all_trips_v2.groupby('member_casual')['ride_length'].min()

# Mean ride length grouped by member_casual and day_of_week
mean_ride_length_by_day = all_trips_v2.groupby(['member_casual', 'day_of_week'])['ride_length'].mean()

# To display the results
print("Mean ride length by member_casual:")
print(mean_ride_length)
print("\nMedian ride length by member_casual:")
print(median_ride_length)
print("\nMaximum ride length by member_casual:")
print(max_ride_length)
print("\nMinimum ride length by member_casual:")
print(min_ride_length)
print("\nMean ride length by member_casual and day_of_week:")
print(mean_ride_length_by_day)

################################################

# Assuming all_trips_v2 is a pandas DataFrame with columns: 'day_of_week', 'ride_length', 'member_casual', 'started_at'

# Reorder the days of the week
day_order = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
all_trips_v2['day_of_week'] = pd.Categorical(all_trips_v2['day_of_week'], categories=day_order, ordered=True)

# Aggregate mean ride_length by member_casual and day_of_week
mean_ride_length = all_trips_v2.groupby(['member_casual', 'day_of_week'])['ride_length'].mean().reset_index()

# Add a new column for the weekday (short names)
all_trips_v2['weekday'] = pd.to_datetime(all_trips_v2['started_at']).dt.day_name()

# Group by member_casual and weekday, then calculate number_of_rides and average_duration
summary = (
    all_trips_v2.groupby(['member_casual', 'weekday'])
    .agg(number_of_rides=('ride_length', 'size'), average_duration=('ride_length', 'mean'))
    .reset_index()
)

# Reorder the DataFrame by member_casual and day_of_week order
summary['weekday'] = pd.Categorical(summary['weekday'], categories=day_order, ordered=True)
summary = summary.sort_values(by=['member_casual', 'weekday'])

print(mean_ride_length)
print(summary)


################################################

# Step 8: Visualizations

# Assuming 'all_trips_v2' is a pandas DataFrame
# Add a 'weekday' column
all_trips_v2['weekday'] = pd.to_datetime(all_trips_v2['started_at']).dt.day_name()

# Group by 'member_casual' and 'weekday', and calculate the number of rides and average duration
summary = (all_trips_v2
           .groupby(['member_casual', 'weekday'])
           .agg(number_of_rides=('ride_length', 'size'),
                average_duration=('ride_length', 'mean'))
           .reset_index())

# Arrange by 'member_casual' and 'weekday'
summary['weekday'] = pd.Categorical(summary['weekday'],
                                    categories=['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'],
                                    ordered=True)
summary = summary.sort_values(['member_casual', 'weekday'])

# Plot the data
plt.figure(figsize=(10, 6))
sns.barplot(data=summary, x='weekday', y='number_of_rides', hue='member_casual', dodge=True)
plt.title('Number of Rides by Weekday and Member Type')
plt.ylabel('Number of Rides')
plt.xlabel('Weekday')
plt.xticks(rotation=45)
plt.legend(title='Member Type')
plt.tight_layout()
plt.show()

################################################

# Assuming 'all_trips_v2' is a Pandas DataFrame
# Convert 'started_at' column to datetime if not already done
all_trips_v2['started_at'] = pd.to_datetime(all_trips_v2['started_at'])

# Extract weekday labels
all_trips_v2['weekday'] = all_trips_v2['started_at'].dt.day_name()

# Group by 'member_casual' and 'weekday' and calculate number of rides and average duration
summary = all_trips_v2.groupby(['member_casual', 'weekday'], as_index=False).agg(
    number_of_rides=('started_at', 'size'),
    average_duration=('ride_length', 'mean')
)

# Ensure the weekday order is correct (Monday-Sunday)
weekday_order = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']
summary['weekday'] = pd.Categorical(summary['weekday'], categories=weekday_order, ordered=True)

# Sort the DataFrame
summary = summary.sort_values(by=['member_casual', 'weekday'])

# Plot the data
plt.figure(figsize=(10, 6))
sns.barplot(
    data=summary,
    x='weekday',
    y='average_duration',
    hue='member_casual',
    dodge=True
)
plt.title('Average Ride Duration by Weekday')
plt.ylabel('Average Duration (minutes)')
plt.xlabel('Weekday')
plt.xticks(rotation=45)
plt.legend(title='Member Type')
plt.tight_layout()
plt.show()

################################################

# Assuming all_trips_v2 is a pandas DataFrame
# Group by 'member_casual' and 'day_of_week' and calculate the mean ride length
counts = all_trips_v2.groupby(['member_casual', 'day_of_week'])['ride_length'].mean().reset_index()

# Save the resulting DataFrame to a CSV file
counts.to_csv('avg_ride_length.csv', index=False)

