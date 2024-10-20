from contextlib import asynccontextmanager
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from internal.presentation.restful.routes import add_routes
from pkg.config import get_settings
from pkg.database.postgres.connect_service import PostgresDatabaseConnectionError
from pkg.logger import setup_logger
from pkg.database.postgres import setup_database, close_database
from pkg.shutdown import shutdown_event

@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup
    logger = setup_logger()
    settings = get_settings()

    try:
        app.state.db = await setup_database(settings)
    except PostgresDatabaseConnectionError as e:
        logger.error(f"Failed to connect to the database: {e}")
        raise
    add_routes(app)
    logger.info("Application startup complete")
    
    yield
    
    # Shutdown
    await shutdown_event()
    if hasattr(app.state, 'db'):
        await close_database(app.state.db)
    logger.info("Application shutdown complete")

app = FastAPI(lifespan=lifespan)

# CORS settings
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

if __name__ == "__main__":
    import uvicorn
    settings = get_settings()
    uvicorn.run("main:app", host="0.0.0.0", port=settings.SERVER_PORT, reload=True)