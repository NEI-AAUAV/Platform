# Default goal when running make without arguments
.DEFAULT_GOAL := up-build

ifneq (, $(shell docker compose --version 2>/dev/null))
  COMPOSE_RUNNER ?= docker compose
else ifneq (, $(shell podman compose --version 2>/dev/null))
  COMPOSE_RUNNER ?= podman compose
else ifneq (, $(shell podman-compose --version 2>/dev/null))
  COMPOSE_RUNNER ?= podman-compose
else
  COMPOSE_RUNNER ?= docker-compose
endif

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
# Use >&2 to make sure the echo goes to stderr and not stdout
	@echo "Attaching $@ extension" >&2
	$(eval COMPOSE_FILE := $(COMPOSE_FILE),extensions/$(@)/compose.override$(P).yml)
	@true


# Choose the compose goal to run
.PHONY: up down build push pull

# Short-hand for invoking the compose runner with all the correct variables set
INVOKE_RUNNER = COMPOSE_PATH_SEPARATOR="," COMPOSE_FILE="$(COMPOSE_FILE)" $(COMPOSE_RUNNER)

up down build push pull:
	$(INVOKE_RUNNER) $(@) $(FLAGS)


# Some goal aliases for convenience
up-build:
	$(INVOKE_RUNNER) up --build --remove-orphans $(FLAGS)
	
down-volumes:
	$(INVOKE_RUNNER) down -v $(FLAGS)

# Prints a comma separated list of the compose files used
files:
	@echo "$(COMPOSE_FILE)"
