import re
from typing import Any

from sqlalchemy.ext.declarative import as_declarative, declared_attr
from app.core.config import settings


@as_declarative()
class Base:
    id: Any
    __name__: str

    @declared_attr
    def __tablename__(cls) -> str:
        """Generate table name automatically from class name.

        e.g.: `TacaUAMember` converts to `taca_ua_member`.
        """
        names = re.findall(r"[A-Z][a-z]+|[A-Z]+(?![a-z])", cls.__name__)
        return '_'.join(names).lower()

    __table_args__ = (
        {"schema": settings.SCHEMA_NAME},
    )

    def dict(self):
       return {c.name: getattr(self, c.name) for c in self.__table__.columns}
