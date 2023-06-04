.DEFAULT_GOAL := up-build

COMPOSE_RUNNER ?= docker-compose

ifeq ($(strip $(PRODUCTION)),)
  P := 
else
  P := .prod
endif

COMPOSE_FILE := compose$(P).yml

.PHONY: rally gala

rally gala: 
	@echo "Attaching $@ extension"
	$(eval COMPOSE_FILE = compose$(P).yml:extensions/$(@)/compose.override$(P).yml)
	@true

.PHONY: up down build push pull


up down build push pull:
	COMPOSE_FILE=$(COMPOSE_FILE) $(COMPOSE_RUNNER) $(@) $(FLAGS)

up-build: FLAGS := --build --remove-orphans
up-build: up
	
down-volumes: FLAGS := -v
down-volumes: down
	
