import pytest
from typing import Any
from datetime import datetime

from fastapi.testclient import TestClient

from app.core.config import settings
from app.models import TacaUAGame, TacaUATeam
from app.tests.conftest import SessionTesting


tacaua_teams = [
    {
        "id": 0,
        "name": "Eng. de Computadores e Informática",
        "image_url": "https://nei.web.ua.pt/nei.png",
    },
    {
        "id": 1,
        "name": "Eng. Informática",
        "image_url": "https://nei.web.ua.pt/nei.png",
    },
]

game = {
    "team1_id": 0,
    "team2_id": 1,
    "goals1": 0,
    "goals2": 10,
    "date": datetime.now().isoformat()
}
past_game = {
    **game,
    "date": datetime(2000, 1, 1).isoformat()
}
future_game = {
    **game,
    "date": datetime(3000, 1, 1).isoformat()
}


@pytest.fixture(autouse=True)
def setup_database(db: SessionTesting):
    """Setup the database before each test in this module."""

    for team in tacaua_teams:
        db.add(TacaUATeam(**team))
    db.add(TacaUAGame(id=0, **game))
    db.commit()


def test_get_prev_tacaua_games(client: TestClient) -> None:
    r = client.get(f"{settings.API_V1_STR}/tacaua/games/")
    data = r.json()
    assert r.status_code == 200
    assert len(data) == 1
    assert data[0].items() >= game.items()
    assert "id" in data[0]


def test_get_prev_tacaua_games_with_10_past_games(
        db: SessionTesting, client: TestClient) -> None:
    for _ in range(10):
        db.add(TacaUAGame(**past_game))
    db.commit()

    r = client.get(f"{settings.API_V1_STR}/tacaua/games/")
    data = r.json()
    assert r.status_code == 200
    assert len(data) == 5


def test_get_prev_tacaua_games_with_10_future_games(
    db: SessionTesting, client: TestClient) -> None:
    for _ in range(10):
        db.add(TacaUAGame(**future_game))
    db.commit()

    r = client.get(f"{settings.API_V1_STR}/tacaua/games/")
    data = r.json()
    assert r.status_code == 200
    assert len(data) == 1
    assert data[0]["date"] != future_game["date"]


def test_create_tacaua_game(client: TestClient) -> None:
    r = client.post(f"{settings.API_V1_STR}/tacaua/games/", json=game)
    data = r.json()
    assert r.status_code == 201
    assert data.items() >= game.items()
    assert "id" in data


def test_create_tacaua_game_with_missing_field(client: TestClient) -> None:
    bad_game = dict(game)
    del bad_game["team1_id"]
    r = client.post(f"{settings.API_V1_STR}/tacaua/games/", json=bad_game)
    data = r.json()
    assert r.status_code == 422
    assert data["detail"][0]["loc"] == ['body', 'team1_id']
    assert data["detail"][0]["msg"] == "field required"


def test_update_tacaua_game(client: TestClient) -> None:
    game_id = 0
    r = client.put(f"{settings.API_V1_STR}/tacaua/games/{game_id}", json=game)
    data = r.json()
    assert r.status_code == 200
    assert data.items() >= game.items()
    assert data["id"] == game_id


def test_update_inexistent_tacaua_game(client: TestClient) -> None:
    game_id = 99
    r = client.put(f"{settings.API_V1_STR}/tacaua/games/{game_id}", json=game)
    data = r.json()
    assert r.status_code == 404
    assert data["detail"] == "Game Not Found"
