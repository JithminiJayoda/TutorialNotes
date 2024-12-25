# Ensure the required library is installed
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

# load CSV files
daily_activity = pd.read_csv("D:/Data Analytics certificates/Case Study Files/CaseStudy02/Python/dailyActivity_merged.csv")
sleep_day = pd.read_csv("D:/Data Analytics certificates/Case Study Files/CaseStudy02/Python/sleepDay_merged.csv")

# Display the first few rows of the datasets
print(daily_activity.head())
print(daily_activity.columns)

print(sleep_day.head())
print(sleep_day.columns)

###############################################################################

# Inspect data for missing values
missing_daily_activity = daily_activity.isna().sum().sum() #Check for missing values in daily_activity
missing_sleep_day = sleep_day.isna().sum().sum() # Check for missing values in sleep_day

print(f"Missing values in daily_activity: {missing_daily_activity}")
print(f"Missing values in sleep_day: {missing_sleep_day}")

# Remove duplicates
daily_activity = daily_activity.drop_duplicates()
sleep_day = sleep_day.drop_duplicates()

# Check for duplicate IDs
duplicate_daily_activity = (
    daily_activity.groupby('Id').size().reset_index(name='count').query('count > 1')
)
duplicate_sleep_day = (
    sleep_day.groupby('Id').size().reset_index(name='count').query('count > 1')
)

print("Duplicate IDs in daily_activity:")
print(duplicate_daily_activity)

print("Duplicate IDs in sleep_day:")
print(duplicate_sleep_day)

# Ensure consistent date formatting
sleep_day['ActivityDate'] = pd.to_datetime(sleep_day['SleepDay'])
daily_activity['ActivityDate'] = pd.to_datetime(daily_activity['ActivityDate'])

# Check and align column data types
print("Data types in daily_activity:")
print(daily_activity.dtypes)

print("Data types in sleep_day:")
print(sleep_day.dtypes)

# Count distinct IDs
unique_ids_daily_activity = daily_activity['Id'].nunique()
unique_ids_sleep_day = sleep_day['Id'].nunique()

print(f"Number of distinct IDs in daily_activity: {unique_ids_daily_activity}")
print(f"Number of distinct IDs in sleep_day: {unique_ids_sleep_day}")

###############################################################################

# Summary statistics for selected columns in daily_activity
daily_activity_summary = daily_activity[['TotalSteps', 'TotalDistance', 'SedentaryMinutes']].describe()

# Summary statistics for selected columns in sleep_day
sleep_day_summary = sleep_day[['TotalSleepRecords', 'TotalMinutesAsleep', 'TotalTimeInBed']].describe()

# Display the summaries
print("Daily Activity Summary:")
print(daily_activity_summary)

print("\nSleep Day Summary:")
print(sleep_day_summary)

###############################################################################

# Scatter plot for daily_activity
sns.scatterplot(data=daily_activity, x="TotalSteps", y="SedentaryMinutes", color = 'hotpink')
plt.title("Total Steps vs Sedentary Minutes")
plt.show()

# Scatter plot for sleep_day
sns.scatterplot(data=sleep_day, x="TotalMinutesAsleep", y="TotalTimeInBed", color = 'red')
plt.title("Total Minutes Asleep vs Total Time In Bed")
plt.show()

###############################################################################

# Merge datasets on 'Id'
combined_data = pd.merge(sleep_day, daily_activity, on='Id', how='outer')

# Display the first few rows of the combined data
print(combined_data.head())

# Get the count of distinct 'Id'
distinct_ids = combined_data['Id'].nunique()
print(f"Number of distinct Ids: {distinct_ids}")

# Remove redundant or unnecessary columns
combined_data = combined_data.drop(columns=['SleepDay']) # Adjust the column name if it differs in Python

###############################################################################

# Create derived metrics
combined_data['SleepEfficiency'] = combined_data['TotalMinutesAsleep']/combined_data['TotalTimeInBed'] # Calculate sleep efficiency
combined_data['ActivityToSedentaryRatio'] = combined_data['TotalSteps']/combined_data['SedentaryMinutes'] # Activity-to-sedentary ratio

# Remove rows with invalid or extreme outlier values
combined_data = combined_data[
    (combined_data['TotalSteps'] >= 0) &
    (combined_data['TotalMinutesAsleep'] >= 0) &
    (combined_data['SedentaryMinutes'] >= 0)
]

# Aggregate data to summarize by user (e.g., average values per user)
user_summary = combined_data.groupby('Id').agg(
    AvgSteps=('TotalSteps', 'mean'),
    AvgSleepMinutes=('TotalMinutesAsleep', 'mean'),
    AvgSedentaryMinutes=('SedentaryMinutes', 'mean'),
    AvgSleepEfficiency=('SleepEfficiency', 'mean')
).reset_index()

# Summary statistics
summary_stats = combined_data.describe()
print(summary_stats)

###############################################################################

# Save cleaned and transformed data for further analysis
combined_data.to_csv("cleaned_combined_data.csv", index=False)
user_summary.to_csv("user_summary.csv", index=False)
