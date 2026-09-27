from datetime import datetime, timezone
from typing import Any, Optional

from sqlalchemy import func, select
from sqlalchemy.orm import Session

from app.models.admin_activity import AdminActivity
from app.models.user import User


def _full_name(name: str, surname: str) -> str:
    return f"{name} {surname}".strip()


class CRUDAdminActivity:
    def record(
        self,
        db: Session,
        *,
        actor: Any,
        action: str,
        target: Optional[User] = None,
        detail: Optional[dict[str, Any]] = None,
    ) -> None:
        """`actor` is the acting admin's AuthData (id and name come from the token)."""
        db.add(
            AdminActivity(
                created_at=datetime.now(timezone.utc),
                actor_id=actor.sub,
                actor_name=_full_name(actor.name, actor.surname),
                action=action,
                target_user_id=target.id if target else None,
                target_name=_full_name(target.name, target.surname) if target else None,
                detail=detail,
            )
        )

    def list_recent(
        self, db: Session, *, offset: int, limit: int
    ) -> tuple[list[AdminActivity], int]:
        items = list(
            db.scalars(
                select(AdminActivity)
                .order_by(AdminActivity.created_at.desc(), AdminActivity.id.desc())
                .offset(offset)
                .limit(limit)
            )
        )
        total = db.scalar(select(func.count(AdminActivity.id))) or 0
        return items, total


admin_activity = CRUDAdminActivity()
