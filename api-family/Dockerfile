FROM python:3.9-slim as requirements-stage

ENV PYTHONUNBUFFERED 1

WORKDIR /api_family

RUN apt-get update && apt-get -y install libpq-dev gcc

RUN pip install --upgrade pip \
    pip install --no-cache-dir --upgrade poetry

COPY . .

RUN poetry install

EXPOSE 8002
CMD poetry run uvicorn app.main:app --host 0.0.0.0 --port 8002 --reload
