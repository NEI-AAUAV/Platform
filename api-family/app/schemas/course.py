
from pydantic import BaseModel, constr


class CourseBase(BaseModel):
    initials: constr(max_length=16)
    name: str
    

