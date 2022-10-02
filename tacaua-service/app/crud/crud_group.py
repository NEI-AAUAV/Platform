from typing import Union, Dict, Any, Set
from fastapi.encoders import jsonable_encoder
from sqlalchemy.orm import Session

import app.crud as crud
from app.exception import NotFoundException
from app.crud.base import CRUDBase
from app.schemas.group import GroupCreate, GroupUpdate
from app.models import Group, Team, Competition
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

    def update_number(
        self, db: Session, *, db_obj: Group, number: int
    ) -> Group:
        db_obj2 = db.query(Group).filter(
            Group.competition_id == db_obj.competition_id,
            Group.number == number
        ).one_or_none()
        if not db_obj2:
            raise NotFoundException(f"Exchange Group Not Found")
        setattr(db_obj, 'number', number)
        setattr(db_obj2, 'number', db_obj.number)
        db.add(db_obj)
        db.add(db_obj2)
        db.commit()
        db.refresh(db_obj)
        return db_obj

    def update_teams(
        self, db: Session, *, db_obj: Group, teams_id: Set[int]
    ) -> Group:
        modality_id = crud.competition.get(
            db, id=db_obj.competition_id).modality_id
        teams = [t for t in db_obj.teams if t.id in teams_id]
        teams_id_diff = teams_id - {t.id for t in teams}
        for tid in teams_id_diff:
            team = db.query(Team).filter(
                Team.id == tid, Team.modality_id == modality_id).first()
            if not team:
                raise NotFoundException(detail=f"Team In Modality Not Found")
            teams.append(team)
        db_obj.teams = teams
        db.add(db_obj)
        db.commit()
        db.refresh(db_obj)
        return db_obj

    def update(
        self,
        db: Session,
        *,
        id: int,
        obj_in: Union[GroupUpdate, Dict[str, Any]]
    ) -> Group:
        db_obj = self.get(db, id=id)
        obj_data = jsonable_encoder(db_obj)
        if isinstance(obj_in, dict):
            update_data = obj_in
        else:
            update_data = obj_in.dict(exclude_unset=True)

        if 'number' in update_data:
            number = update_data.pop('number')
            db_obj = self.update_number(db, db_obj=db_obj, number=number)
        if 'teams_id' in update_data:
            teams_id = update_data['teams_id']
            db_obj = self.update_teams(db, db_obj=db_obj, teams_id=teams_id)

        for field in obj_data:
            if field in update_data:
                setattr(db_obj, field, update_data[field])
        db.add(db_obj)
        db.commit()
        db.refresh(db_obj)
        return db_obj


group = CRUDGroup(Group)
