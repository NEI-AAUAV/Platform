from functools import total_ordering

from app.crud.base import CRUDBase
import app.crud as crud

from app.models.standings import Standings
from app.models.match import Match
from app.models.group import Group, group_teams

from app.schemas.team import TeamLazy, TeamBase
from app.schemas.competition import (
    RankByEnum,
    SystemEnum,
    Metadata,
    SingleElimination,
    RoundRobin,
    Swiss,
)
from app.schemas.standings import (
    StandingsCreate,
    StandingsUpdate,
    StandingsInDB,
    StandingsBase,
    StandingsTable,
)

from app.core.logging import logger

from sqlalchemy.orm import Session
from typing import Any, Optional, List
from app.exception import NotFoundException


@total_ordering
class MaxType(object):
    def __le__(self, other):
        return False

    def __eq__(self, other):
        return self is other


Max = MaxType()


class CRUDStandings(CRUDBase[Standings, StandingsCreate, StandingsUpdate]):
    def get_table(self, db: Session, *, group_id: Any) -> Optional[List[Standings]]:
        obj = db.query(Standings).filter(Standings.group_id == group_id).all()
        return obj

    def auto_gen_standings(
        self, db: Session, *, group_id: Any
    ) -> Optional[List[Standings]]:
        competition_id = (
            db.query(Group.competition_id).filter(Group.id == group_id).all()[0][0]
        )
        metadata = crud.competition.get(db, id=competition_id)._metadata

        if not metadata:
            raise NotFoundException("Metadata not found")

        teams_stats = {}
        default_stats = {
            "wins": 0,
            "win_tiebreak": 0,
            "losses": 0,
            "loss_tiebreak": 0,
            "ties": 0,
            "ff": 0,
            "score_for": 0,
            "score_against": 0,
            "games_won": 0,
            "match_history": [],
        }
        games = db.query(Match).filter(Match.group_id == group_id).all()
        # sort games by date

        games.sort(key=lambda x: Max if x.date is None else x.date)
        logger.info("Accumulating team stats...")
        for game in games:
            if game.team1_id not in teams_stats:
                teams_stats[game.team1_id] = default_stats.copy()
                # this is necessary because of reference shenanigans
                teams_stats[game.team1_id]["match_history"] = []
            if game.team2_id not in teams_stats:
                teams_stats[game.team2_id] = default_stats.copy()
                teams_stats[game.team2_id]["match_history"] = []
            ts_1 = teams_stats[game.team1_id]
            ts_2 = teams_stats[game.team2_id]

            if metadata["rank_by"] == RankByEnum.GAMES_WINS:
                for i in range(len(game.games1)):
                    if game.games1[i] > game.games2[i]:
                        ts_1["games_won"] += 1
                    elif game.games1[i] < game.games2[i]:
                        ts_2["games_won"] += 1

            # this is to check tiebreaks
            if len(game.games1) > 2:
                if game.winner == 1:
                    ts_1["win_tiebreak"] += 1
                    ts_1["match_history"].append(1)
                    ts_2["loss_tiebreak"] += 1
                    ts_2["match_history"].append(-1)

                    if game.forfeiter == 2:
                        ts_2["ff"] += 1

                elif game.winner == 2:
                    ts_1["loss_tiebreak"] += 1
                    ts_1["match_history"].append(-1)
                    ts_2["win_tiebreak"] += 1
                    ts_2["match_history"].append(1)

                    if game.forfeiter == 1:
                        ts_1["ff"] += 1

                else:
                    ts_1["ties"] += 1
                    ts_2["ties"] += 1
                    ts_1["match_history"].append(0)
                    ts_2["match_history"].append(0)

            else:
                if game.winner == 1:
                    ts_1["wins"] += 1
                    ts_1["match_history"].append(1)
                    ts_2["losses"] += 1
                    ts_2["match_history"].append(-1)

                    if game.forfeiter == 2:
                        ts_2["ff"] += 1

                elif game.winner == 2:
                    ts_1["losses"] += 1
                    ts_1["match_history"].append(-1)
                    ts_2["wins"] += 1
                    ts_2["match_history"].append(1)
                    if game.forfeiter == 1:
                        ts_1["ff"] += 1

                else:
                    ts_1["ties"] += 1
                    ts_2["ties"] += 1
                    ts_1["match_history"].append(0)
                    ts_2["match_history"].append(0)

            ts_1["score_for"] += game.score1
            ts_2["score_for"] += game.score2
            ts_1["score_against"] += game.score2
            ts_2["score_against"] += game.score1

        list_standings = []

        if metadata["system"] == SystemEnum.ROUND_ROBIN:
            logger.info("Round_Robin")
            for team in teams_stats.keys():
                team_stats = teams_stats[team]
                team_pts = 0

                match metadata["rank_by"]:
                    case RankByEnum.PTS_CUSTOM:
                        team_pts = (
                            team_stats["wins"] * metadata["pts_win"]
                            + team_stats["ties"] * metadata["pts_tie"]
                            + team_stats["losses"] * metadata["pts_loss"]
                            + team_stats["ff"] * metadata["pts_ff"]
                            + team_stats["win_tiebreak"] * metadata["pts_win_tiebreak"]
                            + team_stats["loss_tiebreak"]
                            * metadata["pts_loss_tiebreak"]
                        )

                    case RankByEnum.WINS:
                        team_pts = team_stats["wins"]
                    case RankByEnum.SCORES:
                        team_pts = team_stats["score_for"]
                    case RankByEnum.GAMES_WINS:
                        team_pts = team_stats["games_won"]

                standing = Standings(
                    team_id=team,
                    group_id=group_id,
                    pts=team_pts,
                    matches=len(team_stats["match_history"]),
                    wins=team_stats["wins"],
                    ties=team_stats["ties"],
                    losses=team_stats["losses"],
                    ff=team_stats["ff"],
                    score_for=team_stats["score_for"],
                    score_agst=team_stats["score_against"],
                    goal_difference=team_stats["score_for"]
                    - team_stats["score_against"],
                    match_history=team_stats["match_history"],
                )
                db.add(standing)
                list_standings.append(standing)

        elif isinstance(metadata, SingleElimination):
            pass
        elif isinstance(metadata, Swiss):
            pass

        db.flush()

        list_standings.sort(key=lambda x: (-x.pts, x.team.name))

        db.commit()

        return list_standings


standings = CRUDStandings(Standings)
