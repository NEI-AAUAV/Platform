## Usage

Make sure to have poetry installed.
```
pip install poetry
```

Install docker if needed and run this command to create the container for the PostgreSQL database.
```
docker run -d -P -p 127.0.0.1:5432:5432 -e POSTGRES_PASSWORD="1234" --name pg postgres
```

Run the FastAPI server via poetry with the Python command: 
```
poetry run uvicorn app.main:app --reload
```

If everything was successful, the server should be up on http://localhost:8000/.

Check http://localhost:8000/docs to watch the API documentation with Swagger UI.