.DEFAULT_GOAL = up

COMPOSE_RUNNER = docker-compose
COMPOSE_FILE ?= compose.yml
UFLAGS ?= --build --remove-orphans

.PHONY: rally gala

rally gala: 
	@echo "Attaching $@ extension"
	$(eval COMPOSE_FILE = compose.yml:extensions/$(@)/compose.override.yml)
	@true

.PHONY: up down down-volumes

up:
	@echo "Starting platform containers"
	COMPOSE_FILE=$(COMPOSE_FILE) $(COMPOSE_RUNNER) up $(UFLAGS)

down:
	@echo "Removing platform containers"
	COMPOSE_FILE=$(COMPOSE_FILE) $(COMPOSE_RUNNER) down $(DFLAGS)

down-volumes:
	@echo "Removing platform containers and volumes"
	COMPOSE_FILE=$(COMPOSE_FILE) $(COMPOSE_RUNNER) down -v
