import pandas as pd
from sqlalchemy import create_engine, text
from dotenv import load_dotenv
import os

load_dotenv()
DB_URI = os.getenv("DB_URI")

engine = create_engine(DB_URI)

# We make sure we're only adding NEW data
# That is, we check for the latest date on the DB and only insert if it's after said date



# -------------------------------------- FILTERING BY DATE -------------------------------------- 



# Grabbing the oldest date from our DB..
# Returns date (eg 2025.02.02)
def get_last_loaded_date():
    with engine.connect() as conn:
        result = conn.execute(text("SELECT MAX(date) FROM production_logs"))
        last_date = result.scalar()
        return last_date


# Remove all data older than that point
# Returns filtered df
def filter_new_data(df: pd.DataFrame, last_date):
    if last_date is None:
        print("[INFO] No existing data found. Loading full dataset..")
        return df

    last_date = pd.to_datetime(last_date) # date -> pandas datetime (code didn't work without this)
    print(f"[INFO] Last loaded date: {last_date}")

    new_df = df[df["date"] > last_date]

    print(f"[INFO] New rows to insert: {len(new_df)}")
    return new_df



# -------------------------------------- LOADING -------------------------------------- 




# Loading it into the db automatically.. (we had to import the csv into pgadmin manually before this)
def load_data(df: pd.DataFrame):
    print("[INFO] Loading data....")
    print(f"[INFO] Total rows before filter: {len(df)}")

    last_date = get_last_loaded_date()
    df_new = filter_new_data(df, last_date)

    if df_new.empty:
        print("[INFO] No new data to load.")
        return

    df_new.to_sql("production_logs", engine, if_exists="append", index=False)

    print(f"[INFO] Inserted {len(df_new)} new rows.")