# Our data is a lil unreliable (null values, inconsistent capitalization, etc)
# Here we transform it into a clean version


import pandas as pd

df = pd.read_csv("../data/raw/production_logs.csv")

print(df.head())
print(df.info())
print()

# Making it daytime for easier analytics later on (we wanna group by month and whatnot)
df["date"] = pd.to_datetime(df["date"])

print(df["shift"].unique())
df["shift"] = df["shift"].str.capitalize()
print(df["shift"].unique()) #should only be day / night...

print("Nulls:")
print(df.isna().sum())

df["downtime_minutes"] = df["downtime_minutes"].fillna(0)
df["operator_id"] = df["operator_id"].fillna("UNKNOWN")

print("Nulls (after fix):")
print(df.isna().sum())

df["units_produced"] = df["units_produced"].astype(int)
df["defective_units"] = df["defective_units"].astype(int)
df["downtime_minutes"] = df["downtime_minutes"].astype(int)

invalid = df[df["defective_units"] > df["units_produced"]]
print(len(invalid))

print(df.info())

df.to_csv("../data/processed/production_logs_clean.csv", index=False)