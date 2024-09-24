import re
from typing import Any

from sqlalchemy import Enum, MetaData
from sqlalchemy.orm import DeclarativeBase, declared_attr
from app.core.config import settings

convention = {
    "ix": "ix_%(column_0N_label)s",
    "uq": "uq_%(table_name)s_%(column_0_N_name)s",
    "ck": "ck_%(table_name)s_%(constraint_name)s",
    "fk": "fk_%(table_name)s_%(column_0_N_name)s_%(referred_table_name)s",
    "pk": "pk_%(table_name)s",
}


class Base(DeclarativeBase):
    metadata = MetaData(naming_convention=convention)

    id: Any

    @declared_attr.directive
    def __tablename__(cls) -> str:
        """Generate table name automatically from class name.

        e.g.: `TacaUAMember` converts to `taca_ua_member`.
        """
        names = re.findall(r"[A-Z][a-z]+|[A-Z]+(?![a-z])", cls.__name__)
        return "_".join(names).lower()

    @declared_attr.directive
    def __table_args__(cls):
        return {"schema": settings.SCHEMA_NAME}

    def dict(self):
        """Convert the SQLAlchemy model to a dictionary."""
        return {c.name: getattr(self, c.name) for c in self.__table__.columns}


class BaseEnum(Enum):
    """Base class for SQLAlchemy Enum types.

    Ensure that the Enum schema is inherited from the table
    and generate its name automatically.
    """

    def __init__(self, *enums: object, **kw: Any):
        name = kw.get("name", None)
        if name is None and isinstance(enums[0], type):
            # If `enums` is a class, use the class name to generate the name automatically
            # e.g.: `TypeEnum` converts to `type_enum`.
            names = re.findall(r"[A-Z][a-z]+|[A-Z]+(?![a-z])", enums[0].__name__)
            kw["name"] = "_".join(names).lower()

        super().__init__(*enums, inherit_schema=True, **kw)
