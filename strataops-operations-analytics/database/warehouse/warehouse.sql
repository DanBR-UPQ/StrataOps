-- ---------------------------------- DIMENSIONS ---------------------------------- 

CREATE TABLE dim_machine (
    machine_id VARCHAR PRIMARY KEY,
    machine_type VARCHAR,
    installation_year INT
);

CREATE TABLE dim_date (
    date DATE PRIMARY KEY,
    year INT,
    month INT,
    day INT
);

CREATE TABLE dim_operator (
    operator_id VARCHAR PRIMARY KEY
);


-- ---------------------------------- FACT TABLE ---------------------------------- 

CREATE TABLE fact_production (
    id SERIAL PRIMARY KEY,

    shift VARCHAR,
    units_produced INT,
    defective_units INT,
    downtime_minutes INT,

    machine_id VARCHAR REFERENCES dim_machine(machine_id),
    date DATE REFERENCES dim_date(date),
    operator_id VARCHAR REFERENCES dim_operator(operator_id)
);