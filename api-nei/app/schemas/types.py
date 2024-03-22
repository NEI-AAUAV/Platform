from typing import Annotated
from pydantic import StringConstraints


MandateStr = Annotated[str, StringConstraints(pattern=r"^\d{4}(\/\d{2})?$")]
