import pytest

from sqlalchemy.engine import Connection
from fastapi.testclient import TestClient

from app.core.config import settings
from app.models import Modality, Competition, Group, Match, Course, Team
from app.tests.conftest import SessionTesting
from app.schemas.competition import RankByEnum, SystemEnum, RoundRobin

match_data = {}

round_robin_competition_data = {
    "name": "string (round robin)",
    "started": False,
    "public": False,
    "_metadata": RoundRobin(
        rank_by=RankByEnum.WINS, system=SystemEnum.ROUND_ROBIN, play_each_other_times=1
    ).model_dump(),
}

round_robin_competition_data_v2 = {
    "name": "string (round robin)2",
    "started": False,
    "public": False,
    "_metadata": RoundRobin(
        rank_by=RankByEnum.PTS_CUSTOM,
        system=SystemEnum.ROUND_ROBIN,
        play_each_other_times=1,
        pts_win=5,
        pts_win_tiebreak=3,
        pts_tie=2,
        pts_loss_tiebreak=1,
        pts_loss=0,
        pts_ff=5,  # dont remember what these were -> i think its points for the other team if the other team forfeits
        ff_score_for=0,  # dont remember what these were -> prob points gotten by forfeit of the other team
        ff_score_agst=0,  # dont remember what these were -> .. and points lost by forfeit
    ).model_dump(),
}

round_robin_competition_data_v3 = {
    "name": "string (round robin)3",
    "started": False,
    "public": False,
    "_metadata": RoundRobin(
        rank_by=RankByEnum.SCORES,
        system=SystemEnum.ROUND_ROBIN,
        play_each_other_times=1,
    ).model_dump(),
}

round_robin_competition_data_v4 = {
    "name": "string (round robin)4",
    "started": False,
    "public": False,
    "_metadata": RoundRobin(
        rank_by=RankByEnum.GAMES_WINS,
        system=SystemEnum.ROUND_ROBIN,
        play_each_other_times=1,
    ).model_dump(),
}


def add_matches(db: SessionTesting, gl_teams_id: list, group: Group):
    match_data = [
        {
            "round": 1,
            "team1_id": gl_teams_id[0],
            "team2_id": gl_teams_id[1],
            "group_id": group.id,
            "score1": 1,
            "score2": 2,
            "winner": 2,
            "date": "2021-05-01T00:00:00",
        },
        {
            "round": 1,
            "team1_id": gl_teams_id[2],
            "team2_id": gl_teams_id[3],
            "group_id": group.id,
            "score1": 4,
            "score2": 3,
            "winner": 1,
            "date": "2021-05-01T00:00:00",
        },
        {
            "round": 2,
            "team1_id": gl_teams_id[0],
            "team2_id": gl_teams_id[2],
            "group_id": group.id,
            "score1": 2,
            "score2": 2,
            "winner": 0,
            "date": "2021-05-02T00:00:00",
        },
        {
            "round": 2,
            "team1_id": gl_teams_id[1],
            "team2_id": gl_teams_id[3],
            "group_id": group.id,
            "score1": 1,
            "score2": 2,
            "winner": 2,
            "date": "2021-05-02T00:00:00",
        },
        {
            "round": 3,
            "team1_id": gl_teams_id[0],
            "team2_id": gl_teams_id[3],
            "group_id": group.id,
            "score1": 0,
            "score2": 0,
            "winner": 0,
            "date": "2021-05-03T00:00:00",
        },
        {
            "round": 3,
            "team1_id": gl_teams_id[1],
            "team2_id": gl_teams_id[2],
            "group_id": group.id,
            "score1": 2,
            "score2": 2,
            "winner": 0,
            "date": "2021-05-03T00:00:00",
        },
    ]

    for data in match_data:
        db.add(Match(**data))
    db.commit()


