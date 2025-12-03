FROM python:3.10-slim as requirements-stage

ENV PYTHONUNBUFFERED 1

WORKDIR /api_family

RUN apt-get update && apt-get -y install libpq-dev gcc

RUN pip install --upgrade pip &&\
    pip install --no-cache-dir --upgrade poetry

COPY poetry.lock pyproject.toml ./

RUN poetry install --no-root

COPY . .

RUN poetry install --no-root

EXPOSE 8002
CMD poetry run uvicorn app.main:app --host 0.0.0.0 --port 8002 --reload
