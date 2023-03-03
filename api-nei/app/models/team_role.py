from sqlalchemy import Column, Integer, String
from app.db.base_class import Base


class TeamRole(Base):
    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String(120))
    weight = Column(Integer, index=True)
