from typing import Any
from fastapi.testclient import TestClient

from app.core.config import settings

from datetime import datetime


def test_get_prev_tacaua_games(client: TestClient) -> Any:
    """
    Return the previous 5 games.
    """
    r = client.get(f"{settings.API_V1_STR}/tacaua/games/")
    tokens = r.json()
    assert r.status_code == 200
    assert tokens["access_token"]


def test_create_tacaua_game(client: TestClient) -> dict:
    """
    Create a new tacaUA game in the database.
    """
    game_data = {
        "team1_id": 1,
        "team2_id": 2,
        "goals1": 0,
        "goals2": 10,
        "date": datetime(2022, 6, 19)
    }
    r = client.post(f"{settings.API_V1_STR}/tacaua/games/", data=game_data)
    assert r.status_code == 201


# def test_update_tacaua_game(client: TestClient) -> dict:
#     """
#     Update a tacaUA game in the database.
#     """
#     game_data = {
#         "team1_id": 1,
#         "team2_id": 2,
#         "goals1": 0,
#         "goals2": 10,
#         "date": datetime(2022, 6, 19)
#     }
#     r = client.put(f"{settings.API_V1_STR}/tacaua/games/", data=game_data)
#     assert r.status_code == 201
