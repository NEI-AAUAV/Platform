from sqlalchemy import Date, String, Text, Column

from app.db.base_class import Base


class History(Base):
    __tablename__ = "history"

    moment = Column(Date, primary_key=True)
    title = Column(String(120))
    body = Column(Text)
    image = Column(String(255))
