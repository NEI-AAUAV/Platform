
from pydantic import BaseModel, constr


class CourseBase(BaseModel):
    short: constr(max_length=8)
    name: str

