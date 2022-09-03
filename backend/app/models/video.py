from sqlalchemy import Column, SmallInteger, Integer, DateTime, ForeignKey, String, Text, ARRAY
from sqlalchemy.orm import relationship

from .video_tag import VideoTag
from app.api import deps
from fastapi import Depends
from sqlalchemy.orm import Session, validates

from app.core.config import settings
from app.db.base_class import Base

class Video(Base):
    __tablename__ = "video"

    id = Column(Integer, primary_key=True, autoincrement=True)
    tag_id = Column(ARRAY(Integer))
    ytld =  Column(String(255))
    title = Column(String(255))
    subtitle = Column(String(255))
    image = Column(Text)
    created = Column(DateTime, index=True)
    playlist = Column(SmallInteger)

    #tag = relationship("VideoTag", foreign_keys=[tag_id])

    @validates('tag_id')
    def validate_name(self, key, value, db: Session = Depends(deps.get_db)):
        print("HERE     HERE     HERE     HERE     HERE     HERE     HERE     HERE     HERE     HERE     HERE     ")
        print(self)
        print(key)
        print(value)
        if not value:
            return

        all_ids = [r.id for r in db.query(VideoTag.id).all()]
        non_existent_ids = [id for id in value if id not in all_ids]
        
        assert not non_existent_ids, "Non existent video tag"
        return value




