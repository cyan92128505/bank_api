#!/bin/bash

# Check if a feature name is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <feature_name>"
    exit 1
fi

FEATURE_NAME=$1
FEATURE_NAME_SNAKE=$(echo $FEATURE_NAME | sed 's/[A-Z]/_&/g;s/^_//' | tr '[:upper:]' '[:lower:]')

# Create domain layer files
mkdir -p internal/domain/entities
touch internal/domain/entities/${FEATURE_NAME_SNAKE}.py
cat << EOF > internal/domain/entities/${FEATURE_NAME_SNAKE}.py
from pydantic import BaseModel

class ${FEATURE_NAME}(BaseModel):
    # TODO: Implement entity attributes
    pass

    # TODO: Implement domain methods
EOF

mkdir -p internal/domain/repositories
touch internal/domain/repositories/${FEATURE_NAME_SNAKE}_repository.py
cat << EOF > internal/domain/repositories/${FEATURE_NAME_SNAKE}_repository.py
from abc import ABC, abstractmethod
from internal.domain.entities.${FEATURE_NAME_SNAKE} import ${FEATURE_NAME}

class I${FEATURE_NAME}Repository(ABC):
    @abstractmethod
    async def create(self, ${FEATURE_NAME_SNAKE}: ${FEATURE_NAME}) -> ${FEATURE_NAME}:
        pass

    @abstractmethod
    async def get(self, id: int) -> ${FEATURE_NAME}:
        pass

    @abstractmethod
    async def update(self, ${FEATURE_NAME_SNAKE}: ${FEATURE_NAME}) -> ${FEATURE_NAME}:
        pass

    @abstractmethod
    async def delete(self, id: int) -> bool:
        pass
EOF

mkdir -p internal/domain/usecases
touch internal/domain/usecases/${FEATURE_NAME_SNAKE}_usecase.py
cat << EOF > internal/domain/usecases/${FEATURE_NAME_SNAKE}_usecase.py
from abc import ABC, abstractmethod
from internal.domain.entities.${FEATURE_NAME_SNAKE} import ${FEATURE_NAME}

class I${FEATURE_NAME}UseCase(ABC):
    @abstractmethod
    async def create_${FEATURE_NAME_SNAKE}(self, ${FEATURE_NAME_SNAKE}_data: dict) -> ${FEATURE_NAME}:
        pass

    @abstractmethod
    async def get_${FEATURE_NAME_SNAKE}(self, id: int) -> ${FEATURE_NAME}:
        pass

    @abstractmethod
    async def update_${FEATURE_NAME_SNAKE}(self, id: int, ${FEATURE_NAME_SNAKE}_data: dict) -> ${FEATURE_NAME}:
        pass

    @abstractmethod
    async def delete_${FEATURE_NAME_SNAKE}(self, id: int) -> bool:
        pass
EOF

# Create application layer files
mkdir -p internal/application/services
touch internal/application/services/${FEATURE_NAME_SNAKE}_service.py
cat << EOF > internal/application/services/${FEATURE_NAME_SNAKE}_service.py
from internal.domain.usecases.${FEATURE_NAME_SNAKE}_usecase import I${FEATURE_NAME}UseCase
from internal.domain.repositories.${FEATURE_NAME_SNAKE}_repository import I${FEATURE_NAME}Repository
from internal.domain.entities.${FEATURE_NAME_SNAKE} import ${FEATURE_NAME}

class ${FEATURE_NAME}Service(I${FEATURE_NAME}UseCase):
    def __init__(self, ${FEATURE_NAME_SNAKE}_repository: I${FEATURE_NAME}Repository):
        self.${FEATURE_NAME_SNAKE}_repository = ${FEATURE_NAME_SNAKE}_repository

    async def create_${FEATURE_NAME_SNAKE}(self, ${FEATURE_NAME_SNAKE}_data: dict) -> ${FEATURE_NAME}:
        # TODO: Implement creation logic
        pass

    async def get_${FEATURE_NAME_SNAKE}(self, id: int) -> ${FEATURE_NAME}:
        # TODO: Implement retrieval logic
        pass

    async def update_${FEATURE_NAME_SNAKE}(self, id: int, ${FEATURE_NAME_SNAKE}_data: dict) -> ${FEATURE_NAME}:
        # TODO: Implement update logic
        pass

    async def delete_${FEATURE_NAME_SNAKE}(self, id: int) -> bool:
        # TODO: Implement deletion logic
        pass
