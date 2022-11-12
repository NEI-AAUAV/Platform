from sqlalchemy import Float, String, Column, Integer

from app.db.base_class import Base


class Merchandisings(Base):
    __tablename__ = "merchandisings"

    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String(255))
    image = Column(String(255))
    price = Column(Float, default=0)
    number_of_items = Column(Integer, default=0)