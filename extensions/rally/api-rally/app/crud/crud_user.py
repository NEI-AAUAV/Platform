from fastapi import HTTPException
from sqlalchemy.exc import IntegrityError
from sqlalchemy.orm import Session

from app.crud.base import CRUDBase
from app.models.user import User
from app.schemas.user import UserCreate, UserUpdate

from ._deps import foreign_key_error_regex

_team_foreign_error_regex = foreign_key_error_regex(User.team_id.name)


class CRUDUser(CRUDBase[User, UserCreate, UserUpdate]):
    def create(self, db: Session, *, obj_in: UserCreate) -> User:
        try:
            return super().create(db, obj_in=obj_in)
        except IntegrityError as e:
            db.rollback()

            if e.orig is None:
                raise

            if _team_foreign_error_regex.search(str(e.orig)) is not None:
                raise HTTPException(status_code=404, detail="Team not found")

            raise

    def update(self, db: Session, *, id: int, obj_in: UserUpdate) -> User:
        try:
            return super().update(db, id=id, obj_in=obj_in)
        except IntegrityError as e:
            db.rollback()

            if e.orig is None:
                raise

            if _team_foreign_error_regex.search(str(e.orig)) is not None:
                raise HTTPException(status_code=404, detail="Team not found")

            raise


user = CRUDUser(User)
