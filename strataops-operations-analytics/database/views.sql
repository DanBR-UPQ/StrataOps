-- KPIs saved as views for easier Power BI analytics

-- KPI 1: EFFICIENCY
-- Percentage of useable (not defective) units
CREATE VIEW kpi_efficiency AS
SELECT 
    SUM(units_produced - defective_units)::float / SUM(units_produced) AS efficiency
FROM production_logs;
-- Returns number between 0-1. Eg 64% efficiency -> 0.64


-- KPI 2: DEFECT RATE
-- Opposite of efficiency: percentage of defective units
CREATE VIEW kpi_defect_rate AS
SELECT
    SUM(defective_units)::float / SUM(units_produced) AS defect_rate
FROM production_logs;
-- Returns number between 0-1. Eg 5% defect rate -> 0.05



-- KPI 3: DOWNTIME
-- Percentage of time spent on downtime
-- Assuming a shift = 8hrs (480mins)
CREATE VIEW kpi_downtime AS
SELECT
    SUM(downtime_minutes)::float / (COUNT(*) * 480) AS downtime_percentage
FROM production_logs;
-- Returns number between 0-1. 


-- KPI 4: OUTPUT PER MACHINE
-- Total units produced per machine
CREATE VIEW kpi_output_per_machine AS
SELECT
    machine_id AS machine,
    SUM(units_produced) AS total_output -- output is a reserved word sadly
FROM production_logs 
GROUP BY machine_id;



-- KPI 5: WORST MACHINES
-- Machines with their defect rate and total output
CREATE VIEW kpi_worst_machines AS
SELECT
    machine_id AS machine,
    SUM(units_produced) AS total_output,
    SUM(defective_units)::FLOAT / SUM(units_produced) AS defect_rate
FROM production_logs
GROUP BY machine_id;



-- KPI 6: SHIFT PERFORMANCE
-- How performance is affected by shift (day / night)
CREATE VIEW kpi_shift_performance AS
SELECT
    shift,
    SUM(units_produced) AS total_output,
    SUM(defective_units)::float / SUM(units_produced) AS defect_rate
FROM production_logs
GROUP BY shift;


-- KPI 7: DAILY TREND
-- Units produced per day
CREATE VIEW kpi_daily_trend AS
SELECT 
  date,
  SUM(units_produced) AS total_output
FROM production_logs
GROUP BY date;


-- KPI 8: DOWNTIME PER MACHINE
-- Machines with their respective downtime
CREATE VIEW kpi_downtime_per_machine AS
SELECT
    machine_id AS machine,
    SUM(downtime_minutes)::float / (COUNT(*) * 480) AS downtime_percentage
FROM production_logs
GROUP BY machine_id;


-- KPI 9: OUTPUT PER MACHINE TYPE
-- Machine types with their respective output
CREATE VIEW kpi_output_per_machine_type AS
SELECT
    m.machine_type AS machine_type,
    SUM(units_produced) AS total_output
FROM production_logs p 
JOIN machines m
    ON p.machine_id = m.machine_id
GROUP BY m.machine_type;


-- KPI 10: PERFORMANCE PER MACHINE AGE
-- Machine installation date with their respective performance
CREATE VIEW kpi_performance_per_machine_age AS
SELECT
    m.installation_year,
    SUM(p.units_produced) AS total_output,
    SUM(p.defective_units)::float / SUM(p.units_produced) AS defect_rate
FROM production_logs p 
JOIN machines m 
    ON p.machine_id = m.machine_id 
GROUP BY m.installation_year;
-- Returns table with machine installation date, output, defect rate (num between 0-1)


-- MASTER KPI
CREATE VIEW factory_kpis AS
SELECT
    SUM(units_produced) AS total_output,
    SUM(units_produced - defective_units)::float / SUM(units_produced) AS efficiency,
    SUM(defective_units)::float / SUM(units_produced) AS defect_rate,
    SUM(downtime_minutes)::float / (COUNT(*) * 480) AS downtime_percentage
FROM production_logs;