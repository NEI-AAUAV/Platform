from sqlalchemy import Column, Integer, String, Text

from app.db.base_class import Base


class TacaUATeam(Base):
    __tablename__ = "tacaua_team"

    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String(50))
    image_url = Column(Text)
