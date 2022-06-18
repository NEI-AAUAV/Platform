from sqlalchemy import event
from sqlalchemy.orm import Session

from app.db import Base, TacaUAGame
from .session import engine
from app.core.config import settings


TACAUA_GAMES = [
    {
        "name": 1,
        "image": "Chicken Vesuvio",
    },
    {
        "name": 1,
        "image": "Chicken Vesuvio",
    },
]


# make sure all SQL Alchemy models are imported (app.db.base) before initializing DB
# otherwise, SQL Alchemy might fail to initialize relationships properly
# for more details: https://github.com/tiangolo/full-stack-fastapi-postgresql/issues/28


@event.listens_for(TacaUAGame.__table__, "after_create")
def insert_tags(target, conn, **kwargs):
    for vals in TACAUA_GAMES:
        conn.execute(target.insert().values(vals))


def init_db(db: Session) -> None:
    # Tables should be created with Alembic migrations
    # But if you don't want to use migrations, create
    # the tables un-commenting the next line
    # Base.metadata.create_all(bind=engine)

    # Check Database Schema Creation
    if not engine.dialect.has_schema(engine, schema=settings.SCHEMA_NAME):
        event.listen(Base.metadata, "before_create", CreateSchema(settings.SCHEMA_NAME))

    Base.metadata.reflect(bind=engine, schema=settings.SCHEMA_NAME)
    Base.metadata.create_all(engine, checkfirst=True)

