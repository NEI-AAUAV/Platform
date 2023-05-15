COMPOSE_FILE ?= compose.yml

.PHONY: rally gala

rally gala: 
	$(eval COMPOSE_FILE = compose.yml:extensions/$(@)/compose.override.yml)
	@echo "Attaching $@ extension."
	@true

.PHONY: up down down-volumes

up:
	@echo "Starting platform."
	COMPOSE_FILE=$(COMPOSE_FILE) docker-compose up --build --remove-orphans

down: 
	COMPOSE_FILE=$(COMPOSE_FILE) docker-compose down

down-volumes:
	COMPOSE_FILE=$(COMPOSE_FILE) docker-compose down -v
