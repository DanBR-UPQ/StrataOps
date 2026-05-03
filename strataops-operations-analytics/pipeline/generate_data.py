# We're simulating a small factory with machines M1 through M5 working day and night.

# Each machine is slightly different (Some are faster but make more defects,
# some are slow but reliable, etc)

# Sometimes, operators miss registering some data (downtime not properly logged, operator
# credentials not registered) 

# Some people write "Day" as "day" or "DAY" as well, we'll have to work on this for
# consistency later



import pandas as pd
import random
from datetime import datetime, timedelta


start_date = datetime(2025, 1, 1)
days = 365 * 3  # ~3 years
machines = ["M1", "M2", "M3", "M4", "M5"]
shifts = ["Day", "Night"]

data = []

for i in range(days):
    current_date = start_date + timedelta(days=i)

    for machine in machines:
        for shift in shifts:

            # Base production
            units = random.randint(100, 180)

            operator = f"OP{random.randint(1,10)}"

            # Machine behavior
            if machine == "M1":
                downtime = random.randint(40, 120)
                defect_rate = random.uniform(0.05, 0.10)

            elif machine == "M3":
                downtime = random.randint(10, 40)
                defect_rate = random.uniform(0.08, 0.12)

            elif machine == "M5":
                downtime = random.randint(0, 15)
                defect_rate = random.uniform(0.01, 0.03)

            else:
                downtime = random.randint(5, 40)
                defect_rate = random.uniform(0.02, 0.06)

            # Everything is a lil worse at night
            if shift == "Night":
                downtime += random.randint(5, 20)
                defect_rate += 0.01

            # Not everyone writes day the same..
            if shift == "Day" and random.random() < 0.1:
                shift = "day"
            if shift == "Day" and random.random() < 0.05:
                shift = "DAY"

            # Bad day effect
            if random.random() < 0.1:
                downtime += random.randint(20, 50)
                defect_rate += 0.03

            defective_units = int(units * defect_rate)

            # Sprinkling some missing values...
            if random.random() < 0.01:
                downtime = None
            if random.random() < 0.005:
                operator = None

            data.append([
                current_date.strftime("%Y-%m-%d"),
                machine,
                shift,
                operator,
                units,
                defective_units,
                downtime
            ])

df = pd.DataFrame(data, columns=[
    "date", "machine_id", "shift", "operator_id",
    "units_produced", "defective_units", "downtime_minutes"
])
# jus making sure downtime defects get saved as Nan and not 0.0
print(f"Downtime nulls: {df['downtime_minutes'].isna().sum()}")

df.to_csv("../data/raw/production_logs.csv", index=False)


print("Dataset generated succesfully!")