from sqlalchemy import Column, String, Integer, ForeignKey
from sqlalchemy.orm import relationship

from app.core.config import settings
from app.db.base_class import Base


class NoteThank(Base):
    id = Column(Integer, primary_key=True, autoincrement=True)
    author_id = Column(
        Integer,
        ForeignKey(settings.SCHEMA_NAME + ".user.id", name="fk_author_id"),
        index=True)
    note_personal_page = Column(String(256))

    author = relationship("User", foreign_keys=[author_id])
