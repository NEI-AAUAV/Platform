# Default goal when running make without arguments
.DEFAULT_GOAL := up-build

# Overwrite this if you have docker compose plugin instead of standalone
COMPOSE_RUNNER ?= docker-compose

# Define the compose environment file to use
ifeq ($(strip $(PRODUCTION)),)
  P := 
else
  P := .prod
endif
COMPOSE_FILE := compose$(P).yml


# Attach extensions to the compose file
.PHONY: rally gala

rally gala: 
	@echo "Attaching $@ extension"
	$(eval COMPOSE_FILE = compose$(P).yml:extensions/$(@)/compose.override$(P).yml)
	@true


# Choose the compose goal to run
.PHONY: up down build push pull

up down build push pull:
	COMPOSE_FILE=$(COMPOSE_FILE) $(COMPOSE_RUNNER) $(@) $(FLAGS)


# Some goal aliases for convenience
up-build:
	COMPOSE_FILE=$(COMPOSE_FILE) $(COMPOSE_RUNNER) up --build --remove-orphans $(FLAGS)
	
down-volumes:
	COMPOSE_FILE=$(COMPOSE_FILE) $(COMPOSE_RUNNER) down -v $(FLAGS)
