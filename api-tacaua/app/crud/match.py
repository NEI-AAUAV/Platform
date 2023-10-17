from typing import List
from sqlalchemy.orm import Session

from app.exception import NotFoundException
from app.crud.base import CRUDBase
from app.models.match import Match
from app.schemas.match import MatchCreate, MatchUpdate


class CRUDMatch(CRUDBase[Match, MatchCreate, MatchUpdate]):
    def update(self, db: Session, *, id: int, obj_in: MatchUpdate) -> List[Match]:
        """Updates a match with the provided data

        **Parameters**
        * `db`: A SQLAlchemy ORM session
        * `id`: The id of the match to be updated
        * `obj_in`: The update data

        **Returns**
        A list with all the matches that were modified
        """

        # Start a new transaction since all changes that will be made must be
        # atomic (either everything is updated successfully or nothing is updated)
        with db.begin_nested():
            # Fetch the match being updated
            this_match = self.get(db, id=id)
            # Track all matches that are altered
            # (the current match is always marked as altered)
            altered = [this_match]

            # If the first team is to be updated then the match where the team is
            # also the first must swap with the current first team in this match
            if obj_in.team1_id is not None and obj_in.team1_id != this_match.team1_id:
                # Fetch the match where the first team is the same as in the update data
                team1_match = (
                    db.query(self.model)
                    .where(Match.team1_id == obj_in.team1_id)
                    .first()
                )

                if team1_match is None:
                    raise NotFoundException(detail=f"{self.model.__name__} Not Found")

                # Swap the teams
                team1_match.team1_id = this_match.team1_id
                # Mark the match where the teams where swapped as altered
                altered.append(team1_match)

            # If the second team is to be updated then the match where the team is
            # also the second must swap with the current second team in this match
            if obj_in.team2_id is not None and obj_in.team2_id != this_match.team2_id:
                # Fetch the match where the second team is the same as in the update data
                team2_match = (
                    db.query(self.model)
                    .where(Match.team2_id == obj_in.team2_id)
                    .first()
                )

                if team2_match is None:
                    raise NotFoundException(detail=f"{self.model.__name__} Not Found")

                # Swap the teams
                team2_match.team2_id = this_match.team2_id
                # Mark the match where the teams where swapped as altered
                altered.append(team2_match)

            # Update the current match with all the new data
            for returnkey, value in obj_in.dict().items():
                setattr(this_match, key, value)

        return altered

    def get_last_played(self, db: Session, amount: int):
        matches = db.query(self.model).order_by(self.model.date).all()

        # find first game that hasn't been played i.e winner == None

        for i, match in enumerate(matches):
            if match.winner is None:
                break

        # return last ammount games
        if i - amount < 0:
            return matches[:i]
        return matches[i - amount : i]

    def get_next_played(self, db: Session, amount: int):
        matches = db.query(self.model).order_by(self.model.date).all()

        # find first game that hasn't been played i.e winner == None

        for i, match in enumerate(matches):
            if match.winner is None:
                break

        # return last ammount games
        if i + amount > len(matches):
            return matches[i + 1 :]
        return matches[i + 1 : i + amount + 1]


match = CRUDMatch(Match)
