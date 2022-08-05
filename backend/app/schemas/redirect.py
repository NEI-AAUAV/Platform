from pydantic import BaseModel, HttpUrl

from typing import Optional
from typing_extensions import Annotated

class RedirectBase(BaseModel):
    ...