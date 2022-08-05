from sqlalchemy import Column, String, Integer, ForeignKey
from sqlalchemy.orm import relationship

from app.core.config import settings
from app.db.base_class import Base


class NotesThanks(Base):
    __tablename__ = "notes_thanks"

    id = Column(Integer, primary_key=True, autoincrement=True)
    author_id = Column(Integer, ForeignKey(settings.SCHEMA_NAME + ".users.id", name="fk_author_id"), index=True)
    notesPersonalPage = Column(String(255))
    
    author = relationship("Users", foreign_keys=[author_id])
