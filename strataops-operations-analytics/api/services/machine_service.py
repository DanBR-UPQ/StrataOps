from db import query
from fastapi import HTTPException

def get_machines():
    return query("SELECT * FROM machines")

def get_machine_by_id(machine_id: int):
    result = query(
        "SELECT * FROM machines WHERE machine_id = :id",
        {"id": machine_id}
    )

    if not result:
        raise HTTPException(status_code=404, detail="Machine not found")
    
    return result[0]