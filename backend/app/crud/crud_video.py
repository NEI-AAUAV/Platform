from sqlalchemy.orm import Session

from app.crud.base import CRUDBase
from app.models.video import Video
from app.schemas.video import VideoInDB, VideoCreate, VideoUpdate

from typing import List


class CRUDVideo(CRUDBase[Video, VideoCreate, VideoUpdate]):

    def get_video_by_id(self, db: Session, id: int) -> VideoInDB:
        """
        Return video by id.
        """
        return db.query(Video).filter(Video.id == id).first()

    def get_videos_by_categories(self, db: Session, categories: set[int], page: int, size: int) -> List[VideoInDB]:
        """
        Return list of videos by categories.
        """
        if categories:
            return db.query(Video).filter(Video.tag_id.contains(categories)).\
            limit(size).offset((page - 1 ) * size).all()
        else:
            return db.query(Video).\
                limit(size).offset((page - 1) * size).all()

video = CRUDVideo(Video)
