import math
from typing import List
from sqlalchemy.orm import Session

from app.schemas.competition import SingleElimination
from app.models import Group, Match


def update_single_elimination_matches(
    db: Session, group: Group, metadata: SingleElimination
) -> None:
    """Recreate match bracket according to existent teams."""
    # TODO: not using metadata for 3rd match

    # Remove the sqlalchemy instrumentation from the matches list
    # to allows us to manipulate it like a normal list.
    matches = list(group.matches)
    # Get the ids of ll
    teams_id = {t.id for t in group.teams}

    # Function for filtering matches were teams aren't in the group
    # anymore while removing them from the DB.
    def match_predicate(m: Match) -> bool:
        """
        Checks wether the teams in the match belong to the group.

        Removes the matches that no longer belong from the database.
        """
        cond = teams_id.issuperset((m.team1_id, m.team2_id))
        if not cond:
            db.delete(m)
        return cond

    # Iterator of matches that already existed in the database
    matches = list(filter(match_predicate, matches))

    teams_id_assigned = {
        tid for m in matches for tid in (m.team1_id, m.team2_id) if tid is not None
    }
    teams_id_diff = teams_id - teams_id_assigned

    matches_count_per_round = get_single_elimination_matches_per_round(len(group.teams))
    matches_per_round = [[] for _ in range(len(matches_count_per_round))]

    for r, matches_count in enumerate(matches_count_per_round):
        for _ in range(matches_count):
            if len(matches) != 0:
                m = matches.pop()
                m.round = r + 1
            else:
                # Create match
                match_data = {"group_id": group.id, "round": r + 1}
                if teams_id_diff:
                    tid1 = teams_id_diff.pop()
                    match_data |= {"team1_id": tid1}
                    if teams_id_diff:
                        # Create leaf match
                        tid2 = teams_id_diff.pop()
                        match_data |= {"team2_id": tid2}
                    else:
                        # Create next match for 1 previous match
                        c = matches_count_per_round[r - 1]
                        m = matches_per_round[r - 1][c - 1]
                        match_data |= {"team2_prereq_match_id": m.id}
                        matches_count_per_round[r - 1] -= 1
                else:
                    # Create next match for 2 previous matches
                    c = matches_count_per_round[r - 1]
                    ms = matches_per_round[r - 1]
                    match_data |= {
                        "team1_prereq_match_id": ms[c - 1].id,
                        "team2_prereq_match_id": ms[c - 2].id,
                    }
                    matches_count_per_round[r - 1] -= 2
                m = Match(**match_data)
                db.add(m)
            matches_per_round[r].append(m)


def get_single_elimination_matches_per_round(n_teams: int) -> List[int]:
    """Return a list with the number of matches per round in a single elimination system.

    e.g: 4 teams -> [2, 1]: 2 matches in semifinals and 1 in final
    """
    if n_teams < 1:
        return []
    n = int(math.log2(n_teams))
    matches_per_round = [2**i for i in reversed(range(n))]
    matches_diff = n_teams - sum(matches_per_round) - 1
    if matches_diff:
        matches_per_round = [matches_diff] + matches_per_round
    return matches_per_round
