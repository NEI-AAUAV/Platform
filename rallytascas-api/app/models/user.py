from sqlalchemy import String, Column, Integer, Boolean, ForeignKey

from app.core.config import settings
from app.db.base_class import Base


class User(Base):
    __tablename__ = "user"

    id = Column(Integer, primary_key=True, autoincrement=True)
    team_id = Column(Integer, ForeignKey(settings.SCHEMA_NAME + ".team.id"), nullable=True)
    username = Column(String, unique=True)
    is_staff = Column(Boolean, default=False)
    is_admin = Column(Boolean, default=False)
    disabled = Column(Boolean, default=False)
    hashed_password = Column(String)
