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
class ${FEATURE_NAME}:
    def __init__(self):
        # TODO: Implement entity attributes
        pass

    # TODO: Implement domain methods
EOF

mkdir -p internal/domain/repositories
touch internal/domain/repositories/${FEATURE_NAME_SNAKE}_repository.py
cat << EOF > internal/domain/repositories/${FEATURE_NAME_SNAKE}_repository.py
from abc import ABC, abstractmethod

class ${FEATURE_NAME}Repository(ABC):
    @abstractmethod
    async def create(self, ${FEATURE_NAME_SNAKE}):
        pass

    @abstractmethod
    async def get(self, id):
        pass

    @abstractmethod
    async def update(self, ${FEATURE_NAME_SNAKE}):
        pass

    @abstractmethod
    async def delete(self, id):
        pass
EOF

# Create application layer files
mkdir -p internal/application/services
touch internal/application/services/${FEATURE_NAME_SNAKE}_service.py
cat << EOF > internal/application/services/${FEATURE_NAME_SNAKE}_service.py
class ${FEATURE_NAME}Service:
    def __init__(self, ${FEATURE_NAME_SNAKE}_repository):
        self.${FEATURE_NAME_SNAKE}_repository = ${FEATURE_NAME_SNAKE}_repository

    async def create_${FEATURE_NAME_SNAKE}(self, ${FEATURE_NAME_SNAKE}_data):
        # TODO: Implement creation logic
        pass

    async def get_${FEATURE_NAME_SNAKE}(self, id):
        # TODO: Implement retrieval logic
        pass

    async def update_${FEATURE_NAME_SNAKE}(self, id, ${FEATURE_NAME_SNAKE}_data):
        # TODO: Implement update logic
        pass

    async def delete_${FEATURE_NAME_SNAKE}(self, id):
        # TODO: Implement deletion logic
        pass
EOF

# Create infrastructure layer files
mkdir -p internal/infrastructure/persistence
touch internal/infrastructure/persistence/${FEATURE_NAME_SNAKE}_repository_impl.py
cat << EOF > internal/infrastructure/persistence/${FEATURE_NAME_SNAKE}_repository_impl.py
from internal.domain.repositories.${FEATURE_NAME_SNAKE}_repository import ${FEATURE_NAME}Repository

class ${FEATURE_NAME}RepositoryImpl(${FEATURE_NAME}Repository):
    def __init__(self, db_session):
        self.db_session = db_session

    async def create(self, ${FEATURE_NAME_SNAKE}):
        # TODO: Implement database creation logic
        pass

    async def get(self, id):
        # TODO: Implement database retrieval logic
        pass

    async def update(self, ${FEATURE_NAME_SNAKE}):
        # TODO: Implement database update logic
        pass

    async def delete(self, id):
        # TODO: Implement database deletion logic
        pass
EOF

# Create interface layer files
mkdir -p internal/interfaces/api
touch internal/interfaces/api/${FEATURE_NAME_SNAKE}_routes.py
cat << EOF > internal/interfaces/api/${FEATURE_NAME_SNAKE}_routes.py
from fastapi import APIRouter, Depends
from internal.application.services.${FEATURE_NAME_SNAKE}_service import ${FEATURE_NAME}Service

router = APIRouter()

@router.post("/${FEATURE_NAME_SNAKE}s")
async def create_${FEATURE_NAME_SNAKE}(${FEATURE_NAME_SNAKE}_data: dict, service: ${FEATURE_NAME}Service = Depends()):
    # TODO: Implement creation route logic
    pass

@router.get("/${FEATURE_NAME_SNAKE}s/{${FEATURE_NAME_SNAKE}_id}")
async def get_${FEATURE_NAME_SNAKE}(${FEATURE_NAME_SNAKE}_id: int, service: ${FEATURE_NAME}Service = Depends()):
    # TODO: Implement retrieval route logic
    pass

@router.put("/${FEATURE_NAME_SNAKE}s/{${FEATURE_NAME_SNAKE}_id}")
async def update_${FEATURE_NAME_SNAKE}(${FEATURE_NAME_SNAKE}_id: int, ${FEATURE_NAME_SNAKE}_data: dict, service: ${FEATURE_NAME}Service = Depends()):
    # TODO: Implement update route logic
    pass

@router.delete("/${FEATURE_NAME_SNAKE}s/{${FEATURE_NAME_SNAKE}_id}")
async def delete_${FEATURE_NAME_SNAKE}(${FEATURE_NAME_SNAKE}_id: int, service: ${FEATURE_NAME}Service = Depends()):
    # TODO: Implement deletion route logic
    pass
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
echo "- Domain Layer: internal/domain/entities/${FEATURE_NAME_SNAKE}.py"
echo "- Repository Interface: internal/domain/repositories/${FEATURE_NAME_SNAKE}_repository.py"
echo "- Application Service: internal/application/services/${FEATURE_NAME_SNAKE}_service.py"
echo "- Repository Implementation: internal/infrastructure/persistence/${FEATURE_NAME_SNAKE}_repository_impl.py"
echo "- API Routes: internal/interfaces/api/${FEATURE_NAME_SNAKE}_routes.py"
echo "- Unit Tests: tests/unit/domain/test_${FEATURE_NAME_SNAKE}.py"
echo "- Integration Tests: tests/integration/test_${FEATURE_NAME_SNAKE}_api.py"
echo "Please implement the TODO items in each file."