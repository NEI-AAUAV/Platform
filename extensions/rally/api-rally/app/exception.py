from fastapi import HTTPException


class APIException(HTTPException):
    """Light wrapper around HTTPException that allows specifying defaults via class property"""

    status_code = 400
    headers = None

    def __init__(self, *args, **kwargs):
        if "status_code" not in kwargs:
            kwargs["status_code"] = self.status_code
        if "detail" not in kwargs:
            kwargs["detail"] = self.detail
        if "headers" not in kwargs:
            kwargs["headers"] = self.headers
        super().__init__(*args, **kwargs)


class NotFoundException(APIException):
    status_code = 404
    detail = "Result Not Found"


class ImageFormatException(APIException):
    status_code = 400
    detail = "Invalid Image Format"


class RestrictionException(APIException):
    status_code = 400
    detail = "Restriction Not Respected"


class NotImplementedException(APIException):
    status_code = 501
    detail = "Not Implemented"


class CardNotActiveException(APIException):
    status_code = 400
    detail = "Card Not Attributed"


class CardEffectException(APIException):
    status_code = 400
    detail = "Card Not Applicable"
