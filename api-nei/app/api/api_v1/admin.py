"""
Admin endpoints for managing Authentik groups.

These endpoints proxy Authentik's REST API so the platform admin UI can
manage group membership without exposing the Authentik token to the browser.

Endpoints
---------
GET  /admin/system
    Deployed commit, database migration state, enabled extensions and which
    optional integrations are switched on.

GET  /admin/activity
    What admins changed, newest first.

POST /admin/users/{user_id}/sign-out
    End every session of a user so they can't refresh their access token.

GET  /admin/cms
    Where the content CMS (Directus) lives.

GET  /admin/authentik/status
    Whether Authentik handles sign-in and group management, and where its
    admin UI lives.

GET  /admin/authentik/groups
    Returns the Authentik groups that grant a platform or CMS role, with the
    role and the authentik_sub of each member. Other groups (Authentik's own
    admin groups included) are only managed in Authentik.

POST /admin/authentik/groups/{group_pk}/members/{user_id}
    Add a platform user (by platform ID) to an Authentik group.

DELETE /admin/authentik/groups/{group_pk}/members/{user_id}
    Remove a platform user from an Authentik group.
"""

import uuid
from datetime import datetime
from typing import Annotated, Any, Optional

from alembic.config import Config
from alembic.script import ScriptDirectory
from fastapi import APIRouter, Depends, HTTPException, Query, Security, status
from fastapi.concurrency import run_in_threadpool
from pydantic import BaseModel, ConfigDict
from sqlalchemy.orm import Session
import logging
from sqlalchemy import delete, select, text

from app import crud
from app.api import deps
from app.api.deps import DbSession
from app.api.api_v1.auth import _deps as auth
from app.core.config import settings
from app.core.extension_scopes import _get_enabled_extensions
from app.integrations.authentik import AuthentikError, authentik_client, group_role_name
from app.models.device_login import DeviceLogin
from app.models.user import User
from app.utils import ROOT_DIR
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


# Groups this page may change: every platform role except the implicit
# "default", plus the CMS editor role (see Infrastructure's Directus role mapping).
MANAGED_ROLES = frozenset(
    {scope.value for scope in ScopeEnum if scope is not ScopeEnum.DEFAULT} | {"cms-manager"}
)


def _managed_role(group_name: str) -> str | None:
    role = group_role_name(group_name)
    return role if role in MANAGED_ROLES else None


async def _require_managed_group(group_pk: str) -> str:
    role = _managed_role(await authentik_client.get_group_name(group_pk))
    if role is None:
        raise HTTPException(
            status.HTTP_403_FORBIDDEN,
            "This group does not grant a platform role; manage it in Authentik",
        )
    return role


async def _still_granted(role: str, authentik_sub: str) -> bool:
    """Whether another group (e.g. "admin" vs "nei-admin") still grants `role`."""
    return any(
        _managed_role(group["name"]) == role and authentik_sub in group["member_subs"]
        for group in await authentik_client.list_groups()
    )


def _upstream_error(exc: AuthentikError) -> HTTPException:
    logger.warning("Authentik admin request failed: %s", exc.public_detail)
    return HTTPException(exc.status_code, exc.public_detail)


class CmsInfo(BaseModel):
    app_url: str


@router.get("/cms", response_model=CmsInfo)
def cms_info(_: AdminAuth) -> CmsInfo:
    """Link to the Directus app, which owns editing of CMS-managed content."""
    return CmsInfo(app_url=f"{settings.DIRECTUS_PUBLIC_URL}admin/")


class AuthentikStatus(BaseModel):
    oidc_enabled: bool
    groups_managed: bool
    admin_url: str


@router.get("/authentik/status", response_model=AuthentikStatus)
def authentik_status(_: AdminAuth) -> AuthentikStatus:
    """Report how Authentik is wired up, without exposing its token."""
    return AuthentikStatus(
        oidc_enabled=settings.OIDC_ENABLED,
        groups_managed=bool(settings.AUTHENTIK_TOKEN),
        admin_url=f"{settings.AUTHENTIK_URL.rstrip('/')}/if/admin/",
    )


@router.get("/authentik/groups")
async def list_authentik_groups(
    _: auth.AuthData = Security(auth.verify_token, scopes=[ScopeEnum.ADMIN]),
):
    """List the Authentik groups that grant a platform or CMS role."""
    try:
        groups = await authentik_client.list_groups()
    except AuthentikError as exc:
        raise _upstream_error(exc) from exc
    return [
        {**group, "role": role}
        for group in groups
        if (role := _managed_role(group["name"])) is not None
    ]


