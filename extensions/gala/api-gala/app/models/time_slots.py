from datetime import datetime
from app.models import BaseDocument


TIME_SLOTS_ID = "TIME_SLOTS"


class TimeSlots(BaseDocument):
    votesStart: datetime
    votesEnd: datetime
    tablesStart: datetime
    tablesEnd: datetime
