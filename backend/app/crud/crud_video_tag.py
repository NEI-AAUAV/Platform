from pydantic import BaseModel
from app.crud.base import CRUDBase
from app.models.video_tag import VideoTag

class CRUDVideoTag(CRUDBase[VideoTag, BaseModel, BaseModel]):
    ...


videotag = CRUDVideoTag(VideoTag)
