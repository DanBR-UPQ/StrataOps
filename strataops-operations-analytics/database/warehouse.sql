-- ---------------------------------- DIMENSIONS ---------------------------------- 

CREATE TABLE dim_machine (
    machine_key SERIAL PRIMARY KEY,
    machine_id VARCHAR UNIQUE,
    machine_type VARCHAR,
    installation_year INT
);

CREATE TABLE dim_date (
    date_key SERIAL PRIMARY KEY,
    date DATE UNIQUE,
    year INT,
    month INT,
    day INT
);

CREATE TABLE dim_operator (
    operator_key SERIAL PRIMARY KEY,
    operator_id VARCHAR UNIQUE,
);


-- ---------------------------------- FACT TABLE ---------------------------------- 

CREATE TABLE fact_production (
    id SERIAL PRIMARY KEY,

    shift VARCHAR,
    units_produced INT,
    defective_units INT,
    downtime_minutes INT,

    machine_key INT REFERENCES dim_machine(machine_key),
    date_key INT REFERENCES dim_date(date_key),
    operator_key INT REFERENCES dim_operator(operator_key)
);