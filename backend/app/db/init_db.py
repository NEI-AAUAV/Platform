from requests import Session

from app import crud, schemas
from datetime import datetime


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


# make sure all SQL Alchemy models are imported (app.db.base) before initializing DB
# otherwise, SQL Alchemy might fail to initialize relationships properly
# for more details: https://github.com/tiangolo/full-stack-fastapi-postgresql/issues/28


def init_db(db: Session) -> None:
    # Tables should be created with Alembic migrations
    # But if you don't want to use migrations, create
    # the tables un-commenting the next line
    # Base.metadata.create_all(bind=engine)

    loaded = crud.tacaua_game.get(db=db, id=1)

    if not loaded:
        for vals in TACAUA_TEAMS:
            team_in = schemas.TacaUATeamCreate(**vals)
            crud.tacaua_team.create(db=db, obj_in=team_in)

        for vals in TACAUA_GAMES:
            game_in = schemas.TacaUAGameCreate(**vals)
            crud.tacaua_game.create(db=db, obj_in=game_in)
