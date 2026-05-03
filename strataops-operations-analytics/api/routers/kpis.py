from fastapi import APIRouter
from services.kpi_service import (
    get_global_kpis,
    get_kpis_machines,
    get_kpis_shifts,
    get_kpis_daily,
    get_kpis_machine_types,
    get_kpis_installation_year
)

router = APIRouter(prefix="/kpis", tags=["KPIs"])

@router.get("")
def kpis():
    return get_global_kpis()

@router.get("/machines")
def kpis_machines():
    return get_kpis_machines()

@router.get("/shifts")
def kpis_shifts():
    return get_kpis_shifts()

@router.get("/daily")
def kpis_daily():
    return get_kpis_daily()

@router.get("/machine-types")
def kpis_machine_types():
    return get_kpis_machine_types()

@router.get("/installation-year")
def kpis_installation_year():
    return get_kpis_installation_year()