import re

from sqlalchemy.orm import DeclarativeBase, declared_attr
from app.core.config import settings


class Base(DeclarativeBase):
    # Generate __tablename__ automatically
    @declared_attr.directive
    def __tablename__(cls) -> str:
        names = re.findall("[A-Z][^A-Z]*", cls.__name__)
        return "_".join(names).lower()

    __table_args__ = ({"schema": settings.SCHEMA_NAME},)
