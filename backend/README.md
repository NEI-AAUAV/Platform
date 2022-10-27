# NEI-API Service

Follow one of the installation tutorials to run this service. If everything was successful, the server should be up on http://localhost:8000/.

Check http://localhost:8000/docs to watch the API documentation with Swagger UI.

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

Create the container for the PostgreSQL database.
```
docker run -d -p 0.0.0.0:5432:5432 -e POSTGRES_PASSWORD="postgres" --name pg_db postgres
```

On the service's root directory, build the image that will be used to create the service container. The flag `--no-cache` can be useful in some situations that require to not use cache when building the image.
```
docker build . -f Dockerfile.dev -t nei_api [--no-cache]
```

Create the NEI-API service.
```
docker run -it -v ${PWD}:/web_app -v /web_app/node_modules --network host --name nei_api nei_api
```

With this latter step, everything is completed. To restart the service afterwards, simply run `docker start pg_db` and `docker start -i nei_api` (the -i flag runs the container in interactive mode).


## Troubleshooting

Common errors that can happen during installation.

### 1. Poetry cannot install `psycopg2`

If `psycopg2` cannot be installed with `poetry install` due to the error `pg_config executable not found`, the pyscopg2 documentation recommends installing the following packages:
```
sudo apt install python3-dev libpq-dev 
```

### 2. Address already in use

If the FastAPI is having problems to start because the address is already in use, it is likely that another application is using the same port it is trying to use (the default port is **8000**). For a quick fix, kill the processes using that port with:
```
sudo fuser -k 8000/tcp
```

