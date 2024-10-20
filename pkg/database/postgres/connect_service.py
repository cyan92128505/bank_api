from abc import ABC, abstractmethod
import psycopg2
from psycopg2 import sql
from psycopg2.extras import RealDictCursor
from typing import Any, Dict, List, Optional, Tuple
import logging

# Error messages
ERR_POSTGRES_CONNECTION_FAILED = "[POSTGRES DATABASE CONNECTION FAILED]"
ERR_QUERY_EXECUTION_FAILED = "Query execution failed"
ERR_FETCH_DATA_FAILED = "Failed to fetch data"

# Log messages
LOG_CONNECTION_SUCCESS = "Successfully connected to PostgreSQL database"
LOG_DISCONNECTION_SUCCESS = "Disconnected from PostgreSQL database"
LOG_QUERY_EXECUTION_SUCCESS = "Query executed successfully"

# Global error and connection function declarations
class PostgresDatabaseConnectionError(Exception):
    pass

ErrPostgresDatabaseConnection = PostgresDatabaseConnectionError(ERR_POSTGRES_CONNECTION_FAILED)

def Connect(dsn: str, **kwargs):
    return psycopg2.connect(dsn, **kwargs)

class DatabaseError(Exception):
    pass

class IDatabaseSession(ABC):
    @abstractmethod
    def connect(self) -> None:
        pass

    @abstractmethod
    def disconnect(self) -> None:
        pass

    @abstractmethod
    def execute(self, query: str, params: Optional[Tuple[Any, ...]] = None) -> None:
        pass

    @abstractmethod
    def fetch_one(self, query: str, params: Optional[Tuple[Any, ...]] = None) -> Optional[Dict[str, Any]]:
        pass

    @abstractmethod
    def fetch_all(self, query: str, params: Optional[Tuple[Any, ...]] = None) -> List[Dict[str, Any]]:
        pass

    @abstractmethod
    def begin_transaction(self) -> None:
        pass

    @abstractmethod
    def commit_transaction(self) -> None:
        pass

    @abstractmethod
    def rollback_transaction(self) -> None:
        pass

class PostgresSession(IDatabaseSession):
    def __init__(self, config: Dict[str, Any]):
        self.config = config
        self.connection = None
        self.logger = logging.getLogger(__name__)

    def connect(self) -> None:
        try:
            if 'dsn' in self.config:
                self.connection = Connect(self.config['dsn'])
            else:
                self.connection = Connect(**self.config)
            self.logger.info(LOG_CONNECTION_SUCCESS)
        except psycopg2.Error as e:
            self.logger.error(f"{ERR_POSTGRES_CONNECTION_FAILED}: {e}")
            raise ErrPostgresDatabaseConnection from e


    def disconnect(self) -> None:
        if self.connection:
            self.connection.close()
            self.logger.info(LOG_DISCONNECTION_SUCCESS)

    def execute(self, query: str, params: Optional[Tuple[Any, ...]] = None) -> None:
        try:
            with self.connection.cursor() as cursor:
                cursor.execute(query, params)
                self.connection.commit()
            self.logger.info(LOG_QUERY_EXECUTION_SUCCESS)
        except psycopg2.Error as e:
            self.logger.error(f"{ERR_QUERY_EXECUTION_FAILED}: {e}")
            raise DatabaseError(ERR_QUERY_EXECUTION_FAILED) from e

    def fetch_one(self, query: str, params: Optional[Tuple[Any, ...]] = None) -> Optional[Dict[str, Any]]:
        try:
            with self.connection.cursor(cursor_factory=RealDictCursor) as cursor:
                cursor.execute(query, params)
                return cursor.fetchone()
        except psycopg2.Error as e:
            self.logger.error(f"{ERR_FETCH_DATA_FAILED}: {e}")
            raise DatabaseError(ERR_FETCH_DATA_FAILED) from e

    def fetch_all(self, query: str, params: Optional[Tuple[Any, ...]] = None) -> List[Dict[str, Any]]:
        try:
            with self.connection.cursor(cursor_factory=RealDictCursor) as cursor:
                cursor.execute(query, params)
                return cursor.fetchall()
        except psycopg2.Error as e:
            self.logger.error(f"{ERR_FETCH_DATA_FAILED}: {e}")
            raise DatabaseError(ERR_FETCH_DATA_FAILED) from e

    def begin_transaction(self) -> None:
        self.connection.autocommit = False

    def commit_transaction(self) -> None:
        self.connection.commit()
        self.connection.autocommit = True

    def rollback_transaction(self) -> None:
        self.connection.rollback()
        self.connection.autocommit = True

def new_postgres_session(config: Dict[str, Any]) -> IDatabaseSession:
    session = PostgresSession(config)
    session.connect()
    return session