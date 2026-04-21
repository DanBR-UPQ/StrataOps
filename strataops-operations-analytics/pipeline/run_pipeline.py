from extract import extract_data
from transform import transform_data
from load import load_data

def run():
    df = extract_data()
    df_clean = transform_data(df)
    load_data(df_clean)

if __name__ == "__main__":
    run()