from sqlalchemy.schema import CreateSchema, DropSchema
from sqlalchemy.sql import text
from sqlalchemy import event

from app.core.config import settings
from .base import Base
from .session import engine



# make sure all SQL Alchemy models are imported (app.db.base) before initializing DB
# otherwise, SQL Alchemy might fail to initialize relationships properly
# for more details: https://github.com/tiangolo/full-stack-fastapi-postgresql/issues/28


def init_db() -> None:
    # Tables should be created with Alembic migrations
    # But if you don't want to use migrations, create
    # the tables with Base.metadata.create_all(bind=engine)

    with engine.connect() as conn:
        if not engine.dialect.has_schema(conn, schema=settings.SCHEMA_NAME):
            event.listen(Base.metadata, "before_create", CreateSchema(settings.SCHEMA_NAME), insert=True)

            Base.metadata.reflect(bind=engine, schema=settings.SCHEMA_NAME)
            Base.metadata.create_all(bind=engine, checkfirst=True)

            # Populate Database
            file = open("./app/db/backup-0001.sql")
            stmts = text(file.read())
            conn.execute(stmts)
            conn.commit()
