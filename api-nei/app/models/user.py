from sqlalchemy import Column, Integer, String, DateTime, Enum

from app.db.base_class import Base
from app.schemas.user import PermissionEnum


class User(Base):
    __tablename__ = "user"

    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String(255))
    full_name = Column(String(255))
    uu_email = Column(String(255))
    uu_iupi = Column(String(255))
    curriculo = Column(String(255))
    linkedin = Column(String(255))
    git = Column(String(255))
    permission = Column(Enum(PermissionEnum, name="permission_enum", inherit_schema=True), nullable=True)
    created_at = Column(DateTime, index=True)
