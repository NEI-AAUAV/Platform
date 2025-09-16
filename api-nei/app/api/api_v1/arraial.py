from fastapi import APIRouter, Depends, HTTPException, Security
from sqlalchemy.orm import Session
from typing import Any, List, Optional
from pydantic import BaseModel

from app import crud
from app.api import deps
from app.api.api_v1 import auth
from app.schemas.user.user import ScopeEnum
from app.api.api_v1.arraial_ws import arraial_ws_manager, ArraialConnectionType

router = APIRouter()


class ArraialPoints(BaseModel):
    nucleo: str
    value: int


class ArraialPointsUpdate(BaseModel):
    nucleo: str
    pointIncrement: int


class ArraialLogEntry(BaseModel):
    id: int
    nucleo: str
    delta: int
    prev_value: int
    new_value: int
    user_id: Optional[int] = None
    rolled_back: bool = False


# Mock data for now - you can replace this with database calls later
_arraial_points = [
    {"nucleo": "NEEETA", "value": 0},
    {"nucleo": "NEECT", "value": 0},
    {"nucleo": "NEI", "value": 0}
]

# In-memory change log
_arraial_log: List[ArraialLogEntry] = []
_next_log_id: int = 1


def _find_points(nucleo: str) -> dict:
    for points in _arraial_points:
        if points["nucleo"] == nucleo:
            return points
    return None


@router.get("/points", status_code=200, response_model=List[ArraialPoints])
def get_arraial_points(
    *,
    db: Session = Depends(deps.get_db),
    _=Depends(deps.short_cache),
) -> Any:
    """
    Get current arraial points for all núcleos.
    """
    return _arraial_points


@router.put("/points", status_code=200, response_model=List[ArraialPoints])
async def update_arraial_points(
    *,
    points_update: ArraialPointsUpdate,
    db: Session = Depends(deps.get_db),
    auth_data: auth.AuthData = Security(auth.verify_token, scopes=[ScopeEnum.MANAGER_ARRAIAL]),
) -> Any:
    """
    Update arraial points for a specific team and record a log entry.
    """
    points = _find_points(points_update.nucleo)
    if points is None:
        raise HTTPException(status_code=404, detail="Núcleo not found")

    global _next_log_id
    prev_value = points["value"]
    points["value"] = prev_value + points_update.pointIncrement

    # Record log
    entry = ArraialLogEntry(
        id=_next_log_id,
        nucleo=points_update.nucleo,
        delta=points_update.pointIncrement,
        prev_value=prev_value,
        new_value=points["value"],
        user_id=int(auth_data.sub) if getattr(auth_data, "sub", None) else None,
    )
    _arraial_log.insert(0, entry)  # newest first
    _next_log_id += 1

    # Broadcast updated points to all connected clients
    await arraial_ws_manager.broadcast(
        connection_type=ArraialConnectionType.GENERAL,
        message={"topic": "ARRAIAL_POINTS", "points": _arraial_points},
    )

    return _arraial_points


@router.get("/log", status_code=200, response_model=List[ArraialLogEntry])
async def get_arraial_log(
    *,
    limit: int = 50,
    _=Security(auth.verify_token, scopes=[ScopeEnum.MANAGER_ARRAIAL]),
) -> Any:
    """
    Get recent arraial change log entries (newest first).
    """
    return _arraial_log[: max(0, min(limit, 200))]


@router.post("/rollback/{log_id}", status_code=200, response_model=List[ArraialPoints])
async def rollback_log(
    *,
    log_id: int,
    _=Security(auth.verify_token, scopes=[ScopeEnum.MANAGER_ARRAIAL]),
) -> Any:
    """
    Roll back a specific change by applying the inverse delta.
    Idempotent: if already rolled back, no-op.
    """
    # Locate log entry
    target = None
    for entry in _arraial_log:
        if entry.id == log_id:
            target = entry
            break
    if target is None:
        raise HTTPException(status_code=404, detail="Log entry not found")
    if target.rolled_back:
        return _arraial_points

    # Apply inverse delta
    points = _find_points(target.nucleo)
    if points is None:
        raise HTTPException(status_code=404, detail="Núcleo not found")

    points["value"] -= target.delta
    target.rolled_back = True

    # Broadcast updated points
    await arraial_ws_manager.broadcast(
        connection_type=ArraialConnectionType.GENERAL,
        message={"topic": "ARRAIAL_POINTS", "points": _arraial_points},
    )

    return _arraial_points
