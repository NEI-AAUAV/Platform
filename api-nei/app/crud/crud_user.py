from typing import Optional
from sqlalchemy.orm import Session
from fastapi.encoders import jsonable_encoder

from app.crud.base import CRUDBase
from app.models.user import User
from app.models.email import UserEmail
from app.schemas.user import UserCreate, UserUpdate
from app.core.config import settings


class CRUDUser(CRUDBase[User, UserCreate, UserUpdate]):
    def get_by_email(self, db: Session, email: str) -> Optional[tuple[User, UserEmail]]:
        """Fetches a user from the database by it's email.

        **Parameters**
        * `db`: A SQLAlchemy ORM session
        * `email`: The user's email address
        """
        return (
            db.query(self.model, UserEmail)
            .filter(self.model.id == UserEmail.user_id, UserEmail.email == email)
            .first()
        )

    def create(
        self,
        db: Session,
        *,
        obj_in: UserCreate,
        email: str,
        active: bool = not settings.EMAIL_ENABLED
    ) -> User:
        """Creates a new user in the database with an associated email.

        **Parameters**
        * `db`: A SQLAlchemy ORM session
        * `obj_in`: The user creation data
        * `email`: The user's email address
        * `active`: Whether the provided email should be considered already active or not
        """
        obj_in_data = jsonable_encoder(obj_in)
        db_obj = self.model(**obj_in_data)  # type: ignore

        # Start a new transaction since all changes that will be made must be
        # atomic (either everything is updated successfully or nothing is updated)
        with db.begin_nested():
            # Add the user to the database.
            db.add(db_obj)
            # Make sure the new user is created in the database so that an id is
            # generated for it.
            db.flush()

            # Add an user email entry to the database.
            db.add(UserEmail(email=email, active=active, user_id=db_obj.id))

        return db_obj

    def activate_email(self, db: Session, *, user: User, email: str):
        """Marks an email as active for a user.

        **Parameters**
        * `db`: A SQLAlchemy ORM session
        * `user`: The user
        * `email`: The user's email address
        """
        db_obj = (
            db.query(UserEmail)
            .filter(UserEmail.user_id == user.id, UserEmail.email == email)
            .first()
        )
        assert db_obj is not None
        db_obj.active = True

        db.add(db_obj)
        db.commit()
        db.refresh(db_obj)

        return db_obj


user = CRUDUser(User)
