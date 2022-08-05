from sqlalchemy.schema import CreateSchema, DropSchema
from sqlalchemy import event
from datetime import date, datetime

from app.core.config import settings
from .base import Base, TacaUATeam, TacaUAGame, History, Rgm, Merchandisings, Partners
from .session import engine


TACAUA_TEAMS = [
    {
        "name": "Eng. de Computadores e Informática",
        "image_url": "https://nei.web.ua.pt/nei.png",
    },
    {
        "name": "Eng. Informática",
        "image_url": "https://nei.web.ua.pt/nei.png",
    },
]

TACAUA_GAMES = [
    {
        "team1_id": 1,
        "team2_id": 2,
        "goals1": 0,
        "goals2": 10,
        "date": datetime(2022, 6, 19)
    },
    {
        "team1_id": 2,
        "team2_id": 1,
        "goals1": 11,
        "goals2": 1,
        "date": datetime(2022, 7, 19)
    },
]

HISTORY = [
    {
        "moment": date(2022,1,2),
        "title": "TituloHistory1",
        "body": "Texto muito interessante",
        "image": "https://nei.web.ua.pt/nei.png"
    },
    {
        "moment": date(1993,1,2),
        "title": "TituloHistory2",
        "body": "Texto muito pouco interessante",
        "image": "https://nei.web.ua.pt/nei.png"
    },
]

RGM = [
    {
        "id": 1,
        "categoria": "Cat123456",
        "mandato": 4,
        "file": "https://nei.web.ua.pt/nei.png"
    }
]

MERCHANDISINGS = [
    {
        "id": 1,
        "name": "Cat123456",
        "image": "https://nei.web.ua.pt/nei.png",
        "price": 4,
        "number_of_items": 5
    }
]

PARTNERS = [
    {
        "id": 1,
        "header": "Cat123456",
        "company": "Cat123456",
        "description": "Cat123456",
        "content": "Cat123456",
        "link": "https://nei.web.ua.pt/nei.png",
        "bannerUrl": "https://nei.web.ua.pt/nei.png",
        "bannerImage": "https://nei.web.ua.pt/nei.png", 
        "bannerUntil": datetime(2022, 7, 19)
    }
]

@event.listens_for(TacaUATeam.__table__, "after_create")
def insert_tacaua_teams(target, conn, **kwargs):
    for vals in TACAUA_TEAMS:
        conn.execute(target.insert().values(**vals))


@event.listens_for(TacaUAGame.__table__, "after_create")
def insert_tacaua_games(target, conn, **kwargs):
    for vals in TACAUA_GAMES:
        conn.execute(target.insert().values(**vals))


@event.listens_for(History.__table__, "after_create")
def insert_history(target, conn, **kwargs):
    for vals in HISTORY:
        conn.execute(target.insert().values(**vals))

@event.listens_for(Rgm.__table__, "after_create")
def insert_rgm(target, conn, **kwargs):
    for vals in RGM:
        conn.execute(target.insert().values(**vals))

@event.listens_for(Merchandisings.__table__, "after_create")
def insert_merchandisings(target, conn, **kwargs):
    for vals in MERCHANDISINGS:
        conn.execute(target.insert().values(**vals))

@event.listens_for(Partners.__table__, "after_create")
def insert_partners(target, conn, **kwargs):
    for vals in PARTNERS:
        conn.execute(target.insert().values(**vals))


# make sure all SQL Alchemy models are imported (app.db.base) before initializing DB
# otherwise, SQL Alchemy might fail to initialize relationships properly
# for more details: https://github.com/tiangolo/full-stack-fastapi-postgresql/issues/28


def init_db() -> None:
    # Tables should be created with Alembic migrations
    # But if you don't want to use migrations, create
    # the tables with Base.metadata.create_all(bind=engine)

    if not engine.dialect.has_schema(engine, schema=settings.SCHEMA_NAME):
        event.listen(Base.metadata, "before_create", CreateSchema(settings.SCHEMA_NAME))

    Base.metadata.reflect(bind=engine, schema=settings.SCHEMA_NAME)
    Base.metadata.create_all(bind=engine, checkfirst=True)
