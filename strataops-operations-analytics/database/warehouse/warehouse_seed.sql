-- Making sure we're migrating properly from the old table to the warehouse schema

-- DIM MACHINE 
INSERT INTO dim_machine (machine_id, machine_type, installation_year)
SELECT machine_id, machine_type, installation_year
FROM machines;

-- DIM OPERATOR 
INSERT INTO dim_operator (operator_id)
SELECT DISTINCT operator_id
FROM production_logs;

INSERT INTO dim_date (date, year, month, day)
SELECT DISTINCT
    date,
    EXTRACT(YEAR FROM date),
    EXTRACT(MONTH FROM date),
    EXTRACT(DAY FROM date)
FROM production_logs;


INSERT INTO fact_production (
    shift,
    units_produced,
    defective_units,
    downtime_minutes,
    machine_id,
    date,
    operator_id
)
SELECT
    shift,
    units_produced,
    defective_units,
    downtime_minutes,
    machine_id,
    date,
    operator_id
FROM production_logs;