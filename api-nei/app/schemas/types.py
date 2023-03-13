from pydantic import constr


MandateStr = constr(regex=r"^\d{4}(\/\d{2})?$")
