from fastapi import FastAPI, Request, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from contextlib import asynccontextmanager
from pkg.config.config import settings
from pkg.logger import logger
from pkg.database.postgres.connect_service import new_postgres_session, PostgresDatabaseConnectionError, DatabaseError

@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup event
    logger.info(f"Starting up the application: {settings.API_NAME}")
    try:
        # Establish database connection
        db_session = new_postgres_session({"dsn": settings.DATABASE_URL})
        app.state.db = db_session
        logger.info("Database connection established")
    except PostgresDatabaseConnectionError as e:
        logger.error(f"Failed to connect to the database: {e}")
        raise

    yield
    
    # Shutdown event
    logger.info(f"Shutting down the application: {settings.API_NAME}")
    if hasattr(app.state, 'db'):
        app.state.db.disconnect()
        logger.info("Database connection closed")

app = FastAPI(title=settings.API_NAME, version="1.0.0", lifespan=lifespan)

# CORS settings
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Should be set to specific domains in production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
async def root():
    return {"message": f"Welcome to {settings.API_NAME}"}

@app.get("/db-test")
async def db_test(request: Request):
    try:
        result = request.app.state.db.fetch_one("SELECT 1 as test")
        return {"message": "Database connection successful", "result": result}
    except DatabaseError as e:
        logger.error(f"Database query failed: {e}")
        raise HTTPException(status_code=500, detail="Database query failed")

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)