def add_matches_with_games(db: SessionTesting, gl_teams_id: list, group: Group):
    match_data = [
        {
            "round": 1,
            "team1_id": gl_teams_id[0],
            "team2_id": gl_teams_id[1],
            "group_id": group.id,
            "score1": 0,
            "score2": 3,
            "games1": [10, 20, 23],
            "games2": [25, 25, 25],
            "winner": 2,
            "date": "2021-05-01T00:00:00",
        },
        {
            "round": 1,
            "team1_id": gl_teams_id[2],
            "team2_id": gl_teams_id[3],
            "group_id": group.id,
            "score1": 1,
            "score2": 3,
            "games1": [10, 25, 23, 19],
            "games2": [25, 20, 25, 25],
            "winner": 2,
            "date": "2021-05-01T00:00:00",
        },
        {
            "round": 2,
            "team1_id": gl_teams_id[0],
            "team2_id": gl_teams_id[2],
            "group_id": group.id,
            "score1": 3,
            "score2": 2,
            "games1": [25, 25, 23, 22, 15],
            "games2": [20, 20, 25, 25, 12],
            "winner": 1,
            "date": "2021-05-02T00:00:00",
        },
        {
            "round": 2,
            "team1_id": gl_teams_id[1],
            "team2_id": gl_teams_id[3],
            "group_id": group.id,
            "score1": 3,
            "score2": 1,
            "games1": [25, 25, 23, 25],
            "games2": [20, 20, 25, 22],
            "winner": 1,
            "date": "2021-05-02T00:00:00",
        },
        {
            "round": 3,
            "team1_id": gl_teams_id[0],
            "team2_id": gl_teams_id[3],
            "group_id": group.id,
            "score1": 3,
            "score2": 0,
            "games1": [25, 25, 25],
            "games2": [20, 20, 20],
            "winner": 1,
            "date": "2021-05-03T00:00:00",
        },
        {
            "round": 3,
            "team1_id": gl_teams_id[1],
            "team2_id": gl_teams_id[2],
            "group_id": group.id,
            "score1": 0,
            "score2": 3,
            "games1": [23, 21, 21],
            "games2": [25, 25, 25],
            "winner": 2,
            "date": "2021-05-03T00:00:00",
        },
    ]

    for data in match_data:
        db.add(Match(**data))
    db.commit()


@pytest.fixture(scope="module", name="db")
def setup_teams(connection: Connection):
    global gl_teams_id, gl_group_id

    transaction = connection.begin()
    db = SessionTesting(bind=connection)

    modality = Modality(
        year=0,
        type="Individual",
        frame="Misto",
        sport="Atletismo",
    )
    db.add(modality)
    db.commit()
    db.refresh(modality)

    competition = Competition(modality_id=modality.id, **round_robin_competition_data)
    db.add(competition)
    db.commit()
    db.refresh(competition)

    competition2 = Competition(
        modality_id=modality.id, **round_robin_competition_data_v2
    )
    db.add(competition2)
    db.commit()
    db.refresh(competition2)

    competition3 = Competition(
        modality_id=modality.id, **round_robin_competition_data_v3
    )
    db.add(competition3)
    db.commit()
    db.refresh(competition3)

    competition4 = Competition(
        modality_id=modality.id, **round_robin_competition_data_v4
    )
    db.add(competition4)
    db.commit()
    db.refresh(competition4)

    group = Group(competition_id=competition.id, number=1)
    db.add(group)
    db.commit()
    db.refresh(group)

    group2 = Group(competition_id=competition2.id, number=2)
    db.add(group2)
    db.commit()
    db.refresh(group2)

    group3 = Group(competition_id=competition3.id, number=3)
    db.add(group3)
    db.commit()
    db.refresh(group3)

    group4 = Group(competition_id=competition4.id, number=4)
    db.add(group4)
    db.commit()
    db.refresh(group4)

    course = Course(
        name="Eng. Informática",
        short="NEI",
    )
    db.add(course)
    db.commit()
    db.refresh(course)

    for i in range(4):
        db.add(Team(course_id=course.id, modality_id=modality.id, name=f"Team #{i+1}"))
    db.commit()

    gl_teams_id = [t.id for t in db.query(Team).all()]
    print(gl_teams_id)
    gl_group_id = group.id

    add_matches(db, gl_teams_id, group)
    add_matches(db, gl_teams_id, group2)
    add_matches(db, gl_teams_id, group3)
    add_matches_with_games(db, gl_teams_id, group4)
    yield db
    db.close()
    transaction.rollback()


def test_standing_rank_by_pts_custom(db: SessionTesting, client: TestClient) -> None:
    # Find the right group
    competitions = db.query(Competition).all()
    comp_id = None

    for comp in competitions:
        if comp._metadata["rank_by"] == RankByEnum.PTS_CUSTOM:
            comp_id = comp.id
            break

    assert comp_id is not None

    group = db.query(Group).filter(Group.competition_id == comp_id).first()

    # Get the standings

    response = client.get(
        f"{settings.API_V1_STR}/standings/{group.id}",
    )

    assert response.status_code == 200

    standings = response.json()
    assert standings["auto"] is True
    assert len(standings["table"]) == 4
    assert standings["table"][0]["team"]["name"] == "Team #1"

    assert standings["table"][0]["matches"] == 3
    assert standings["table"][0]["wins"] == 1
    assert standings["table"][0]["losses"] == 0
    assert standings["table"][0]["ties"] == 2
    assert standings["table"][0]["ff"] == 0
    assert standings["table"][0]["score_for"] == 8
    assert standings["table"][0]["score_agst"] == 7
    assert standings["table"][0]["goal_difference"] == 1
    assert standings["table"][0]["pts"] == 9

    assert (
        standings["table"][0]["pts"]
        >= standings["table"][1]["pts"]
        >= standings["table"][2]["pts"]
        >= standings["table"][3]["pts"]
    )


