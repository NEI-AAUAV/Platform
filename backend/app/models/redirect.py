from sqlalchemy import Column, Integer, String, Text

from app.db.base_class import Base

class Redirect(Base):
    __tablename__ = "redirect"

    id = Column(Integer, primary_key=True, autoincrement=True)
    alias = Column(String(255))
    redirect = Column(Text)
