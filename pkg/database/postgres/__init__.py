import asyncio
from pkg.config.config import Settings
from pkg.database.postgres.connect_service import IDatabaseSession, PostgresDatabaseConnectionError, PostgresSession

async def setup_database(settings: Settings) -> IDatabaseSession:
    max_retries = 1
    retry_delay = 1  # seconds

    for attempt in range(max_retries):
        try:
            session = PostgresSession(settings)
            await session.connect()
            return session
        except PostgresDatabaseConnectionError as e:
            if attempt == max_retries - 1:
                raise
            print(f"Database connection attempt {attempt + 1} failed. Retrying in {retry_delay} seconds...")
            await asyncio.sleep(retry_delay)

async def close_database(db: IDatabaseSession):
    if db:
        await db.disconnect()