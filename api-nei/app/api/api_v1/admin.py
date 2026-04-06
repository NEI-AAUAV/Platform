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
from sqlalchemy.orm import Session
import httpx

from app.api import deps
from app.api.api_v1.auth import _deps as auth
from app.core.config import settings
from app.models.user import User
from app.schemas.user import ScopeEnum

DbSession = Annotated[Session, Depends(deps.get_db)]
AdminAuth = Annotated[auth.AuthData, Security(auth.verify_token, scopes=[ScopeEnum.ADMIN])]


def _validate_uuid(value: str, name: str) -> str:
    """Raise 422 if value is not a valid UUID, preventing path traversal."""
    try:
        return str(uuid.UUID(value))
    except ValueError:
        raise HTTPException(status.HTTP_422_UNPROCESSABLE_ENTITY, f"{name} must be a valid UUID")


router = APIRouter()


def _authentik_headers() -> dict:
    if not settings.AUTHENTIK_TOKEN:
        raise HTTPException(
            status.HTTP_503_SERVICE_UNAVAILABLE,
            "Authentik admin API is not configured (AUTHENTIK_TOKEN missing)",
        )
    return {"Authorization": f"Bearer {settings.AUTHENTIK_TOKEN}"}


async def _authentik_user_pk(authentik_sub: str) -> int:
    """Resolve an Authentik user PK (int) from their UUID (authentik_sub)."""
    url = f"{settings.AUTHENTIK_URL}/api/v3/core/users/"
    verify_ssl = settings.PRODUCTION
    async with httpx.AsyncClient(verify=verify_ssl) as client:
        resp = await client.get(
            url,
            params={"uuid": authentik_sub},
            headers=_authentik_headers(),
        )
        resp.raise_for_status()
        results = resp.json().get("results", [])
        if not results:
            raise HTTPException(
                status.HTTP_404_NOT_FOUND,
                f"Authentik user with sub {authentik_sub!r} not found",
            )
        return results[0]["pk"]


@router.get("/authentik/groups")
async def list_authentik_groups(
    _: auth.AuthData = Security(auth.verify_token, scopes=[ScopeEnum.ADMIN]),
):
    """List all Authentik groups with the authentik_sub of each member."""
    if not settings.AUTHENTIK_TOKEN:
        raise HTTPException(
            status.HTTP_503_SERVICE_UNAVAILABLE,
            "Authentik admin API is not configured",
        )

    url = f"{settings.AUTHENTIK_URL}/api/v3/core/groups/"
    verify_ssl = settings.PRODUCTION
    groups = []
    params = {"include_users": "true", "page_size": 100}

    async with httpx.AsyncClient(verify=verify_ssl) as client:
        while url:
            resp = await client.get(url, params=params, headers=_authentik_headers())
            resp.raise_for_status()
            data = resp.json()
            for g in data.get("results", []):
                groups.append(
                    {
                        "pk": g["pk"],
                        "name": g["name"],
                        "member_subs": [u["uid"] for u in g.get("users_obj", [])],
                    }
                )
            url = data.get("pagination", {}).get("next") or None
            params = {}  # next URL already has params

    return groups


@router.post("/authentik/groups/{group_pk}/members/{user_id}", status_code=204)
async def add_group_member(
    group_pk: str,
    user_id: int,
    db: DbSession,
    _: AdminAuth,
):
    """Add a platform user to an Authentik group."""
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "User not found")
    if not user.authentik_sub:
        raise HTTPException(
            status.HTTP_400_BAD_REQUEST,
            "User has not logged in via Authentik yet (no authentik_sub)",
        )

    safe_group_pk = _validate_uuid(group_pk, "group_pk")
    authentik_pk = await _authentik_user_pk(user.authentik_sub)
    url = f"{settings.AUTHENTIK_URL}/api/v3/core/groups/{safe_group_pk}/add_user/"
    verify_ssl = settings.PRODUCTION
    async with httpx.AsyncClient(verify=verify_ssl) as client:
        resp = await client.post(
            url,
            json={"pk": authentik_pk},
            headers=_authentik_headers(),
        )
        if resp.status_code not in (200, 204):
            raise HTTPException(
                status.HTTP_502_BAD_GATEWAY,
                f"Authentik returned {resp.status_code}: {resp.text}",
            )


@router.delete("/authentik/groups/{group_pk}/members/{user_id}", status_code=204)
async def remove_group_member(
    group_pk: str,
    user_id: int,
    db: DbSession,
    _: AdminAuth,
):
    """Remove a platform user from an Authentik group."""
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "User not found")
    if not user.authentik_sub:
        raise HTTPException(
            status.HTTP_400_BAD_REQUEST,
            "User has no authentik_sub",
        )

    safe_group_pk = _validate_uuid(group_pk, "group_pk")
    authentik_pk = await _authentik_user_pk(user.authentik_sub)
    url = f"{settings.AUTHENTIK_URL}/api/v3/core/groups/{safe_group_pk}/remove_user/"
    verify_ssl = settings.PRODUCTION
    async with httpx.AsyncClient(verify=verify_ssl) as client:
        resp = await client.post(
            url,
            json={"pk": authentik_pk},
            headers=_authentik_headers(),
        )
        if resp.status_code not in (200, 204):
            raise HTTPException(
                status.HTTP_502_BAD_GATEWAY,
                f"Authentik returned {resp.status_code}: {resp.text}",
            )
