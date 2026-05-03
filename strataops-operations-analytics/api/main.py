from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from routers import kpis, machines

app = FastAPI(title="StrataOps API", version="1.0")

app.add_middleware(CORSMiddleware, allow_origins=["*"], allow_methods=["*"], allow_headers=["*"])

app.include_router(kpis.router)
app.include_router(machines.router)

@app.get("/health")
def health():
    return {"status": "OK", "service": "StrataOps API"}

