from fastapi import APIRouter

from . import login, register, session, reset, token, magic_link, scopes
from ._deps import verify_token, auth_responses, AuthData, GetAuthData, get_auth_data

router = APIRouter()
router.include_router(login.router)
router.include_router(register.router)
router.include_router(session.router)
router.include_router(reset.router)
router.include_router(token.router)
router.include_router(magic_link.router)
router.include_router(scopes.router)

# This silences import not used errors for reexports
assert verify_token, "verify_token is imported to be re-exported"
