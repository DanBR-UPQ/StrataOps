import pandas as pd

# Our data is not fully reliable (null values, inconsistent capitalization, etc)
# Here we transform it into a clean version

# Receives a DataFrame, returns a DataFrame
def transform_data(df: pd.DataFrame) -> pd.DataFrame:
    print("[INFO] Transforming data....")

    # Making it daytime for easier analytics later on (we want to group by dates in our dashboard)
    df["date"] = pd.to_datetime(df["date"])

    # Making sure the shift (day, DAY, Day) is standardized
    df["shift"] = df["shift"].str.capitalize()

    # Handling nulls..
    df["downtime_minutes"] = df["downtime_minutes"].fillna(0) # We're assuming 0 downtime = unreported
    df["operator_id"] = df["operator_id"].fillna("UNKNOWN")

    # Making sure ints are what we expect them to be
    df["units_produced"] = df["units_produced"].astype(int)
    df["defective_units"] = df["defective_units"].astype(int)
    df["downtime_minutes"] = df["downtime_minutes"].astype(int)

    # Removing duplicates (same day, machine, and shift)
    # ONLY the first duplicated row is preserved
    df = df.drop_duplicates(subset=["date", "machine_id", "shift"])

    return df