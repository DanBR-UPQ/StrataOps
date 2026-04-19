-- Useful KPIs for our analytics
-- We're assuming one row = one shift for an individual machine

-- KPI 1: EFFICIENCY
-- Percentage of useable (not defective) units
SELECT 
    SUM(units_produced - defective_units)::float / SUM(units_produced) AS efficiency
FROM production_logs;
-- Returns number between 0-1. Eg 64% efficiency -> 0.64


-- KPI 2: DEFECT RATE
-- Opposite of efficiency: percentage of defective units
SELECT
    SUM(defective_units)::float / SUM(units_produced) AS defect_rate
FROM production_logs;
-- Returns number between 0-1. Eg 5% defect rate -> 0.05


-- Testing if we got the correct numbers..
SELECT 
  SUM(units_produced),
  SUM(defective_units)
FROM production_logs;


-- KPI 3: DOWNTIME
-- Percentage of time spent on downtime
-- Assuming a shift = 8hrs (480mins)
SELECT
    SUM(downtime_minutes)::float / (COUNT(*) * 480) AS downtime_percentage
FROM production_logs;
-- Returns number between 0-1. 


-- KPI 4: OUTPUT PER MACHINE
-- Total units produced per machine
SELECT
    machine_id AS machine,
    SUM(units_produced) AS total_output -- output is a reserved word sadly
FROM production_logs 
    GROUP BY machine_id ORDER BY total_output DESC;
-- Returns table with machine id and units produced. Eg M2, 33928


-- KPI 5: WORST MACHINES
-- Machines with their defect rate and total output
SELECT
    machine_id AS machine,
    SUM(units_produced) AS total_output,
    SUM(defective_units)::FLOAT / SUM(units_produced) AS defect_rate
FROM production_logs
    GROUP BY machine_id ORDER BY defect_rate DESC;
-- Returns table with machine id, output, and defect rate (number between 0-1). Eg M3, 33835, 0.1056


-- KPI 6: SHIFT PERFORMANCE
-- How performance is affected by shift (day / night)
SELECT
    shift,
    SUM(units_produced) AS total_output,
    SUM(defective_units)::float / SUM(units_produced) AS defect_rate
FROM production_logs
    GROUP BY shift ORDER BY defect_rate DESC;
-- Returns table with shift, output, and defect rate (number between 0-1). Eg Night, 84697, 0.065


-- KPI 7: DAILY TREND
-- Units produced per day
SELECT 
  date,
  SUM(units_produced) AS total_output
FROM production_logs
    GROUP BY date ORDER BY date;
-- Returns table with date and units produced. Eg 2025-01-01, 1389


-- KPI 8: DOWNTIME PER MACHINE
-- Machines with their respective downtime
SELECT
    machine_id AS machine,
    SUM(downtime_minutes)::float / (COUNT(*) * 480) AS downtime_percentage
FROM production_logs
    GROUP BY machine_id ORDER BY downtime_percentage DESC;
-- Returns table with machine id and downtime (number between 0-1). Eg M1, 0.189


-- KPI 9: OUTPUT PER MACHINE TYPE
-- Machine types with their respective output
SELECT
    m.machine_type AS machine_type,
    SUM(units_produced) AS total_output
FROM production_logs p JOIN machines m
    ON p.machine_id = m.machine_id
    GROUP BY m.machine_type ORDER BY total_output DESC;


-- KPI 10: PERFORMANCE PER MACHINE AGE
-- Machine installation date with their respective performance
SELECT
    m.installation_year,
    SUM(p.units_produced) AS total_output,
    SUM(p.defective_units)::float / SUM(p.units_produced) AS defect_rate
FROM production_logs p JOIN machines m 
    ON p.machine_id = m.machine_id 
    GROUP BY m.installation_year ORDER BY m.installation_year DESC;
-- Returns table with machine installation date, output, defect rate (num between 0-1). Eg 2022, 33784, 0.023768647880653564