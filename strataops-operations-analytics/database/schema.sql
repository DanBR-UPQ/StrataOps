CREATE TABLE machines (
    machine_id VARCHAR PRIMARY KEY,
    machine_type VARCHAR,
    installation_year INT
);

CREATE TABLE production_logs (
    id SERIAL PRIMARY KEY,
    date DATE NOT NULL,
    machine_id VARCHAR REFERENCES machines(machine_id),
    shift VARCHAR,
    operator_id VARCHAR,
    units_produced INT,
    defective_units INT,
    downtime_minutes INT
);

SELECT * FROM machines;
SELECT * FROM production_logs;