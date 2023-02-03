from sqlalchemy.schema import CreateSchema, DropSchema
from sqlalchemy import event
from datetime import date, datetime

from app.core.config import settings
from .base import Base
from .session import engine

"""
USERS = [
    {
        "name": 'Pedro Monteiro',
        "full_name": 'Pedro Miguel Afonso de Pina Monteiro',
        "uu_email": 'pmapm@ua.pt',
        "uu_iupi": 'x1x1',
        "curriculo": 'pedro_cv',
        "linkedin": 'pedro_linkedin',
        "git": 'pedro_git',
        "permission": 'COLABORATOR',
        "created_at": datetime(2022, 8, 4)
    },
    {
        "name": "Eduardo",
        "full_name": "Eduardo Rocha Fernandes",
        "uu_email": "eduardofernandes@ua.pt",
        "uu_iupi": 'x2x2',
        "curriculo": 'eduardo_cv',
        "linkedin": 'eduardo_linkedin',
        "git": 'eduardo_git',
        "permission": 'COLABORATOR',
        "created_at": datetime(2022, 8, 4)
    },
        {
        "name": 'Name Test',
        "full_name": 'Full Name Test',
        "uu_email": 'test@ua.pt',
        "uu_iupi": 'x1x1',
        "curriculo": '',
        "linkedin": '',
        "git": '',
        "permission": 'COLABORATOR',
        "created_at": datetime(2022, 8, 8)
    },
]

NOTES_SCHOOL_YEAR = [
    {
        "year_begin": 2020,
        "year_end": 2023
    },
        {
        "year_begin": 2020,
        "year_end": 2023
    }
]

NOTES_SUBJECT = [
        {
        "name": "random name 0",
        "year": 2021,
        "semester": 2,
        "short": "short",
        "discontinued": 1,
        "optional": 1
    },
    {
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
        'name': 'DG',
        'personal_page': 'personalpage_dg'
    },
        {
        'name': 'TOS',
        'personal_page': 'personalpage_tos'
    }
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
        "image" : "imagem_url",
        "year": "2020/2021"
    },
    {
        "image" : "imagem_url",
        "year": "2021/2022"
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
        "member_id" : 1,
        "mandate_id" : 1,
        "role_id" : 1
    }
]

SENIORS = [
    {
        "year" : 2022,
        "course" : "LEI",
        "image" : "image_url"
    },
    {
        "year" : 2022,
        "course" : "MEI",
        "image" : "image_url"
    }
]

SENIORS_STUDENTS = [
    {
        "year_id": 2022,
        "course": "LEI",
        "user_id" : 2,
        "quote" : "Sou mesmo fixe",
        "image" : "image_url"
    },
    {
        "year_id": 2022,
        "course": "MEI",
        "user_id" : 1,
        "quote" : "Olá",
        "image" : "image_url2"
    }
]

TEAM = [
    {
        "header" : "Vim para trabalhar",
        "mandate" : 2022,
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
        "mandate" : 2022
    }
]

NOTES_THANKS = [
        {
        'author_id': 1,
        "note_personal_page": "very much thanks"
    },
    {
        'author_id': 1,
        "note_personal_page": "very much thanks"
    }
]

NOTES_TYPES = [
        {
        "name": "name note type 0",
        "download_caption": "download_caption",
        "icon_display": 'display',
        "icon_download": 'download',
        "external": 1
    },
    {
        "name": "name note type",
        "download_caption": "download_caption",
        "icon_display": 'display',
        "icon_download": 'download',
        "external": 1
    }
]

NOTES = [
    {
        'name': 'note name 0',
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
        "created_at": datetime(2022, 8, 4),
        "type_id": 1,
        "size": 1,
        "category": "xxxxxx"
    },
    {
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
        "created_at": datetime(2022, 8, 4),
        "type_id": 1,
        "size": 1,
        "category": "xxxxxx"
    },
        {
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
        "created_at": datetime(2022, 8, 4),
        "type_id": 1,
        "size": 1,
        "category": "aaaaaaaa"
    }
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
        "category": "Cat123456",
        "mandate": 4,
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
        "banner_url": "https://nei.web.ua.pt/nei.png",
        "bannerImage": "https://nei.web.ua.pt/nei.png", 
        "banner_until": datetime(2022, 7, 19)
    }
]

VIDEO_TAG = [
    {
        "id": 1,
        "name": "test",
        "color": "orange"
    },
    {
        "id": 2,
        "name": "test",
        "color": "orange"
    }]

VIDEO = [
    {
        "tag_id": [1,2],
        "youtube_id": "tjmk0C64eJg",
        "title": "test1111",
        "subtitle": "tetst",
        "image": "http://www.example.com",
        "created": datetime(2022, 6, 19),
        "playlist": 2
    },
    {
        "tag_id": [1],
        "youtube_id": "ejGxijpPpsE",
        "title": "test2222",
        "subtitle": "",
        "image": "",
        "created": datetime(2002, 6, 10)
    }] """
        
# make sure all SQL Alchemy models are imported (app.db.base) before initializing DB
# otherwise, SQL Alchemy might fail to initialize relationships properly
# for more details: https://github.com/tiangolo/full-stack-fastapi-postgresql/issues/28


def init_db() -> None:
    # Tables should be created with Alembic migrations
    # But if you don't want to use migrations, create
    # the tables with Base.metadata.create_all(bind=engine)

    if not engine.dialect.has_schema(engine, schema=settings.SCHEMA_NAME):
        event.listen(Base.metadata, "before_create", CreateSchema(settings.SCHEMA_NAME), insert=True)

    Base.metadata.reflect(bind=engine, schema=settings.SCHEMA_NAME)
    Base.metadata.create_all(bind=engine, checkfirst=True)

