from fastapi import APIRouter
from services.machine_service import (
    get_machines,
    get_machine_by_id
)

router = APIRouter(prefix="/machines", tags=["Machines"])

@router.get("")
def machines():
    return get_machines()

@router.get("/{id}")
def machine_by_id(id):
    return get_machine_by_id(id)