#!/bin/bash

# Set project name
PROJECT_NAME="bank_service"

# Create and activate virtual environment
python3 -m venv venv
source venv/bin/activate

# Create directory structure
mkdir -p cmd/server \
         internal/{domain/{entities,value_objects,aggregates,repositories},application/services,infrastructure/{persistence,messaging,external_services},interfaces/{api,events,cli}} \
         pkg/{logger,config} \
         tests/{unit,integration,e2e} \
         docs \
         scripts \
         deployment/{docker,kubernetes}

# Create basic files
touch cmd/server/main.py \
      .gitignore \
      README.md \
      requirements.txt \
      pyproject.toml

# Create some basic
echo "# Main entry point for the application" > cmd/server/main.py
echo "# Logger configuration" > pkg/logger/__init__.py
echo "# Configuration management" > pkg/config/__init__.py

# Create .gitignore 
cat << EOF > .gitignore
# Python
__pycache__/
*.py[cod]
*$py.class

# Virtual Environment
venv/
ENV/

# IDE
.vscode/
.idea/

# Logs
*.log

# OS generated files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db
structure.txt

# Environment variables
.env
EOF

# Create README.md
cat << EOF > README.md
# $PROJECT_NAME

This is a bank service project implemented using Python, following Domain-Driven Design (DDD) principles and Test-Driven Development (TDD) practices.

## Project Structure

The project follows a structure inspired by Go standard layout, adapted for Python and DDD:

- \`cmd/\`: Contains the main entry points for the application.
- \`internal/\`: Contains the core application code, divided into DDD layers.
- \`pkg/\`: Contains library code that can be used by external applications.
- \`tests/\`: Contains all test code, supporting TDD approach.
- \`docs/\`: Contains project documentation.
- \`scripts/\`: Contains various scripts for building, installing, analyzing, etc.
- \`deployment/\`: Contains deployment configurations and templates.

## Getting Started

1. Clone the repository
2. Create and activate the virtual environment:
   \`\`\`
   python3 -m venv venv
   source venv/bin/activate  # On Windows use \`venv\Scripts\activate\`
   \`\`\`
3. Install dependencies: \`pip install -r requirements.txt\`
4. Run the application: \`python cmd/server/main.py\`

## Running Tests

With the virtual environment activated, run \`pytest\` in the project root directory.

## Docker Development

1. Build the Docker image: \`docker-compose build\`
2. Run the services: \`docker-compose up\`

## Deployment

This project is configured for deployment on Google Cloud Run. Refer to the deployment documentation in the \`docs/\` directory for detailed instructions.

## Contributing

[Add contribution guidelines]

## License

[Add license information]
EOF

# Create requirements.txt
cat << EOF > requirements.txt
fastapi==0.68.0
uvicorn==0.15.0
sqlalchemy==1.4.23
asyncpg==0.24.0
psycopg2-binary==2.9.1
redis==3.5.3
pydantic==1.8.2
python-dotenv==0.19.0
pytest==6.2.5
pytest-asyncio==0.15.1
httpx==0.19.0
EOF

# Create pyproject.toml
cat << EOF > pyproject.toml
[tool.poetry]
name = "$PROJECT_NAME"
version = "0.1.0"
description = "A bank service project using FastAPI, PostgreSQL, and Redis"
authors = ["Your Name <your.email@example.com>"]

[tool.poetry.dependencies]
python = "^3.9"
fastapi = "^0.68.0"
uvicorn = "^0.15.0"
sqlalchemy = "^1.4.23"
asyncpg = "^0.24.0"
psycopg2-binary = "^2.9.1"
redis = "^3.5.3"
pydantic = "^1.8.2"
python-dotenv = "^0.19.0"

[tool.poetry.dev-dependencies]
pytest = "^6.2.5"
pytest-asyncio = "^0.15.1"
httpx = "^0.19.0"

[build-system]
requires = ["poetry-core>=1.0.0"]
build-backend = "poetry.core.masonry.api"

[tool.pytest.ini_options]
asyncio_mode = "auto"
EOF

# Create docker-compose.yml
cat << EOF > docker-compose.yml
version: '3.8'

services:
  web:
    build: .
    command: uvicorn cmd.server.main:app --host 0.0.0.0 --port 8000 --reload
    volumes:
      - .:/app
    ports:
      - "8000:8000"
    environment:
      - DATABASE_URL=postgresql://user:password@db/dbname
      - REDIS_URL=redis://redis:6379/0
    depends_on:
      - db
      - redis

  db:
    image: postgres:13
    volumes:
      - postgres_data:/var/lib/postgresql/data
    environment:
      - POSTGRES_USER=user
      - POSTGRES_PASSWORD=password
      - POSTGRES_DB=dbname

  redis:
    image: redis:6

volumes:
  postgres_data:
EOF

# Create Dockerfile
cat << EOF > Dockerfile
FROM python:3.9

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD ["uvicorn", "cmd.server.main:app", "--host", "0.0.0.0", "--port", "8000"]
EOF

# Install dependencies
pip install -r requirements.txt

echo "Project structure for $PROJECT_NAME has been created with venv support."
echo "Virtual environment is activated. You can start developing your application."
echo "To deactivate the virtual environment, run 'deactivate'."