from sqlalchemy import String, Column, Integer

from app.db.base_class import Base


class Rgm(Base):
    __tablename__ = "rgm"

    id = Column(Integer, primary_key=True, autoincrement=True)
    categoria = Column(String(11))
    mandato = Column(Integer, default=0)
    file = Column(String(255))