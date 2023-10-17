from sqlalchemy.orm import Session
from fastapi.encoders import jsonable_encoder

from app.crud.base import CRUDBase
from app.api import deps
from app.models.user import User
from app.schemas.user import UserCreate, UserUpdate


class CRUDUser(CRUDBase[User, UserCreate, UserUpdate]):
    def create(self, db: Session, *, obj_in: UserCreate) -> User:
        obj_in_data = jsonable_encoder(obj_in)
        obj_in_data["hashed_password"] = deps.get_password_hash(
            obj_in_data.pop("password")
        )
        db_obj = User(**obj_in_data)  # type: ignore
        db.add(db_obj)
        db.commit()
        db.refresh(db_obj)
        return db_obj

    def update(self, db: Session, *, id: int, obj_in: UserUpdate) -> User:
        with db.begin_nested():
            db_obj = self.get(db, id=id, for_update=True)
            update_data = obj_in.model_dump(exclude_unset=True)

            if "password" in update_data:
                update_data["hashed_password"] = deps.get_password_hash(
                    update_data.pop("password")
                )

            for field in jsonable_encoder(db_obj):
                if field in update_data:
                    setattr(db_obj, field, update_data[field])
        return db_obj


user = CRUDUser(User)
