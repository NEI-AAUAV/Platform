from typing import Any, Dict, Generic, List, Optional, Type, TypeVar, Union

from fastapi.encoders import jsonable_encoder
from pydantic import BaseModel
from pymongo.collection import Collection, ReturnDocument

from app.db.db import Counter


CollectionType = TypeVar("CollectionType", bound=Collection)
CreateSchemaType = TypeVar("CreateSchemaType", bound=BaseModel)
UpdateSchemaType = TypeVar("UpdateSchemaType", bound=BaseModel)
ModelSchemaType = TypeVar("ModelSchemaType", bound=BaseModel)


class CRUDBase(Generic[CollectionType, CreateSchemaType, UpdateSchemaType, ModelSchemaType]):

    def __init__(self, collection: Type[CollectionType], model: Type[ModelSchemaType],
                 *, pk_auto_increment: bool = False):
        """
        CRUD object with default methods to Create, Read, Update, Delete (CRUD).
        **Parameters**
        * `model`: A SQLAlchemy model class
        * `schema`: A Pydantic model (schema) class
        """
        self.collection = collection
        self.model = model
        self.pk_auto_increment = pk_auto_increment

    def next(self):
        doc = Counter.find_one_and_update([
            {'_id', self.collection.name},
            {'$inc', {'seq_value': 1}},
            True
        ])
        return doc.seq_value

    def get(self, *, id: int) -> Any:
        doc = self.collection.find_one({'_id', id})
        return doc

    def get_multi(
        self, *, skip: int = 0, limit: int = 100
    ) -> List[CollectionType]:
        docs = self.collection.find().skip(skip).limit(limit)
        return docs

    def create(self, *, obj_in: CreateSchemaType) -> CollectionType:
        obj_in_data = obj_in.dict()
        if self.pk_auto_increment:
            obj_in_data['_id'] = self.next_id()

        doc = self.collection.insert_one(self.model(**obj_in_data))
        return doc

    def update(
        self, *, id: int, obj_in: Union[UpdateSchemaType, Dict[str, Any]]
    ) -> CollectionType:
        if isinstance(obj_in, dict):
            update_data = obj_in
        else:
            update_data = obj_in.dict(exclude_unset=True)

        doc = self.collection.find_one_and_update(
            {'_id': id},
            {'$set': update_data},
            return_document=ReturnDocument.AFTER)
        return doc

    def remove(self, *, id: int) -> CollectionType:
        doc = self.collection.delete_one({'_id': id})
        return doc
