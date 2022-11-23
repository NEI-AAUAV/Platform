from sqlalchemy import String, Column, Integer, Boolean
from app.db.base_class import Base


class User(Base):
    __tablename__ = "user"

    id = Column(Integer, primary_key=True)
    name = Column(String)
    email = Column(String)
    is_staff = Column(Boolean)
    is_admin = Column(Boolean)
    