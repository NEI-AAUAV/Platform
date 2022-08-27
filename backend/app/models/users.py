from sqlalchemy import Column, ForeignKey, SmallInteger, Integer, String, Date, Enum
from sqlalchemy.orm import relationship

from app.core.config import settings
from app.db.base_class import Base
from app.schemas.users import PermissionEnum


class Users(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String(255))
    fullname = Column(String(255))
    uu_email = Column(String(255))
    uu_yupi = Column(String(255))
    curriculo = Column(String(255))
    linkedin = Column(String(255))
    git = Column(String(255))
    permission = Column(Enum(PermissionEnum, name="permission_enum", create_type=False))
    created_at = Column(Date, index=True)
    
