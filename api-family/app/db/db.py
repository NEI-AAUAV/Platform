from typing import Generator

from pymongo import MongoClient

from app.core.config import settings


client = MongoClient(settings.DATABASE_URL)
print('Connected to MongoDB...')

db = client[settings.MONGO_DB]

Counter = db.counters
User = db.users
Patch = db.patches
Course = db.courses
Organization = db.organizations


User.create_index("refId", unique=True)
User.create_index("academic.lastMatriculationYear")
User.create_index("faina.firstTrajadoYear")

Patch.create_index("patcherId")


def get_db() -> Generator:
    # FIXME: is this necessary?
    try:
        yield db
    finally:
        client.close()
