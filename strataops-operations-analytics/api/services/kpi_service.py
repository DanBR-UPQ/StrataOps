from db import query


def get_global_kpis():
    return query("SELECT * FROM kpi_production_global")[0]


def get_kpis_machines():
    return query("SELECT * FROM agg_production_by_machine")


def get_kpis_shifts():
    return query("SELECT * FROM agg_production_by_shift")


def get_kpis_daily():
    return query("SELECT * FROM agg_production_by_date")


def get_kpis_machine_types():
    return query("SELECT * FROM agg_machine_by_type")


def get_kpis_installation_year():
    return query("SELECT * FROM agg_machine_by_installation_year")