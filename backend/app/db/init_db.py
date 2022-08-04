from sqlalchemy.schema import CreateSchema, DropSchema
from sqlalchemy import event
from datetime import datetime

from app.core.config import settings
from app.models.notes import Notes
from app.models.notes_schoolyear import NotesSchoolYear
from app.models.notes_subject import NotesSubject
from app.models.notes_teachers import NotesTeachers
from app.models.notes_thanks import NotesThanks
from app.models.notes_types import NotesTypes
from app.models.users import Users
from .base import Base, TacaUATeam, TacaUAGame
from .session import engine

USERS = [
    {
        "id": 1,
        "name": 'Pedro Monteiro',
        "fullname": 'Pedro Miguel Afonso de Pina Monteiro',
        "uu_email": 'pmapm@ua.pt',
        "uu_yupi": 'x1x1',
        "curriculo": 'pedro_cv',
        "linkedin": 'pedro_linkedin',
        "git": 'pedro_git',
        "permission": 'COLABORATOR',
        "created_at": datetime(2022, 8, 4)
    },
    {
        "id": 2,
        "name": "Eduardo",
        "fullname": "Eduardo Rocha Fernandes",
        "uu_email": "eduardofernandes@ua.pt",
        "uu_yupi": 'x2x2',
        "curriculo": 'eduardo_cv',
        "linkedin": 'eduardo_linkedin',
        "git": 'eduardo_git',
        "permission": 'COLABORATOR',
        "created_at": datetime(2022, 8, 4)
    }
]

NOTES_SCHOOL_YEAR = [
    {
        "id": 1,
        "yearBegin": 2020,
        "yearEnd": 2023
    }
]

NOTES_SUBJECT = [
    {
        "paco_code": 1,
        "name": "random name",
        "year": 2021,
        "semester": 2,
        "short": "short",
        "discontinued": 1,
        "optional": 1
    }
]

NOTES_TEACHERS = [
    {
        'id': 1,
        'name': 'DG',
        'personalPage': 'personalpage_dg'
    }
]


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

NOTES_THANKS = [
    {
        'id': 1,
        'author_id': 1,
        "notesPersonalPage": "very much thanks"
    }
]

NOTES_TYPES = [
    {
        'id': 1,
        "name": "name note type",
        "download_caption": "download_caption",
        "icon_display": 'display',
        "icon_download": 'download',
        "external": 1
    }
]

NOTES = [
    {
        'id': 1,
        'name': 'note name',
        'location': 'Aveiro',
        "subject_id": 1,
        "author_id": 1,
        "school_year_id": 1,
        "teacher_id": 1,
        "summary": 1,
        "tests": 1,
        "bibliography": 1,
        "slides": 1,
        "exercises": 0,
        "projects": 0,
        "notebook": 1,
        "content": "content text bla bla bla bla bla",
        "createdAt": datetime(2022, 8, 4),
        "type_id": 1,
        "size": 1
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


@event.listens_for(Users.__table__, "after_create")
def insert_users(target, conn, **kwargs):
    for vals in USERS:
        conn.execute(target.insert().values(**vals))


@event.listens_for(NotesSchoolYear.__table__, "after_create")
def insert_notes_school_year(target, conn, **kwargs):
    for vals in NOTES_SCHOOL_YEAR:
        conn.execute(target.insert().values(**vals))


@event.listens_for(NotesSubject.__table__, "after_create")
def insert_notes_subject(target, conn, **kwargs):
    for vals in NOTES_SUBJECT:
        conn.execute(target.insert().values(**vals))

@event.listens_for(NotesTeachers.__table__, "after_create")
def insert_notes_teachers(target, conn, **kwargs):
    for vals in NOTES_TEACHERS:
        conn.execute(target.insert().values(**vals))

@event.listens_for(NotesThanks.__table__, "after_create")
def insert_notes_thanks(target, conn, **kwargs):
    for vals in NOTES_THANKS:
        conn.execute(target.insert().values(**vals))

@event.listens_for(NotesTypes.__table__, "after_create")
def insert_notes_types(target, conn, **kwargs):
    for vals in NOTES_TYPES:
        conn.execute(target.insert().values(**vals))
        
@event.listens_for(Notes.__table__, "after_create")
def insert_notes(target, conn, **kwargs):
    for vals in NOTES:
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
