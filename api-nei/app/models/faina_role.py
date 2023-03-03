from sqlalchemy import Column, Integer, String

from app.db.base_class import Base


class FainaRole(Base):
    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String(20))
    weight = Column(Integer)
