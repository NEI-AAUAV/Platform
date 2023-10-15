import pytest
import random
from typing import Any, List

from sqlalchemy.engine import Connection

import app.crud as crud
from app.crud.group.single_elimination import get_single_elimination_matches_per_round
from app.models import Modality, Competition, Group, Match, Course, Team
from app.tests.conftest import SessionTesting


gl_group_id = None
gl_teams_id = None

competition_data = {
    "name": "string",
    "started": False,
    "public": False,
    "_metadata": {
        "rank_by": "Vitórias",
        "system": "Eliminação Direta",
        "third_place_match": False,
    },
}


def setup_competition(
    modality: Modality, data: Any, db: SessionTesting
) -> tuple[List[int], int]:
    competition = Competition(modality_id=modality.id, **data)
    db.add(competition)
    db.commit()
    db.refresh(competition)

    group = Group(competition_id=competition.id, number=1)
    db.add(group)
    db.commit()
    db.refresh(group)

    course = Course(
        name="Eng. Informática",
        short="NEI",
    )
    db.add(course)
    db.commit()
    db.refresh(course)

    teams = []

    for i in range(10):
        team = Team(course_id=course.id, modality_id=modality.id, name=f"Team #{i}")
        db.add(team)
        teams.append(team)
    db.commit()

    teams_ids = [t.id for t in teams]

    return (teams_ids, group.id)


@pytest.fixture(scope="module", name="db")
def setup_teams(connection: Connection):
    global gl_teams_id, gl_group_id, gl_rr_teams_id, gl_rr_group_id

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

    (teams_ids, group_id) = setup_competition(modality, competition_data, db)
    gl_teams_id = teams_ids
    gl_group_id = group_id

    yield db
    db.close()
    transaction.rollback()


@pytest.mark.parametrize(
    "input,expected",
    [
        (9, [1, 4, 2, 1]),
        (8, [4, 2, 1]),
        (7, [3, 2, 1]),
        (6, [2, 2, 1]),
        (5, [1, 2, 1]),
        (4, [2, 1]),
        (3, [1, 1]),
        (2, [1]),
        (1, []),
        (0, []),
        # 5 teams -> 3 rounds -> 1 quarter-final match, 2 semi-final matches, 1 final match
    ],
)
def test_get_single_elimination_matches_per_round(input, expected):
    assert get_single_elimination_matches_per_round(input) == expected


@pytest.mark.parametrize("execution_number", range(2))
@pytest.mark.parametrize(
    "input,expected",
    sorted(
        [
            (10, [(2, 0, 0), (3, 0, 1), (0, 0, 2), (0, 0, 1)]),
            (9, [(1, 0, 0), (3, 1, 0), (0, 0, 2), (0, 0, 1)]),
            (8, [(4, 0, 0), (0, 0, 2), (0, 0, 1)]),
            (7, [(3, 0, 0), (0, 1, 1), (0, 0, 1)]),
            (6, [(2, 0, 0), (1, 0, 1), (0, 0, 1)]),
            (5, [(1, 0, 0), (1, 1, 0), (0, 0, 1)]),
            (4, [(2, 0, 0), (0, 0, 1)]),
            (3, [(1, 0, 0), (0, 1, 0)]),
            (2, [(1, 0, 0)]),
            (1, []),
            (0, []),
            # 5 teams -> 3 rounds -> 1 quarter-final match, 2 semi-final matches, 1 final match
            # initial setup:
            #   quarter-finals: (1 match with both teams, , )
            #   semi-finals:    (1 match with both teams, 1 match with one teams, )
            #   final:          ( , , 1 match without teams)
        ],
        key=lambda _: random.random(),
    ),
)
def test_update_single_elimination(
    input, expected, execution_number, db: SessionTesting
) -> None:
    def has_both_teams(match: Match) -> bool:
        return match.team1_id and match.team2_id

    def has_one_team(match: Match) -> bool:
        return bool(match.team1_id) ^ bool(match.team2_id)

    def has_no_team(match: Match) -> bool:
        return not (match.team1_id or match.team2_id)

    rand_teams_id = random.sample(gl_teams_id, input)
    group = crud.group.update(db, id=gl_group_id, obj_in={"teams_id": rand_teams_id})

    if not expected:
        # Insuficient number of teams to create matches
        assert not group.matches
    n = 0
    group_matches = sorted(group.matches, key=lambda m: m.round)

    for r, e in enumerate(expected):
        m = n + sum(e)
        round_matches = group_matches[n:m]
        n = m
        assert all(m.round == r + 1 for m in round_matches)
        assert len(list(filter(lambda m: has_both_teams(m), round_matches))) == e[0]
        assert len(list(filter(lambda m: has_one_team(m), round_matches))) == e[1]
        assert len(list(filter(lambda m: has_no_team(m), round_matches))) == e[2]

    teams_id = [tid for m in group.matches for tid in (m.team1_id, m.team2_id) if tid]
    prereq_matches_id = [
        mid
        for m in group.matches
        for mid in (m.team1_prereq_match_id, m.team2_prereq_match_id)
        if mid
    ]

    assert len(teams_id) == len(set(teams_id))
    assert len(prereq_matches_id) == len(set(prereq_matches_id))