def test_standing_rank_by_wins(db: SessionTesting, client: TestClient) -> None:
    # Find the right group
    competitions = db.query(Competition).all()
    comp_id = None

    for comp in competitions:
        if comp._metadata["rank_by"] == RankByEnum.WINS:
            comp_id = comp.id
            break

    assert comp_id is not None

    group = db.query(Group).filter(Group.competition_id == comp_id).first()

    # Get the standings
    response = client.get(
        f"{settings.API_V1_STR}/standings/{group.id}",
    )

    assert response.status_code == 200

    # gl_teams_id[0] == 2
    # gl_teams_id[1] == 4
    # gl_teams_id[2] == 1
    # gl_teams_id[3] == 3

    standings = response.json()
    assert standings["auto"] is True
    assert len(standings["table"]) == 4
    assert standings["table"][3]["team"]["name"] == "Team #3"
    assert standings["table"][3]["matches"] == 3
    assert standings["table"][3]["wins"] == 0
    assert standings["table"][3]["losses"] == 1
    assert standings["table"][3]["ties"] == 2
    assert standings["table"][3]["ff"] == 0
    assert standings["table"][3]["score_for"] == 3
    assert standings["table"][3]["score_agst"] == 4
    assert standings["table"][3]["goal_difference"] == -1
    assert standings["table"][3]["pts"] == 0
    assert standings["table"][3]["match_history"] == [-1, 0, 0]

    for i in range(4):
        assert standings["table"][i]["pts"] == standings["table"][i]["wins"]
    assert (
        standings["table"][0]["pts"]
        >= standings["table"][1]["pts"]
        >= standings["table"][2]["pts"]
        >= standings["table"][3]["pts"]
    )


def test_standing_rank_by_scores(db: SessionTesting, client: TestClient) -> None:
    # Find the right group
    competitions = db.query(Competition).all()
    comp_id = None

    for comp in competitions:
        if comp._metadata["rank_by"] == RankByEnum.SCORES:
            comp_id = comp.id
            break

    assert comp_id is not None

    group = db.query(Group).filter(Group.competition_id == comp_id).first()

    # Get the standings
    response = client.get(
        f"{settings.API_V1_STR}/standings/{group.id}",
    )

    assert response.status_code == 200

    # gl_teams_id[0] == 2
    # gl_teams_id[1] == 4
    # gl_teams_id[2] == 1
    # gl_teams_id[3] == 3

    standings = response.json()
    assert standings["auto"] is True
    assert len(standings["table"]) == 4
    assert standings["table"][0]["team"]["name"] == "Team #1"
    assert standings["table"][0]["pts"] == 8
    assert standings["table"][1]["team"]["name"] == "Team #2"
    assert standings["table"][1]["pts"] == 5
    assert standings["table"][2]["team"]["name"] == "Team #4"
    assert standings["table"][2]["pts"] == 5
    assert standings["table"][3]["team"]["name"] == "Team #3"
    assert standings["table"][3]["pts"] == 3

    for i in range(4):
        assert standings["table"][i]["pts"] == standings["table"][i]["score_for"]

    assert (
        standings["table"][0]["pts"]
        >= standings["table"][1]["pts"]
        >= standings["table"][2]["pts"]
        >= standings["table"][3]["pts"]
    )


def test_standing_rank_by_games_wins(db: SessionTesting, client: TestClient) -> None:
    # Find the right group
    competitions = db.query(Competition).all()
    comp_id = None

    for comp in competitions:
        if comp._metadata["rank_by"] == RankByEnum.GAMES_WINS:
            comp_id = comp.id
            break

    assert comp_id is not None

    group = db.query(Group).filter(Group.competition_id == comp_id).first()

    # Get the standings
    response = client.get(
        f"{settings.API_V1_STR}/standings/{group.id}",
    )

    assert response.status_code == 200

    # gl_teams_id[0] == 2
    # gl_teams_id[1] == 4
    # gl_teams_id[2] == 1
    # gl_teams_id[3] == 3

    standings = response.json()
    print(standings)
    assert standings["auto"] is True
    assert len(standings["table"]) == 4
    assert standings["table"][0]["team"]["name"] == "Team #1"
    assert standings["table"][1]["team"]["name"] == "Team #3"
    assert standings["table"][2]["team"]["name"] == "Team #4"
    assert standings["table"][3]["team"]["name"] == "Team #2"
    assert standings["table"][0]["pts"] == 6
    assert standings["table"][1]["pts"] == 6
    assert standings["table"][2]["pts"] == 6
    assert standings["table"][3]["pts"] == 4

    assert (
        standings["table"][0]["pts"]
        == standings["table"][1]["pts"]
        == standings["table"][2]["pts"]
        > standings["table"][3]["pts"]
    )
