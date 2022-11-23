from sqlalchemy.orm import Session

from app.crud.base import CRUDBase
from app.models.video import Video
from app.schemas.video import VideoCreate, VideoUpdate

from typing import List


class CRUDVideo(CRUDBase[Video, VideoCreate, VideoUpdate]):

    def get_videos_by_categories(self, db: Session, tags: set[int], page: int, size: int) -> List[Video]:
        """
        Return list of videos by categories.
        """
        if tags:
            
            allvids = db.query(Video).all()
            filtVids = [vid for vid in allvids if {tag.id for tag in vid.tags}.intersection(tags)]
            return filtVids
            
        else:
            return db.query(Video).\
                limit(size).offset((page - 1) * size).all()


video = CRUDVideo(Video)
