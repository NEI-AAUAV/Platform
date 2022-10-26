import pytest
import random

from sqlalchemy.engine import Connection

import app.crud as crud
from app.models import Modality, Competition, Group, Match, Course, Team
from app.tests.conftest import SessionTesting


gl_group_id = None
gl_teams_id = None

competition_data = {
    "name": "string",
    "started": False,
    "public": False,
    "metadata_": {
        "rank_by": "Vitórias",
        "system": "Eliminação Direta",
        "third_place_match": False,
    }
}


@pytest.fixture(scope='module', name='db')
def setup_teams(connection: Connection):
    global gl_teams_id, gl_group_id

    transaction = connection.begin()
    db = SessionTesting(bind=connection)

    modality = Modality(
        year=0,
        frame="Misto",
        sport="Atletismo",
    )
    db.add(modality)
    db.commit()
    db.refresh(modality)

    competition = Competition(modality_id=modality.id, **competition_data)
    db.add(competition)
    db.commit()
    db.refresh(competition)

    group = Group(competition_id=competition.id, number=1)
    db.add(group)
    db.commit()
    db.refresh(group)

    course = Course(
        name="Eng. Informática",
        initials="NEI",
    )
    db.add(course)
    db.commit()
    db.refresh(course)

    for i in range(10):
        db.add(Team(
            course_id=course.id,
            modality_id=modality.id,
            name=f"Team #{i}"
        ))
    db.commit()

    gl_teams_id = [t.id for t in db.query(Team).all()]
    gl_group_id = group.id

    yield db
    db.close()
    transaction.rollback()


@pytest.mark.parametrize("input,expected", [
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
])
def test_get_matches_per_round(input, expected):
    assert crud.group.get_matches_per_round(input) == expected


@pytest.mark.parametrize('execution_number', range(2))
@pytest.mark.parametrize("input,expected", sorted([
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
], key=lambda _: random.random()))
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
    group = crud.group.update(db, id=gl_group_id, obj_in={
        'teams_id': rand_teams_id})

    if not expected:
        assert not group.matches
    n = 0
    group_matches = sorted(group.matches, key=lambda m: m.round)

    for r, e in enumerate(expected):
        m = n + sum(e)
        round_matches = group_matches[n:m]
        n = m
        assert all(m.round == r + 1 for m in round_matches)
        assert len(list(filter(
            lambda m: has_both_teams(m), round_matches))) == e[0]
        assert len(list(filter(
            lambda m: has_one_team(m), round_matches))) == e[1]
        assert len(list(filter(
            lambda m: has_no_team(m), round_matches))) == e[2]

    teams_id = [tid for m in group.matches for tid in (
        m.team1_id, m.team2_id) if tid]
    prereq_matches_id = [mid for m in group.matches for mid in (
        m.team1_prereq_match_id, m.team2_prereq_match_id) if mid]
    
    assert len(teams_id) == len(set(teams_id))
    assert len(prereq_matches_id) == len(set(prereq_matches_id))
