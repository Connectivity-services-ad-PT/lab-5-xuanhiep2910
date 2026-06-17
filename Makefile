.PHONY: install lint build run compose-up compose-down logs test-compose health ensure-network ensure-env

IMAGE_TAG ?= v0.1.0-team-iot

install:
	npm install

lint:
	npx spectral lint contracts/*.yaml

build:
	docker build -t fit4110/iot-ingestion:$(IMAGE_TAG) .
	docker build -f Dockerfile.ai -t fit4110/ai-service:$(IMAGE_TAG) .

run:
	docker run --rm --name fit4110-api-lab05 -p 8000:8000 --env-file .env.example fit4110/iot-ingestion:$(IMAGE_TAG)

ensure-network:
	@docker network inspect class-net >/dev/null 2>&1 || docker network create class-net

ensure-env:
	@test -f .env || cp .env.example .env

compose-up: ensure-network ensure-env
	docker compose up -d --build --wait

compose-down:
	docker compose down

logs:
	docker compose logs -f

health:
	curl -fsS http://localhost:8000/health
	curl -fsS http://localhost:9000/health
	docker compose exec -T db pg_isready -U lab05 -d iotdb

test-compose: ensure-env
	npm run test:compose
