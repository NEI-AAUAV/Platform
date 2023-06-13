from pydantic import PositiveInt
from app.models import BaseDocument


LIMITS_ID = "LIMITS"


class Limits(BaseDocument):
    maxRegistrations: PositiveInt
