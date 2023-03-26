from fastapi import APIRouter

from . import login, register, session, reset
from ._deps import verify_token

router = APIRouter()
router.include_router(login.router)
router.include_router(register.router)
router.include_router(session.router)
router.include_router(reset.router)

# This silences import not used errors for reexports
assert verify_token, "verify_token is imported to be re-exported"
