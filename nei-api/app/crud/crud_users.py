from sqlalchemy.orm import Session

from app.crud.base import CRUDBase
from app.models.users import Users
from app.schemas.users import UsersCreate, UsersUpdate, UsersInDB


class CRUDUsers(CRUDBase[Users, UsersCreate, UsersUpdate]):
    ...


users = CRUDUsers(Users)
