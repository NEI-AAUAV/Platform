from typing import Annotated
from pydantic import StringConstraints


# [0-9] rather than \d: pydantic matches Unicode digits, the database CHECK
# constraints do not.
MandateStr = Annotated[str, StringConstraints(pattern=r"^[0-9]{4}(/[0-9]{2})?$")]

# Mirrors String(120) and the non-blank CHECK constraints on the member tables.
ShortNameStr = Annotated[
    str, StringConstraints(strip_whitespace=True, min_length=1, max_length=120)
]
