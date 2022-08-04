from sqlalchemy.schema import CreateSchema, DropSchema
from sqlalchemy import event
from datetime import datetime

from app.core.config import settings
from .base import Base, TacaUATeam, TacaUAGame, Users, Faina, FainaRoles, FainaMember, Seniors, SeniorsStudents, Team, TeamColaborators, TeamRoles
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
'''
USERS = [
    {
        "name" : "Eduardo Rocha Fernandes"
    },
    {
        "name" : "Pedro Miguel Pina Monteiro"
    }
]'''

FAINA = [
    {
        "mandato" : 1,
        "imagem" : "imagem_url",
        "anoLetivo": "2020/2021"
    },
    {
        "mandato" : 2,
        "imagem" : "imagem_url",
        "anoLetivo": "2021/2022"
    }
]

FAINA_ROLES = [
    {
        "name" : "Mestre",
        "weight" : 2
    }
]

FAINA_MEMBER = [
    {
        "year_id" : 1,
        "role_id" : 1
    }
]

SENIORS = [
    {
        "year" : 2022,
        "course" : "LEI",
        "image" : "image_url"
    }
]

SENIORS_STUDENTS = [
    {
        "user_id" : 2,
        "quote" : "Sou alto morcao",
        "image" : "image_url"
    }
]

TEAM = [
    {
        "header" : "Vim para trabalhar",
        "mandato" : 2022,
        "user_id" : 2,
        "role_id" : 1
    }
]

TEAM_ROLES = [
    {
        "name" : "Colaborador",
        "weight" : 5  
    },
    {
        "name" : "Presidente",
        "weight" : 1
    }
]

TEAM_COLABORATORS = [
    {
        "colaborator" : 2,
        "mandato" : 2022
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
'''
@event.listens_for(Users.__table__, "after_create")
def insert_users(target, conn, **kwargs):
    for vals in USERS:
        conn.execute(target.insert().values(**vals))
'''

@event.listens_for(Faina.__table__, "after_create")
def insert_users(target, conn, **kwargs):
    for vals in FAINA:
        conn.execute(target.insert().values(**vals))

@event.listens_for(FainaRoles.__table__, "after_create")
def insert_users(target, conn, **kwargs):
    for vals in FAINA_ROLES:
        conn.execute(target.insert().values(**vals))

@event.listens_for(FainaMember.__table__, "after_create")
def insert_users(target, conn, **kwargs):
    for vals in FAINA_MEMBER:
        conn.execute(target.insert().values(**vals))

@event.listens_for(Seniors.__table__, "after_create")
def insert_users(target, conn, **kwargs):
    for vals in SENIORS:
        conn.execute(target.insert().values(**vals))

@event.listens_for(SeniorsStudents.__table__, "after_create")
def insert_users(target, conn, **kwargs):
    for vals in SENIORS_STUDENTS:
        conn.execute(target.insert().values(**vals))

@event.listens_for(TeamRoles.__table__, "after_create")
def insert_users(target, conn, **kwargs):
    for vals in TEAM_ROLES:
        conn.execute(target.insert().values(**vals))

@event.listens_for(Team.__table__, "after_create")
def insert_users(target, conn, **kwargs):
    for vals in TEAM:
        conn.execute(target.insert().values(**vals))

@event.listens_for(TeamColaborators.__table__, "after_create")
def insert_users(target, conn, **kwargs):
    for vals in TEAM_COLABORATORS:
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
