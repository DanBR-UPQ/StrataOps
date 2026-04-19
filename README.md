# StrataOps — Factory Operations Analytics Dashboard (MVP)

An end-to-end data analytics project simulating a manufacturing environment, focused on monitoring production efficiency, defect rates, and machine downtime.


## Business Problem

Manufacturing companies need to monitor production performance to identify inefficiencies, reduce defects, and minimize downtime.

However, raw operational data is often fragmented and difficult to interpret without proper processing and visualization.

This project simulates a factory environment and demonstrates how data can be transformed into actionable insights through analytics and dashboards.


## Solution

I built a complete data pipeline that:

- Generates realistic production data
- Cleans and standardizes the dataset using Python
- Stores structured data in PostgreSQL
- Computes key performance indicators (KPIs) using SQL
- Visualizes insights in a Power BI dashboard

This pipeline reflects how real manufacturing data systems transform raw operational data into decision-making tools.


## Tech Stack

- **Python (pandas)** — data cleaning and preprocessing  
- **PostgreSQL** — relational database and data storage  
- **SQL** — KPI calculations and analytics queries  
- **Power BI** — data visualization and dashboarding  


## Architecture

Raw CSV → Python (ETL) → PostgreSQL → SQL (KPIs & Aggregations) → Power BI Dashboard


## Dataset

The dataset simulates daily production logs for multiple machines across different shifts.

### Columns:
- `date` — production date  
- `machine_id` — machine identifier  
- `shift` — day or night shift  
- `operator_id` — operator assigned  
- `units_produced` — total units produced  
- `defective_units` — defective units  
- `downtime_minutes` — machine downtime  


## Key Metrics (KPIs)

### Production Efficiency
Percentage of non-defective units produced.

### Defect Rate
Percentage of defective units relative to total production.

### Downtime Percentage
Proportion of time machines were not operational.

### Output per Machine
Total production per machine to identify top and underperformers.

### Shift Performance
Comparison of production and quality between day and night shifts.


## Key Insights

- Machine M1 has the highest downtime (19%), indicating a potential maintenance bottleneck.
- Machine M3 has the highest defect rate (~10.5%), suggesting a quality control issue.
- Night shifts consistently underperform compared to day shifts in quality.
- Production trends show variability over time, highlighting operational instability.


## Dashboard Preview

![Factory Dashboard](dashboard/screenshots/dashboard.png)


## How to Run

1. Generate dataset:
`python pipeline/generate_data.py`

2. Clean data:
`python pipeline/clean_data.py`

3. Load data into PostgreSQL

4. Execute SQL queries from `/database/queries.sql`

5. Open Power BI file:
`/dashboard/factory_dashboard.pbix`