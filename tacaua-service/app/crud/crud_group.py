from typing import Union, Dict, Any
from fastapi.encoders import jsonable_encoder
from sqlalchemy.orm import Session

from app.crud.base import CRUDBase
from app.schemas.group import GroupCreate, GroupUpdate
from app.models import Group, Team
from app.core.logging import logger


class CRUDGroup(CRUDBase[Group, GroupCreate, GroupUpdate]):

    def create(self, db: Session, *, obj_in: GroupCreate) -> Group:
        obj_in_data = jsonable_encoder(obj_in)
        db_obj = Group(**obj_in_data)
        n = db.query(Group).filter(
            Group.competition_id == db_obj.competition_id).count()
        setattr(db_obj, 'number', n + 1)
        db.add(db_obj)
        db.commit()
        db.refresh(db_obj)
        return db_obj

    # def update(
    #     self,
    #     db: Session,
    #     *,
    #     id: int,
    #     obj_in: Union[GroupUpdate, Dict[str, Any]]
    # ) -> Group:
    #     obj_data = jsonable_encoder(db_obj)
    #     if isinstance(obj_in, dict):
    #         update_data = obj_in
    #     else:
    #         update_data = obj_in.dict(exclude_unset=True)
    #     for field in obj_data:
    #         if field in update_data:
    #             setattr(db_obj, field, update_data[field])
    #     db.add(db_obj)
    #     db.commit()
    #     db.refresh(db_obj)
    #     return db_obj


group = CRUDGroup(Group)
