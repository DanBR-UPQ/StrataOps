-- =========================================================
-- GLOBAL KPIs (single-row, single-purpose metrics)
-- =========================================================

-- Core factory KPIs (best for dashboard cards)
CREATE OR REPLACE VIEW kpi_production_global AS
SELECT
SUM(units_produced) AS total_units_produced,
SUM(units_produced - defective_units)::float / SUM(units_produced) AS efficiency,
SUM(defective_units)::float / SUM(units_produced) AS defect_rate,
SUM(downtime_minutes)::float / (COUNT(*) * 480) AS downtime_percentage
FROM production_logs;



-- =========================================================
-- PRODUCTION AGGREGATIONS
-- =========================================================

-- Output and quality by machine
CREATE OR REPLACE VIEW agg_production_by_machine AS
SELECT
machine_id,
SUM(units_produced) AS total_units_produced,
SUM(defective_units) AS total_defective_units,
SUM(defective_units)::float / SUM(units_produced) AS defect_rate,
SUM(downtime_minutes)::float / (COUNT(*) * 480) AS downtime_percentage
FROM production_logs
GROUP BY machine_id;

-- Performance by shift (Day vs Night)
CREATE OR REPLACE VIEW agg_production_by_shift AS
SELECT
shift,
SUM(units_produced) AS total_units_produced,
SUM(defective_units) AS total_defective_units,
SUM(defective_units)::float / SUM(units_produced) AS defect_rate,
SUM(downtime_minutes)::float / (COUNT(*) * 480) AS downtime_percentage
FROM production_logs
GROUP BY shift;

-- Daily production trend
CREATE OR REPLACE VIEW agg_production_by_date AS
SELECT
    date,
    SUM(units_produced) AS total_units_produced,
    SUM(defective_units) AS total_defective_units,
    SUM(defective_units)::float / SUM(units_produced) AS defect_rate,
    SUM(downtime_minutes)::float / (COUNT(*) * 480) AS downtime_percentage
FROM production_logs
GROUP BY date;



-- =========================================================
-- MACHINE-LEVEL AGGREGATIONS
-- =========================================================

-- Output by machine type
CREATE OR REPLACE VIEW agg_machine_by_type AS
SELECT
    m.machine_type,
    SUM(p.units_produced) AS total_units_produced,
    SUM(p.defective_units) AS total_defective_units,
    SUM(p.defective_units)::float / SUM(p.units_produced) AS defect_rate,
    SUM(p.downtime_minutes)::float / (COUNT(*) * 480) AS downtime_percentage
FROM production_logs p
JOIN machines m 
    ON p.machine_id = m.machine_id
GROUP BY m.machine_type;

-- Performance by machine installation year
CREATE OR REPLACE VIEW agg_machine_by_installation_year AS
SELECT
    m.installation_year,
    SUM(p.units_produced) AS total_units_produced,
    SUM(p.defective_units) AS total_defective_units,
    SUM(p.defective_units)::float / SUM(p.units_produced) AS defect_rate,
    SUM(p.downtime_minutes)::float / (COUNT(*) * 480) AS downtime_percentage
FROM production_logs p
JOIN machines m 
    ON p.machine_id = m.machine_id
GROUP BY m.installation_year;
