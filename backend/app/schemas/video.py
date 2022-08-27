from backend.app.db.base_class import Base
from pydantic import BaseModel

from datetime import datetime
from typing import Optional
from typing_extensions import Annotated

class VideoBase(Base):
    """tag:
    ytld:
    title:
    subtitle:
    image:
    created:
    playlist:"""