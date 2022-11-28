import pytest

from sqlalchemy.engine import Connection

import app.crud as crud
from app.models.team import Team
from app.tests.conftest import SessionTesting


teams = [
    {
        "name": "Tripa",
        "question_scores": [False, False, False],  # [0, 0, 0]
        "time_scores": [360, 15, 0],  # [5, 10, 0]
        "times": ["2022-11-30T19:15:00", "2022-11-30T19:30:00", "2022-11-30T19:33:00"],
        "pukes": [0, 0, 1],  # [0, 0, 0]
        "skips": [0, 1, 0],  # [0, 0, 0]
        "total": 0,  # 15
        "card1": 0,
        "card2": 2,
        "card3": 3,
        "classification": -1, # 2
    },
    {
        "name": "Arroz",
        "question_scores": [True, False, False],  # [8, 0, 6]
        "time_scores": [360, 15, 0],  # [5, 10, 0]
        "times": ["2022-11-30T19:26:00", "2022-11-30T19:56:00", "2022-11-30T20:10:00"],
        "pukes": [0, 0, 0],  # [0, 0, 0]
        "skips": [0, 2, 1],  # [0, -8, -8]
        "total": 0,  # 13
        "card1": 3,
        "card2": 2,
        "card3": 0,
        "classification": -1, # 1
    },
    {
        "name": "Doce",
        "question_scores": [True, True],  # [8, 8]
        "time_scores": [0, 20],  # [0, 7.5]
        "times": ["2022-11-30T19:40:00", "2022-11-30T20:00:00"],
        "pukes": [0, 1],  # [0, -20]
        "skips": [0, 0],  # [0, 0]
        "total": 0,     # 3.5
        "card1": -1,
        "card2": 0,
        "card3": 0,
        "classification": -1, # 3
    },
    {
        "name": "Ovos",
        "question_scores": [False], # [6]
        "time_scores": [180],   # [10]
        "times": ["2022-11-30T20:05:00"],
        "pukes": [2],   # [-20]
        "skips": [1],   # [-8]
        "total": 0,  # -12
        "card1": 1,
        "card2": -1,
        "card3": 1,
        "classification": -1, # 5
    },
    {
        "name": "Moles",
        "question_scores": [],
        "time_scores": [],
        "times": [],
        "pukes": [],
        "skips": [],
        "total": 0,  # 0
        "card1": -1,
        "card2": -1,
        "card3": -1,
        "classification": -1, # 4
    },
]


@pytest.fixture(autouse=True)
def setup_database(db: SessionTesting):
    for team in teams:
        db.add(Team(**team))
    db.commit()


def test_update_classification(db: SessionTesting):
    crud.team.update_classification(db=db)
    teams = crud.team.get_multi(db=db)

    results = {
        "Tripa": (1, 15),
        "Arroz": (2, 13),
        "Doce": (3, 3.5),
        "Ovos": (5, -12),
        "Moles": (4, 0)
    }
    for team in teams:
        assert team.classification == results[team.name][0]
        assert team.total == int(results[team.name][1])
