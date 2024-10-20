from abc import ABC, abstractmethod
import os
from urllib.parse import urlparse
import asyncpg
from typing import Any, Dict, List, Optional, Tuple
import logging

from pkg.config.config import Settings

# Error messages
ERR_POSTGRES_CONNECTION_FAILED = "[POSTGRES DATABASE CONNECTION FAILED]"
ERR_QUERY_EXECUTION_FAILED = "Query execution failed"
ERR_FETCH_DATA_FAILED = "Failed to fetch data"

# Log messages
LOG_CONNECTION_SUCCESS = "Successfully connected to PostgreSQL database"
LOG_DISCONNECTION_SUCCESS = "Disconnected from PostgreSQL database"
LOG_QUERY_EXECUTION_SUCCESS = "Query executed successfully"

class PostgresDatabaseConnectionError(Exception):
    pass

ErrPostgresDatabaseConnection = PostgresDatabaseConnectionError(ERR_POSTGRES_CONNECTION_FAILED)

class DatabaseError(Exception):
    pass

class IDatabaseSession(ABC):
    @abstractmethod
    async def connect(self) -> None:
        pass

    @abstractmethod
    async def disconnect(self) -> None:
        pass

    @abstractmethod
    async def execute(self, query: str, *params: Any) -> None:
        pass

    @abstractmethod
    async def fetch_one(self, query: str, *params: Any) -> Optional[Dict[str, Any]]:
        pass

    @abstractmethod
    async def fetch_all(self, query: str, *params: Any) -> List[Dict[str, Any]]:
        pass

    @abstractmethod
    async def begin_transaction(self) -> None:
        pass

    @abstractmethod
    async def commit_transaction(self) -> None:
        pass

    @abstractmethod
    async def rollback_transaction(self) -> None:
        pass

class PostgresSession(IDatabaseSession):
    def __init__(self, settings: Settings):
        self.database_url = settings.DATABASE_URL
        self.connection: Optional[asyncpg.Connection] = None
        self.logger = logging.getLogger(__name__)

    async def connect(self) -> None:
        try:
            url = urlparse(self.database_url)
            
            self.connection = await asyncpg.connect(
                user=url.username,
                password=url.password,
                database=url.path[1:],
                host=url.hostname,
                port=url.port or 5432
            )
            self.logger.info("Successfully connected to the database")
        except Exception as e:
            self.logger.error(f"Database connection failed: {str(e)}")
            raise

    async def disconnect(self) -> None:
        if self.connection:
            await self.connection.close()
            self.logger.info(LOG_DISCONNECTION_SUCCESS)

    async def execute(self, query: str, *params: Any) -> None:
        try:
            await self.connection.execute(query, *params)
            self.logger.info(LOG_QUERY_EXECUTION_SUCCESS)
        except Exception as e:
            self.logger.error(f"{ERR_QUERY_EXECUTION_FAILED}: {e}")
            raise DatabaseError(ERR_QUERY_EXECUTION_FAILED) from e

    async def fetch_one(self, query: str, *params: Any) -> Optional[Dict[str, Any]]:
        try:
            return await self.connection.fetchrow(query, *params)
        except Exception as e:
            self.logger.error(f"{ERR_FETCH_DATA_FAILED}: {e}")
            raise DatabaseError(ERR_FETCH_DATA_FAILED) from e

    async def fetch_all(self, query: str, *params: Any) -> List[Dict[str, Any]]:
        try:
            return await self.connection.fetch(query, *params)
        except Exception as e:
            self.logger.error(f"{ERR_FETCH_DATA_FAILED}: {e}")
            raise DatabaseError(ERR_FETCH_DATA_FAILED) from e

    async def begin_transaction(self) -> None:
        await self.connection.transaction()

    async def commit_transaction(self) -> None:
        # In asyncpg, transactions are handled with context managers or explicit calls
        pass

    async def rollback_transaction(self) -> None:
        # In asyncpg, transactions are handled with context managers or explicit calls
        pass

async def new_postgres_session(config: Dict[str, Any]) -> IDatabaseSession:
    session = PostgresSession(config)
    await session.connect()
    return session