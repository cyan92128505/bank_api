from fastapi import APIRouter, Request, HTTPException, Depends
from pkg.database.postgres.connect_service import IDatabaseSession, DatabaseError
from pkg.logger import logger
from pkg.config.config import settings

router = APIRouter()

async def get_db(request: Request) -> IDatabaseSession:
    return request.app.state.db

@router.get("/")
async def root():
    return {"message": f"Welcome to {settings.API_NAME}"}

@router.get("/db-test")
async def db_test(db: IDatabaseSession = Depends(get_db)):
    try:
        result = await db.fetch_one("SELECT 1 as test")
        return {"message": "Database connection successful", "result": result}
    except DatabaseError as e:
        logger.error(f"Database query failed: {e}")
        raise HTTPException(status_code=500, detail="Database query failed")

def add_routes(app):
    app.include_router(router)