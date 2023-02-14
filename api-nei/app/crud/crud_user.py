from typing import Optional
from sqlalchemy.orm import Session

from app.crud.base import CRUDBase
from app.models.user import User
from app.schemas.user import UserCreate, UserUpdate


class CRUDUser(CRUDBase[User, UserCreate, UserUpdate]):
    def get_by_email(self, db: Session, email: str) -> Optional[User]:
        """Fetches a user from the database by it's email.

        **Parameters**
        * `db`: A SQLAlchemy ORM session
        * `email`: The user's email address
        """
        return db.query(self.model).filter(self.model.email == email).first()


user = CRUDUser(User)
