import pandas as pd

# We grab the data from our production logs...
def extract_data(path="../data/raw/production_logs.csv"):
    print("[INFO] Extracting data....")
    df = pd.read_csv(path)
    return df