from typing import Generator

from pymongo import MongoClient

from app.core.config import settings


client = MongoClient(settings.MONGO_URI)
print('Connected to MongoDB...')

db = client[settings.MONGO_DB]

# Collections
Counter = db.counters
User = db.users
Patch = db.patches
Course = db.courses
Organization = db.organizations

# New normalized collections
Role = db.roles
UserRole = db.user_roles


# Indexes for User
User.create_index("ref_id", unique=True, sparse=True)
User.create_index("academic.lastMatriculationYear")
User.create_index("faina.firstTrajadoYear")
User.create_index("faina.patrao_id")

# Indexes for Patch
Patch.create_index("patcherId")

# Indexes for UserRole (association table)
UserRole.create_index("user_id")
UserRole.create_index("role_id")
UserRole.create_index([("user_id", 1), ("role_id", 1), ("year", 1)], unique=True)


def get_db() -> Generator:
    # FIXME: is this necessary?
    try:
        yield db
    finally:
        client.close()

