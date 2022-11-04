# TaçaUA-API Service

Follow one of the installation tutorials to run this service. If everything was successful, the server should be up on http://localhost:8001/.

Check http://localhost:8001/docs to watch the API documentation with Swagger UI.

## DB Documentation
 to be written
<!-- TODO: complete -->

## API Documentation
 to be written
<!-- TODO: complete -->

## Local Installation

Make sure to have poetry installed.
```
pip install poetry
```

This step creates a database inside one container, rather than in your host. For that, install docker if needed and run this command to create the container for the PostgreSQL database. Once created, the container will always exist, unless it is specifically removed with `docker rm pg_db`. However, there may be need to start the container again when it stops (e.g. after a reboot). To start and stop the container, use `docker [start|stop] pg_db`.
```
docker run -d -p 0.0.0.0:5432:5432 -e POSTGRES_PASSWORD="postgres" --name pg_db postgres
```

Run this command to install all the Python dependencies required:
```
poetry install
```

Then, on the service's root directory, run the FastAPI server via poetry with the Python command: 
```
poetry run uvicorn app.main:app --reload
```

## Docker Installation

Create the container for two PostgreSQL databases, `postgres` and `postgres_test`.
```
docker run -d -p 0.0.0.0:5432:5432 -e POSTGRES_DB="postgres_test" -e POSTGRES_PASSWORD="postgres" --name pg_db postgres:15-alpine
```

On the service's root directory, build the image that will be used to create the service container. The flag `--no-cache` can be useful in some situations that require to not use cache when building the image.
```
docker build . -f Dockerfile.dev -t tacaua_api [--no-cache]
```

Create the NEI-API service.
```
docker run -it -v ${PWD}:/tacaua_api --network host --name tacaua_api tacaua_api
```

With this latter step, everything is completed. To restart the service afterwards, simply run `docker start pg_db` and `docker start -i tacaua_api` (the -i flag runs the container in interactive mode).

