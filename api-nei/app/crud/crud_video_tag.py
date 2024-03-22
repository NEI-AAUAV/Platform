from app.crud.base import CRUDBase
from app.models.video import VideoTag
from app.schemas.video import VideoTagCreate, VideoTagUpdate


class CRUDVideoTag(CRUDBase[VideoTag, VideoTagCreate, VideoTagUpdate]):
    ...


videotag = CRUDVideoTag(VideoTag)
