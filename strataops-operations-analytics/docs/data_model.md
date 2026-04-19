# Data Model

## Tables

### production_logs
Stores daily production data per machine and shift.

### machines
Contains metadata about machines (type, installation year).

## Relationships

- production_logs.machine_id → machines.machine_id