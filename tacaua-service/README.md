## Usage

Make sure to have poetry installed.
```
pip install poetry
```

Install docker if needed and run this command to create the container for the PostgreSQL database. Once created, the container will always exist, unless it is specifically removed with `docker rm pg`. However, there may be need to start the container again when it stops (e.g. when the computer reboots). To start and stop the container, use `docker start pg` and `docker stop pg` respectively.
```
docker run -d -P -p 127.0.0.1:5432:5432 -e POSTGRES_PASSWORD="1234" --name pg postgres
```

Run this command to install all the dependencies required:
```
poetry install
```

Then, run the FastAPI server via poetry with the Python command: 
```
poetry run uvicorn app.main:app --reload
```

If everything was successful, the server should be up on http://localhost:8000/.

Check http://localhost:8000/docs to watch the API documentation with Swagger UI.


## Troubleshooting

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
