from sqlalchemy import Column, Integer, String

from app.db.base_class import Base


class Faina(Base):
    __tablename__ = "faina"

    mandato = Column(Integer, primary_key=True)
    imagem = Column(String(255))
    anoLetivo = Column(String(9))