EOF

# Create infrastructure layer files
mkdir -p internal/infrastructure/persistence/postgres
touch internal/infrastructure/persistence/postgres/${FEATURE_NAME_SNAKE}_repository.py
cat << EOF > internal/infrastructure/persistence/postgres/${FEATURE_NAME_SNAKE}_repository.py
from internal.domain.repositories.${FEATURE_NAME_SNAKE}_repository import I${FEATURE_NAME}Repository
from internal.domain.entities.${FEATURE_NAME_SNAKE} import ${FEATURE_NAME}

class ${FEATURE_NAME}Repository(I${FEATURE_NAME}Repository):
    def __init__(self, db_session):
        self.db_session = db_session

    async def create(self, ${FEATURE_NAME_SNAKE}: ${FEATURE_NAME}) -> ${FEATURE_NAME}:
        # TODO: Implement database creation logic
        pass

    async def get(self, id: int) -> ${FEATURE_NAME}:
        # TODO: Implement database retrieval logic
        pass

    async def update(self, ${FEATURE_NAME_SNAKE}: ${FEATURE_NAME}) -> ${FEATURE_NAME}:
        # TODO: Implement database update logic
        pass

    async def delete(self, id: int) -> bool:
        # TODO: Implement database deletion logic
        pass
EOF

# Create PO file
mkdir -p internal/infrastructure/po/postgres/
touch internal/infrastructure/po/postgres/${FEATURE_NAME_SNAKE}_po.py
cat << EOF > internal/infrastructure/po/postgres/${FEATURE_NAME_SNAKE}_po.py
from sqlalchemy import Column, Integer, String, DateTime
from sqlalchemy.ext.declarative import declarative_base

Base = declarative_base()

class ${FEATURE_NAME}PO(Base):
    __tablename__ = '${FEATURE_NAME_SNAKE}s'

    id = Column(Integer, primary_key=True, autoincrement=True)
    # TODO: Add more columns as needed
    created_at = Column(DateTime, nullable=False)
    updated_at = Column(DateTime, nullable=False)

    # TODO: Implement any necessary methods
EOF

# Create presentation layer files
mkdir -p internal/presentation/restful/handlers
touch internal/presentation/restful/handlers/${FEATURE_NAME_SNAKE}_handler.py
cat << EOF > internal/presentation/restful/handlers/${FEATURE_NAME_SNAKE}_handler.py
from fastapi import APIRouter, Depends, HTTPException
from internal.domain.usecases.${FEATURE_NAME_SNAKE}_usecase import I${FEATURE_NAME}UseCase
from internal.application.services.${FEATURE_NAME_SNAKE}_service import ${FEATURE_NAME}Service
from internal.domain.entities.${FEATURE_NAME_SNAKE} import ${FEATURE_NAME}
from internal.domain.dto.restful.${FEATURE_NAME_SNAKE}_dto import ${FEATURE_NAME}CreateDTO, ${FEATURE_NAME}UpdateDTO, ${FEATURE_NAME}ResponseDTO

router = APIRouter()

def get_${FEATURE_NAME_SNAKE}_service() -> I${FEATURE_NAME}UseCase:
    # TODO: Implement dependency injection
    pass

@router.post("/${FEATURE_NAME_SNAKE}s", response_model=${FEATURE_NAME}ResponseDTO)
async def create_${FEATURE_NAME_SNAKE}(${FEATURE_NAME_SNAKE}_data: ${FEATURE_NAME}CreateDTO, service: I${FEATURE_NAME}UseCase = Depends(get_${FEATURE_NAME_SNAKE}_service)):
    # TODO: Implement creation route logic
    pass

@router.get("/${FEATURE_NAME_SNAKE}s/{${FEATURE_NAME_SNAKE}_id}", response_model=${FEATURE_NAME}ResponseDTO)
async def get_${FEATURE_NAME_SNAKE}(${FEATURE_NAME_SNAKE}_id: int, service: I${FEATURE_NAME}UseCase = Depends(get_${FEATURE_NAME_SNAKE}_service)):
    # TODO: Implement retrieval route logic
    pass

