from sqlalchemy import Column, Integer, String
from app.db.base_class import Base


class TeamRoles(Base):
    __tablename__ = "team_roles"

    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String(120))
    weight = Column(Integer, index=True)