@router.post("/authentik/groups/{group_pk}/members/{user_id}", status_code=204)
async def add_group_member(
    group_pk: str,
    user_id: int,
    db: DbSession,
    admin: AdminAuth,
):
    """Add a platform user to an Authentik group.

    The new role reaches the platform at the user's next sign-in.
    """
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
        role = await _require_managed_group(safe_group_pk)
        authentik_pk = await authentik_client.find_user_pk(user.authentik_sub)
        await authentik_client.set_group_membership(
            safe_group_pk, authentik_pk, add=True
        )
    except AuthentikError as exc:
        raise _upstream_error(exc) from exc

    crud.admin_activity.record(
        db, actor=admin, action="role.add", target=user, detail={"role": role}
    )


@router.delete("/authentik/groups/{group_pk}/members/{user_id}", status_code=204)
async def remove_group_member(
    group_pk: str,
    user_id: int,
    db: DbSession,
    admin: AdminAuth,
):
    """Remove a platform user from an Authentik group.

    The role is also dropped from the stored scopes straight away, unless
    another group still grants it, so a session refresh can't reissue it.
    """
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
        role = await _require_managed_group(safe_group_pk)
        authentik_pk = await authentik_client.find_user_pk(user.authentik_sub)
        await authentik_client.set_group_membership(
            safe_group_pk, authentik_pk, add=False
        )
        still_granted = await _still_granted(role, user.authentik_sub)
    except AuthentikError as exc:
        raise _upstream_error(exc) from exc

    if not still_granted and role in (user.scopes or []):
        user.scopes = [scope for scope in user.scopes if scope != role]
    crud.admin_activity.record(
        db, actor=admin, action="role.remove", target=user, detail={"role": role}
    )


@router.post("/users/{user_id}/sign-out")
def sign_out_everywhere(user_id: int, db: DbSession, admin: AdminAuth) -> dict[str, int]:
    """End every session of a user.

    Their current access token stays valid until it expires (ACCESS_TOKEN_EXPIRE),
    but it can no longer be refreshed.
    """
    user = db.scalar(select(User).where(User.id == user_id))
    if not user:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "User not found")
    ended = db.execute(delete(DeviceLogin).where(DeviceLogin.user_id == user_id)).rowcount
    crud.admin_activity.record(
        db, actor=admin, action="sessions.revoke", target=user, detail={"sessions": ended}
    )
    return {"sessions_ended": ended}


class ActivityEntry(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: int
    created_at: datetime
    action: str
    actor_id: Optional[int]
    actor_name: Optional[str]
    target_user_id: Optional[int]
    target_name: Optional[str]
    detail: Optional[dict[str, Any]]


class ActivityPage(BaseModel):
    items: list[ActivityEntry]
    total: int


@router.get("/activity", response_model=ActivityPage)
def list_activity(
    db: DbSession,
    _: AdminAuth,
    offset: int = Query(0, ge=0),
    limit: int = Query(50, ge=1, le=200),
) -> ActivityPage:
    """What admins changed, newest first."""
    items, total = crud.admin_activity.list_recent(db, offset=offset, limit=limit)
    return ActivityPage(
        items=[ActivityEntry.model_validate(item) for item in items], total=total
    )


class DatabaseStatus(BaseModel):
    current: Optional[str]
    expected: Optional[str]


class Integrations(BaseModel):
    oidc: bool
    authentik_api: bool
    email: bool
    recaptcha: bool


class SystemStatus(BaseModel):
    commit: Optional[str]
    production: bool
    database: DatabaseStatus
    extensions: Optional[list[str]]
    integrations: Integrations


def _expected_migration() -> Optional[str]:
    try:
        heads = ScriptDirectory.from_config(Config(f"{ROOT_DIR}/alembic.ini")).get_heads()
    except Exception:
        logger.exception("Could not read the Alembic migration head")
        return None
    return ", ".join(sorted(heads))


def _current_migration(db: Any) -> Optional[str]:
    try:
        rows = db.execute(
            text(f"SELECT version_num FROM {settings.SCHEMA_NAME}.alembic_version")
        ).scalars().all()
    except Exception:
        logger.exception("Could not read the database migration version")
        return None
    return ", ".join(sorted(rows)) or None


@router.get("/system", response_model=SystemStatus)
def system_status(db: DbSession, _: AdminAuth) -> SystemStatus:
    """What is deployed and which optional integrations are switched on."""
    enabled = _get_enabled_extensions()
    return SystemStatus(
        commit=settings.GIT_COMMIT or None,
        production=settings.PRODUCTION,
        database=DatabaseStatus(current=_current_migration(db), expected=_expected_migration()),
        extensions=sorted(enabled) if enabled is not None else None,
        integrations=Integrations(
            oidc=settings.OIDC_ENABLED,
            authentik_api=bool(settings.AUTHENTIK_TOKEN),
            email=settings.EMAIL_ENABLED,
            recaptcha=settings.RECAPTCHA_ENABLED,
        ),
    )