@router.put("/${FEATURE_NAME_SNAKE}s/{${FEATURE_NAME_SNAKE}_id}", response_model=${FEATURE_NAME}ResponseDTO)
async def update_${FEATURE_NAME_SNAKE}(${FEATURE_NAME_SNAKE}_id: int, ${FEATURE_NAME_SNAKE}_data: ${FEATURE_NAME}UpdateDTO, service: I${FEATURE_NAME}UseCase = Depends(get_${FEATURE_NAME_SNAKE}_service)):
    # TODO: Implement update route logic
    pass

@router.delete("/${FEATURE_NAME_SNAKE}s/{${FEATURE_NAME_SNAKE}_id}")
async def delete_${FEATURE_NAME_SNAKE}(${FEATURE_NAME_SNAKE}_id: int, service: I${FEATURE_NAME}UseCase = Depends(get_${FEATURE_NAME_SNAKE}_service)):
    # TODO: Implement deletion route logic
    pass
EOF


# Create DTO files
mkdir -p internal/domain/dto/restful
touch internal/domain/dto/restful/${FEATURE_NAME_SNAKE}_dto.py
cat << EOF > internal/domain/dto/restful/${FEATURE_NAME_SNAKE}_dto.py
from pydantic import BaseModel
from typing import Optional

class ${FEATURE_NAME}CreateDTO(BaseModel):
    # TODO: Add fields for creating a new ${FEATURE_NAME}
    pass

class ${FEATURE_NAME}UpdateDTO(BaseModel):
    # TODO: Add fields for updating an existing ${FEATURE_NAME}
    pass

class ${FEATURE_NAME}ResponseDTO(BaseModel):
    id: int
    # TODO: Add fields for ${FEATURE_NAME} response
    created_at: str
    updated_at: str
EOF


# Create test files
mkdir -p tests/unit/domain
touch tests/unit/domain/test_${FEATURE_NAME_SNAKE}.py
cat << EOF > tests/unit/domain/test_${FEATURE_NAME_SNAKE}.py
import pytest
from internal.domain.entities.${FEATURE_NAME_SNAKE} import ${FEATURE_NAME}

def test_${FEATURE_NAME_SNAKE}_creation():
    # TODO: Implement entity creation test
    pass

# TODO: Add more unit tests
EOF

mkdir -p tests/integration
touch tests/integration/test_${FEATURE_NAME_SNAKE}_api.py
cat << EOF > tests/integration/test_${FEATURE_NAME_SNAKE}_api.py
import pytest
from fastapi.testclient import TestClient
from main import app

client = TestClient(app)

def test_create_${FEATURE_NAME_SNAKE}():
    # TODO: Implement create API test
    pass

def test_get_${FEATURE_NAME_SNAKE}():
    # TODO: Implement get API test
    pass

def test_update_${FEATURE_NAME_SNAKE}():
    # TODO: Implement update API test
    pass

def test_delete_${FEATURE_NAME_SNAKE}():
    # TODO: Implement delete API test
    pass
EOF

echo "Feature $FEATURE_NAME has been created with the following structure:"
echo "- Domain Layer:"
echo "  - Entity: internal/domain/entities/${FEATURE_NAME_SNAKE}.py"
echo "  - Repository Interface: internal/domain/repositories/${FEATURE_NAME_SNAKE}_repository.py"
echo "  - UseCase Interface: internal/domain/usecases/${FEATURE_NAME_SNAKE}_usecase.py"
echo "- Application Layer:"
echo "  - Service: internal/application/services/${FEATURE_NAME_SNAKE}_service.py"
echo "- Infrastructure Layer:"
echo "  - Repository Implementation: internal/infrastructure/persistence/postgres/${FEATURE_NAME_SNAKE}_repository.py"
echo "  - PO (Persistent Object): internal/infrastructure/po/postgres/${FEATURE_NAME_SNAKE}_po.py"
echo "- Presentation Layer:"
echo "  - API Handler: internal/presentation/restful/handlers/${FEATURE_NAME_SNAKE}_handler.py"
echo "  - DTO (Data Transfer Object): internal/domain/dto/restful/${FEATURE_NAME_SNAKE}_dto.py"
echo "- Tests:"
echo "  - Unit Tests: tests/unit/domain/test_${FEATURE_NAME_SNAKE}.py"
echo "  - Integration Tests: tests/integration/test_${FEATURE_NAME_SNAKE}_api.py"
echo "Please implement the TODO items in each file."