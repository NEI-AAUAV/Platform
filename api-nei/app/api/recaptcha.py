import httpx

from fastapi import HTTPException, status

from app.core.logging import logger
from app.core.config import settings

if settings.RECAPTCHA_ENABLED:
    logger.info("reCaptcha is enabled")
else:
    logger.warning("reCaptcha is disabled")


# reCaptcha requires a larger timeout because of it's slow connect
_timeout = httpx.Timeout(10.0, connect=30.0)


async def verify_reCaptcha(token: str | None) -> float:
    """Validates that the reCaptcha token is valid and returns the response score

    **Parameters**
    * `token`: The user's reCaptcha

    **Returns**
    The reCaptcha score associated with the token
    """
    if not settings.RECAPTCHA_ENABLED:
        return 1.0

    async with httpx.AsyncClient(timeout=_timeout) as client:
        response = await client.post(
            settings.RECAPTCHA_VERIFY_URL,
            data={"secret": settings.RECAPTCHA_SECRET_KEY, "response": token},
        )

    data = response.json()

    if not data["success"]:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Invalid recaptcha token",
            headers={"WWW-Authenticate": "reCaptcha"},
        )

    return data["score"]
