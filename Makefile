DOCKER_IMAGE_NAME = bank-api
DOCKER_IMAGE_TAG = latest

.PHONY: all
all: build

.PHONY: build
build:
	docker build -t $(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG) .

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

.PHONY: generate-secret-key
generate-secret-key:
	python tools/generate_secret_key.py

# 幫助信息
.PHONY: help
help:
	@echo "Available commands:"
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
	@echo "  make generate-secret-key - Generate a new SECRET_KEY and update .env file"