from sqlalchemy.orm import Session

from app.crud.base import CRUDBase
from app.models.video import Video, video__video_tags, VideoTag
from app.schemas.video import VideoCreate, VideoUpdate

from typing import List, Tuple, Set


class CRUDVideo(CRUDBase[Video, VideoCreate, VideoUpdate]):

    def get_video_by_categories(self, db: Session, tags: Set[int], page: int, size: int) -> Tuple[int, List[Video]]:
        """
        Return list of videos by categories.
        """
        # if tags:

        #     allvids = db.query(Video).all()
        #     filtVids = [vid for vid in allvids if {tag.id for tag in vid.tags}.intersection(tags)]
        #     return filtVids

        query = db.query(Video)
        if tags:
            # query = [vid for vid in query.all(
            # ) if {tag.id for tag in vid.tags}.intersection(tags)]
            
            query = query.join(video__video_tags).join(VideoTag).filter(
                VideoTag.id.in_(tags)
            )
        total = query.count()

        return total, query.limit(size).offset((page - 1) * size).all()


video = CRUDVideo(Video)
