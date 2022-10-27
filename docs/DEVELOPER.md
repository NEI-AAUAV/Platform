[NEI-AAUAv Platform](../README.md)

# Developers Documentation

## Table of Contents

1. [System Architecture](#1-system-architecture)
2. [Local Installation](#2-local-installation)
3. [Docker Installation](#3-docker-installation)
4. [Docker Deployment](#4-docker-deployment)
5. [Automated Tests](#5-automated-tests)

## 1. System Architecture
 to be written
<!-- TODO: complete -->

## 2. Local Installation

To run the project in your host machine, read the **Local Installation** section of each service documentation.

- [Web App](../frontend/README.md#local-installation) web_app
- [NEI API](../backend/README.md#local-installation) nei_api
- [Taça UA API](../tacaua-service/README.md#local-installation) tacaua_api

## 3. Docker Installation

To run the project in docker containers, run the following commands. These will create and run the entire stack, meaning every service, in development mode. Since the containers are using bind mounts, every modification in your code will be triggered on the fly.

Creates and starts all containers of the stack.
```
docker-compose -f docker-compose.dev.yaml up --build
```

Stops or starts all containers of the stack, once already created.
```
docker-compose -f docker-compose.dev.yaml [stop|start]
```

Stops and removes the containers, including the volumes. Use this to rebuild the stack whenever any dependency is added (e.g. a `yarn` dependency).
```
docker-compose -f docker-compose.dev.yaml down -v
```

To run one service individually, append the service name to the command (e.g. `nei_api`). On alternative, create the images and the container manually by reading the **Docker Installation** section in the respective service documentation.
- [Web App](../frontend/README.md#docker-installation) web_app
- [NEI API](../backend/README.md#docker-installation) nei_api
- [Taça UA API](../tacaua-service/README.md#docker-installation) tacaua_api
```
docker-compose -f docker-compose.dev.yaml up --build [SERVICE...]
```

## 4. Docker Deployment
 to be written
<!-- TODO: complete -->


## 5. Automated Tests
 to be written
<!-- TODO: complete -->

