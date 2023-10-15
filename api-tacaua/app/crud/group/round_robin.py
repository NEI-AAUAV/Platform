from typing import Dict, Set, List
from sqlalchemy.orm import Session

from app.schemas.competition import RoundRobin
from app.models import Group, Match


def update_round_robin_matches(db: Session, group: Group, metadata: RoundRobin) -> None:
    """Recreate match bracket using the round robin method."""
    # Build a set of all teams in the group for faster `contains` checks
    teams_id: Set[int] = set(t.id for t in group.teams)
    ordered_teams = sorted(list(group.teams), key=lambda t: t.id)

    num_teams = len(group.teams)
    padded_teams = (num_teams + 1) // 2 * 2
    matches_per_round = padded_teams // 2
    total_matches = (
        metadata.play_each_other_times * matches_per_round * (padded_teams - 1)
    )
    dummy_team = num_teams if num_teams != padded_teams else padded_teams

    matches_pre_occupied: Dict[frozenset[int], List[Match]] = {}

    for m in group.matches[:]:
        # Delete matches where the teams aren't in the group
        if not teams_id.issuperset((m.team1_id, m.team2_id)):
            db.delete(m)
        else:
            key = frozenset({m.team1_id, m.team2_id})
            key_matches = matches_pre_occupied.setdefault(key, [])
            if len(key_matches) < metadata.play_each_other_times:
                key_matches.append(m)
            else:
                db.delete(m)

    for state in range(0, total_matches):
        (idx1, idx2) = round_robin_pairing_generator(state, padded_teams)
        round = (state // matches_per_round) + 1
        team1 = None
        team2 = None

        if idx1 == dummy_team or idx2 == dummy_team:
            continue

        team1 = ordered_teams[idx1]
        team2 = ordered_teams[idx2]

        key = frozenset({team1.id, team2.id})
        key_matches = matches_pre_occupied.get(key, [])

        if len(key_matches) != 0:
            m = key_matches.pop()
            m.round = round
        else:
            match_data = {
                "group_id": group.id,
                "round": round,
                "team1_id": team1.id,
                "team2_id": team2.id,
            }

            db.add(Match(**match_data))


def round_robin_pairing_generator(state: int, teams: int) -> tuple[int, int]:
    rounds = teams - 1
    games_per_round = teams // 2

    total_games = games_per_round * rounds

    outer_state = state % total_games
    inner_state = outer_state % games_per_round

    shift = outer_state // games_per_round

    idx2 = teams - shift - inner_state - 1
    if idx2 <= 0:
        idx2 -= 1
    idx2 %= teams

    idx1 = 0
    if inner_state != 0:
        idx1 = teams - shift + inner_state - 1
        if inner_state > shift:
            idx1 += 1
        idx1 %= teams

    return (idx1, idx2)
