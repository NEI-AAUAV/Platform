# GALA Service

Follow one of the installation tutorials to run this service. If everything was successful, the server should be up on http://localhost:8004/.

Check http://localhost:8004/docs to watch the API documentation with Swagger UI.

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

This step creates a database inside one container, rather than in your host. For that, install docker if needed and run this command to create the container for the MongoDB database. Once created, the container will always exist, unless it is specifically removed with `docker rm mongo_db`. However, there may be need to start the container again when it stops (e.g. after a reboot). To start and stop the container, use `docker [start|stop] mongo_db`.
```
docker run -d -p 0.0.0.0:27017:27017 -e MONGO_INITDB_DATABASE="mongo_test" -e MONGO_INITDB_ROOT_USERNAME="mongo" -e MONGO_INITDB_ROOT_PASSWORD="mongo" --name mongo_db mongo
```

Run this command to install all the Python dependencies required:
```
poetry install
```

Then, on the service's root directory, run the FastAPI server via poetry with the Python command: 
```
poetry run uvicorn app.main:app --port 8004 --reload
```

## Docker Installation

Create the container for the MongoDB database.
```
docker run -d -p 0.0.0.0:27017:27017 -e MONGO_INITDB_DATABASE="mongo_test" -e MONGO_INITDB_ROOT_USERNAME="mongo" -e MONGO_INITDB_ROOT_PASSWORD="mongo" --name mongo_db mongo
```

On the service's root directory, build the image that will be used to create the service container. The flag `--no-cache` can be useful in some situations that require to not use cache when building the image.
```
docker build . -t api_gala [--no-cache]
```

Create the GALA-API service.
```
docker run -it -v ${PWD}:/api_gala --network host --name api_gala api_gala
```

With this latter step, everything is completed. To restart the service afterwards, simply run `docker start mongo_db` and `docker start -i api_gala` (the -i flag runs the container in interactive mode).
