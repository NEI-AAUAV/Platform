from app.crud.base import CRUDBase
from app.models.video_tag import VideoTag
from app.schemas.video_tag import VideoTagCreate, VideoTagUpdate


class CRUDVideoTag(CRUDBase[VideoTag, VideoTagCreate, VideoTagUpdate]):
    ...


videotag = CRUDVideoTag(VideoTag)
