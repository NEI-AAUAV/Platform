import re
from typing import Any

from sqlalchemy.ext.declarative import as_declarative, declared_attr
from app.core.config import settings


@as_declarative()
class Base:
    id: Any
    __name__: str

    # Generate __tablename__ automatically
    @declared_attr
    def __tablename__(cls) -> str:
        names = re.findall('[A-Z][^A-Z]*', cls.__name__)
        return '_'.join(names).lower()

    __table_args__ = (
        {"schema": settings.SCHEMA_NAME},
    )

    def as_dict(self):
       return {c.name: getattr(self, c.name) for c in self.__table__.columns}
