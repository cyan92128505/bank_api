# Variable definitions
DOCKER_IMAGE_NAME = bank-api
DOCKER_IMAGE_TAG = latest
DOCKERFILE_PATH = deployment/docker/Dockerfile

# Development environment commands
.PHONY: dev
dev:
	@if [ -f .env ]; then \
		set -a; \
		source .env; \
		set +a; \
	else \
		echo "Warning: .env file not found. Using default environment."; \
	fi; \
	PYTHONPATH=. uvicorn commands.server.main:app --reload --host 0.0.0.0 --port $${SERVER_PORT:-8000}


.PHONY: test
test:
	pytest tests/

.PHONY: lint
lint:
	flake8 .

# Docker related commands
.PHONY: build
build:
	docker build -t $(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG) -f $(DOCKERFILE_PATH) .

.PHONY: up
up:
	docker-compose up

.PHONY: up-d
up-d:
	docker-compose up -d

.PHONY: down
down:
	docker-compose down

.PHONY: rebuild
rebuild: build down up

.PHONY: ps
ps:
	docker-compose ps

.PHONY: logs
logs:
	docker-compose logs

.PHONY: shell
shell:
	docker-compose exec web /bin/bash

.PHONY: clean
clean:
	docker system prune -f

.PHONY: rebuild-image
rebuild-image:
	docker build --no-cache -t $(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG) .

# Database related commands
.PHONY: db-migrate
db-migrate:
	./scripts/postgres.sh migrate

.PHONY: db-generate
db-generate:
	./scripts/postgres.sh generate

.PHONY: db-up
db-up:
	./scripts/postgres.sh up

.PHONY: db-down
db-down:
	./scripts/postgres.sh down

# Tool commands
.PHONY: generate-secret-key
generate-secret-key:
	chmod +x scripts/generate_secret_key.sh
	./scripts/generate_secret_key.sh

.PHONY: update-structure
update-structure:
	chmod +x scripts/dir_to_text.sh
	./scripts/dir_to_text.sh

# Help information
.PHONY: help
help:
	@echo "Available commands:"
	@echo "Development:"
	@echo "  make dev                - Run the development server"
	@echo "  make test               - Run tests"
	@echo "  make lint               - Run linter"
	@echo "Docker:"
	@echo "  make build              - Build the Docker image"
	@echo "  make up                 - Start the Docker Compose services"
	@echo "  make up-d               - Start the Docker Compose services in detached mode"
	@echo "  make down               - Stop and remove the Docker Compose services"
	@echo "  make rebuild            - Rebuild the image and restart services"
	@echo "  make ps                 - Show running containers"
	@echo "  make logs               - View container logs"
	@echo "  make shell              - Open a shell in the web service container"
	@echo "  make clean              - Clean up unused Docker resources"
	@echo "  make rebuild-image      - Rebuild the Docker image without caching"
	@echo "Database:"
	@echo "  make db-help            - Show help for database operations"
	@echo "  make db-migrate         - Run database migrations"
	@echo "  make db-generate        - Generate a new migration"
	@echo "  make db-up              - Apply all up migrations"
	@echo "  make db-down            - Apply all down migrations"
	@echo "Tools:"
	@echo "  make generate-secret-key - Generate a new SECRET_KEY and update .env file"
	@echo "  make update-structure   - Update the project structure file"