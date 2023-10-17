import pytest
import random
import itertools
from typing import Any, List

from sqlalchemy.engine import Connection

import app.crud as crud
from app.crud.group.round_robin import round_robin_pairing_generator
from app.crud.group.single_elimination import get_single_elimination_matches_per_round
from app.models import Modality, Competition, Group, Match, Course, Team
from app.schemas.competition import RoundRobin, SystemEnum, RankByEnum
from app.tests.conftest import SessionTesting


gl_group_id = None
gl_teams_id = None
gl_rr_competition = None
gl_rr_group_id = None
gl_rr_teams_id = None

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

round_robin_competition_data = {
    "name": "string (round robin)",
    "started": False,
    "public": False,
    "_metadata": RoundRobin(
        rank_by=RankByEnum.WINS, system=SystemEnum.ROUND_ROBIN, play_each_other_times=1
    ).dict(),
}


def setup_competition(
    modality: Modality, data: Any, db: SessionTesting
) -> tuple[int, List[int], int]:
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

    return (competition.id, teams_ids, group.id)


@pytest.fixture(scope="module", name="db")
def setup_teams(connection: Connection):
    global gl_teams_id, gl_group_id, gl_rr_competition, gl_rr_teams_id, gl_rr_group_id

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

    (_, teams_ids, group_id) = setup_competition(modality, competition_data, db)
    gl_teams_id = teams_ids
    gl_group_id = group_id

    (competition_id, teams_ids, group_id) = setup_competition(
        modality, round_robin_competition_data, db
    )
    gl_rr_competition = competition_id
    gl_rr_teams_id = teams_ids
    gl_rr_group_id = group_id

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
        ]
        * 3,
        key=lambda _: random.random(),
    ),
)
def test_update_single_elimination(input, expected, db: SessionTesting) -> None:
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


round_robin_truth_tables = [
    # fmt: off
    (7, [
        (0, 7), (1, 6), (2, 5), (3, 4),
        (0, 6), (7, 5), (1, 4), (2, 3),
        (0, 5), (6, 4), (7, 3), (1, 2),
        (0, 4), (5, 3), (6, 2), (7, 1),
        (0, 3), (4, 2), (5, 1), (6, 7),
        (0, 2), (3, 1), (4, 7), (5, 6),
        (0, 1), (2, 7), (3, 6), (4, 5),
    ]),
    (14, [
        (0, 13), (1, 12), (2, 11), (3, 10), (4, 9), (5, 8), (6, 7), 
        (0, 12), (13, 11), (1, 10), (2, 9), (3, 8), (4, 7), (5, 6), 
        (0, 11), (12, 10), (13, 9), (1, 8), (2, 7), (3, 6), (4, 5), 
        (0, 10), (11, 9), (12, 8), (13, 7), (1, 6), (2, 5), (3, 4), 
        (0, 9), (10, 8), (11, 7), (12, 6), (13, 5), (1, 4), (2, 3), 
        (0, 8), (9, 7), (10, 6), (11, 5), (12, 4), (13, 3), (1, 2), 
        (0, 7), (8, 6), (9, 5), (10, 4), (11, 3), (12, 2), (13, 1), 
        (0, 6), (7, 5), (8, 4), (9, 3), (10, 2), (11, 1), (12, 13), 
        (0, 5), (6, 4), (7, 3), (8, 2), (9, 1), (10, 13), (11, 12), 
        (0, 4), (5, 3), (6, 2), (7, 1), (8, 13), (9, 12), (10, 11), 
        (0, 3), (4, 2), (5, 1), (6, 13), (7, 12), (8, 11), (9, 10), 
        (0, 2), (3, 1), (4, 13), (5, 12), (6, 11), (7, 10), (8, 9), 
        (0, 1), (2, 13), (3, 12), (4, 11), (5, 10), (6, 9), (7, 8)
    ]),
]


@pytest.mark.parametrize("teams,truth_table", round_robin_truth_tables)
def test_round_robin_pairing_generator(teams, truth_table) -> None:
    padded_teams = 2 * ((teams + 1) // 2)
    for i in range(3 * len(truth_table)):
        assert (
            round_robin_pairing_generator(i, padded_teams)
            == truth_table[i % len(truth_table)]
        ), f"State: {i}"


@pytest.mark.parametrize("play_each_other_times", range(1, 4))
@pytest.mark.parametrize(
    "input,expected",
    sorted(
        [
            (10, [5, 5, 5, 5, 5, 5, 5, 5, 5]),
            (9, [4, 4, 4, 4, 4, 4, 4, 4, 4]),
            (8, [4, 4, 4, 4, 4, 4, 4]),
            (7, [3, 3, 3, 3, 3, 3, 3]),
            (6, [3, 3, 3, 3, 3]),
            (5, [2, 2, 2, 2, 2]),
            (4, [2, 2, 2]),
            (3, [1, 1, 1]),
            (2, [1]),
            (1, []),
            (0, []),
            # 5 teams -> 3 rounds -> 1 quarter-final match, 2 semi-final matches, 1 final match
            # initial setup:
            #   quarter-finals: (1 match with both teams, , )
            #   semi-finals:    (1 match with both teams, 1 match with one teams, )
            #   final:          ( , , 1 match without teams)
        ]
        * 3,
        key=lambda _: random.random(),
    ),
)
def test_update_round_robin(
    input, expected, play_each_other_times, db: SessionTesting
) -> None:
    # Update `play_each_other_times` in the competition
    crud.competition.update(
        db,
        id=gl_rr_competition,
        obj_in={"_metadata": {"play_each_other_times": play_each_other_times}},
    )

    rand_teams_id = random.sample(gl_rr_teams_id, input)
    group = crud.group.update(db, id=gl_rr_group_id, obj_in={"teams_id": rand_teams_id})

    matchups = {}

    for m in group.matches:
        key = frozenset({m.team1_id, m.team2_id})
        matchups[key] = matchups.get(key, 0) + 1

    if not expected:
        # Insuficient number of teams to create matches
        assert not group.matches
    else:
        n = 0
        group_matches = sorted(group.matches, key=lambda m: m.round)

        for r, e in enumerate(expected * play_each_other_times):
            m = n + e
            round_matches = group_matches[n:m]
            n = m
            assert all(m.round == r + 1 for m in round_matches)
            assert all(
                m.team1_id is not None and m.team2_id is not None for m in round_matches
            )

        assert n == len(group_matches)

        for comb in itertools.combinations(rand_teams_id, 2):
            key = frozenset(comb)
            assert matchups.get(key, 0) == play_each_other_times

        teams_id = [
            tid for m in group.matches for tid in (m.team1_id, m.team2_id) if tid
        ]
        assert input == len(set(teams_id))
