COMPOSE_FILE ?= compose.yml
UFLAGS ?= --build --remove-orphans

.PHONY: rally gala

rally gala: 
	$(eval COMPOSE_FILE = compose.yml:extensions/$(@)/compose.override.yml)
	@echo "Attaching $@ extension."
	@true

.PHONY: up down down-volumes

up:
	@echo "Starting platform."
	COMPOSE_FILE=$(COMPOSE_FILE) docker-compose up $(UFLAGS)

down: 
	COMPOSE_FILE=$(COMPOSE_FILE) docker-compose down $(DFLAGS)

down-volumes:
	COMPOSE_FILE=$(COMPOSE_FILE) docker-compose down -v
