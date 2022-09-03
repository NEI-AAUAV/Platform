from sqlalchemy.orm import Session

from app.crud.base import CRUDBase
from app.models.video import Video
from app.schemas.video import VideoInDB, VideoCreate, VideoUpdate
from app.core.config import Settings
from typing import List


class CRUDVideo(CRUDBase[Video, VideoCreate, VideoUpdate]):

    def get_video_by_id(self, db: Session, id: int) -> List[VideoInDB]:
        """
        Return video by id.
        """
        return db.query(Video).filter(Video.id == id).first()

    def get_videos_by_categories(self, db: Session, categories: list[int], pagenumber: int) -> List[VideoInDB]:
        """
        Return list of videos by categories.
        """
        return db.query(Video).\
        filter(bool(set(Video.tag_id) & set(categories))).\
        limit(Settings.PAGESIZE).offset((pagenumber - 1) * Settings.PAGESIZE).all()

video = CRUDVideo(Video)
