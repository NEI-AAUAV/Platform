"""
Admin endpoints for managing Authentik groups.

These endpoints proxy Authentik's REST API so the platform admin UI can
manage group membership without exposing the Authentik token to the browser.

Endpoints
---------
GET  /admin/authentik/groups
    Returns all Authentik groups with the authentik_sub of each member.

POST /admin/authentik/groups/{group_pk}/members/{user_id}
    Add a platform user (by platform ID) to an Authentik group.

DELETE /admin/authentik/groups/{group_pk}/members/{user_id}
    Remove a platform user from an Authentik group.
"""

import uuid
from typing import Annotated

from fastapi import APIRouter, Depends, HTTPException, Security, status
from fastapi.concurrency import run_in_threadpool
from sqlalchemy.orm import Session
import logging
from sqlalchemy import select

from app.api import deps
from app.api.deps import DbSession
from app.api.api_v1.auth import _deps as auth
from app.integrations.authentik import AuthentikError, authentik_client
from app.models.user import User
from app.schemas.user import ScopeEnum

AdminAuth = Annotated[auth.AuthData, Security(auth.verify_token, scopes=[ScopeEnum.ADMIN])]
logger = logging.getLogger(__name__)


def _validate_uuid(value: str, name: str) -> str:
    """Raise 422 if value is not a valid UUID, preventing path traversal."""
    try:
        return str(uuid.UUID(value))
    except ValueError:
        raise HTTPException(
            status.HTTP_422_UNPROCESSABLE_CONTENT,
            f"{name} must be a valid UUID",
        )


router = APIRouter()


def _upstream_error(exc: AuthentikError) -> HTTPException:
    logger.warning("Authentik admin request failed: %s", exc.public_detail)
    return HTTPException(exc.status_code, exc.public_detail)


@router.get("/authentik/groups")
async def list_authentik_groups(
    _: auth.AuthData = Security(auth.verify_token, scopes=[ScopeEnum.ADMIN]),
):
    """List all Authentik groups with the authentik_sub of each member."""
    try:
        return await authentik_client.list_groups()
    except AuthentikError as exc:
        raise _upstream_error(exc) from exc


@router.post("/authentik/groups/{group_pk}/members/{user_id}", status_code=204)
async def add_group_member(
    group_pk: str,
    user_id: int,
    db: DbSession,
    _: AdminAuth,
):
    """Add a platform user to an Authentik group."""
    user = await run_in_threadpool(db.scalar, select(User).where(User.id == user_id))
    if not user:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "User not found")
    if not user.authentik_sub:
        raise HTTPException(
            status.HTTP_400_BAD_REQUEST,
            "User has not logged in via Authentik yet (no authentik_sub)",
        )

    safe_group_pk = _validate_uuid(group_pk, "group_pk")
    try:
        authentik_pk = await authentik_client.find_user_pk(user.authentik_sub)
        await authentik_client.set_group_membership(
            safe_group_pk, authentik_pk, add=True
        )
    except AuthentikError as exc:
        raise _upstream_error(exc) from exc


@router.delete("/authentik/groups/{group_pk}/members/{user_id}", status_code=204)
async def remove_group_member(
    group_pk: str,
    user_id: int,
    db: DbSession,
    _: AdminAuth,
):
    """Remove a platform user from an Authentik group."""
    user = await run_in_threadpool(db.scalar, select(User).where(User.id == user_id))
    if not user:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "User not found")
    if not user.authentik_sub:
        raise HTTPException(
            status.HTTP_400_BAD_REQUEST,
            "User has no authentik_sub",
        )

    safe_group_pk = _validate_uuid(group_pk, "group_pk")
    try:
        authentik_pk = await authentik_client.find_user_pk(user.authentik_sub)
        await authentik_client.set_group_membership(
            safe_group_pk, authentik_pk, add=False
        )
    except AuthentikError as exc:
        raise _upstream_error(exc) from exc
