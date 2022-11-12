from sqlalchemy import Column, Integer, String

from app.db.base_class import Base


class FainaRoles(Base):
    __tablename__ = "faina_roles"

    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String(20))
    weight = Column(Integer)