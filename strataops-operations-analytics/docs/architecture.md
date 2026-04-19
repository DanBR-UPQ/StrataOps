# Architecture Overview

This project follows a simple data pipeline:

CSV → Python → PostgreSQL → SQL → Power BI

## Steps

1. **Data Generation**
   - Simulated production logs stored as CSV

2. **Data Cleaning (Python)**
   - Standardizes formats
   - Handles missing values
   - Outputs clean dataset

3. **Database (PostgreSQL)**
   - Stores structured production data
   - Enables relational queries

4. **Analytics (SQL)**
   - Calculates KPIs such as efficiency, defect rate, and downtime

5. **Visualization (Power BI)**
   - Presents insights through interactive dashboards