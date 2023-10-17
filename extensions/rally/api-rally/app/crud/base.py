from typing import Any, Generic, Optional, Sequence, Type, TypeVar
from fastapi.encoders import jsonable_encoder
from pydantic import BaseModel
from sqlalchemy import select
from sqlalchemy.orm import Session

from app.exception import NotFoundException
from app.models.base import Base

ModelType = TypeVar("ModelType", bound=Base)
CreateSchemaType = TypeVar("CreateSchemaType", bound=BaseModel)
UpdateSchemaType = TypeVar("UpdateSchemaType", bound=BaseModel)


class CRUDBase(Generic[ModelType, CreateSchemaType, UpdateSchemaType]):
    def __init__(self, model: Type[ModelType]):
        """
        CRUD object with default methods to Create, Read, Update, Delete (CRUD).
        **Parameters**
        * `model`: A SQLAlchemy model class
        * `schema`: A Pydantic model (schema) class
        """
        self.model = model

    def get(self, db: Session, *, id: Any, for_update: bool = False) -> ModelType:
        obj = db.get(self.model, id, with_for_update=for_update)
        if obj is None:
            raise NotFoundException(detail=f"{self.model.__name__} Not Found")
        return obj

    def get_multi(
        self,
        db: Session,
        *,
        skip: Optional[int] = None,
        limit: Optional[int] = None,
        for_update: bool = False,
    ) -> Sequence[ModelType]:
        stmt = select(self.model).limit(limit).offset(skip)
        if for_update:
            stmt = stmt.with_for_update()
        return db.scalars(stmt).all()

    def create(self, db: Session, *, obj_in: CreateSchemaType) -> ModelType:
        obj_in_data = jsonable_encoder(obj_in)
        db_obj = self.model(**obj_in_data)  # type: ignore
        db.add(db_obj)
        db.commit()
        db.refresh(db_obj)
        return db_obj

    def update_unlocked(
        self, *, db_obj: ModelType, obj_in: UpdateSchemaType
    ) -> ModelType:
        update_data = obj_in.model_dump(exclude_unset=True)

        for field in jsonable_encoder(db_obj):
            if field in update_data:
                setattr(db_obj, field, update_data[field])

        return db_obj

    def update(self, db: Session, *, id: int, obj_in: UpdateSchemaType) -> ModelType:
        with db.begin_nested():
            db_obj = self.get(db, id=id, for_update=True)
            db_obj = self.update_unlocked(db_obj=db_obj, obj_in=obj_in)
        return db_obj

    def remove(self, db: Session, *, id: int) -> ModelType:
        db_obj = self.get(db, id=id)
        db.delete(db_obj)
        db.commit()
        return db_obj
