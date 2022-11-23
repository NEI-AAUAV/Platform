from sqlalchemy import Column, Integer, String
from sqlalchemy.orm import relationship

from app.db.base_class import Base


class Faina(Base):
    __tablename__ = "faina"

    id = Column(Integer, primary_key=True, autoincrement=True)
    image = Column(String(255))
    year = Column(String(9))

    members = relationship(
        "FainaMember",
    )
