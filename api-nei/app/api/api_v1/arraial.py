from fastapi import APIRouter, Depends, HTTPException, Security, Query
from sqlalchemy.orm import Session
from sqlalchemy import text
from typing import Any, List, Optional, Tuple
from pydantic import BaseModel
from datetime import datetime, timezone

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
    user_email: Optional[str] = None
    rolled_back: bool = False
    timestamp: Optional[datetime] = None


class ArraialLogResponse(BaseModel):
    items: List[ArraialLogEntry]
    next_offset: Optional[int] = None


class ArraialConfig(BaseModel):
    enabled: bool


# Mock data for now - you can replace this with database calls later
_arraial_points = [
    {"nucleo": "NEEETA", "value": 0},
    {"nucleo": "NEECT", "value": 0},
    {"nucleo": "NEI", "value": 0}
]

# In-memory change log (newest first)
_arraial_log: List[ArraialLogEntry] = []
_next_log_id: int = 1


SETTING_TABLE_SQL = """
CREATE TABLE IF NOT EXISTS app_setting (
    key TEXT PRIMARY KEY,
    value TEXT NOT NULL
);
"""


def _get_config_enabled(db: Session) -> bool:
    db.execute(text(SETTING_TABLE_SQL))
    row = db.execute(text("SELECT value FROM app_setting WHERE key = 'arraial_enabled'"))\
        .first()
    if row is None:
        db.execute(text("INSERT INTO app_setting(key, value) VALUES ('arraial_enabled', 'true') ON CONFLICT (key) DO NOTHING"))
        db.commit()
        return True
    return (row[0] or "").lower() == "true"


def _set_config_enabled(db: Session, enabled: bool) -> None:
    db.execute(text(SETTING_TABLE_SQL))
    db.execute(
        text(
            """
            INSERT INTO app_setting(key, value) VALUES ('arraial_enabled', :val)
            ON CONFLICT (key) DO UPDATE SET value = EXCLUDED.value
            """
        ),
        {"val": "true" if enabled else "false"},
    )
    db.commit()


def _find_points(nucleo: str) -> dict:
    for points in _arraial_points:
        if points["nucleo"] == nucleo:
            return points
    return None


@router.get("/config", status_code=200, response_model=ArraialConfig)
def get_arraial_config(*, db: Session = Depends(deps.get_db)) -> Any:
    return {"enabled": _get_config_enabled(db)}


@router.put("/config", status_code=200, response_model=ArraialConfig)
async def update_arraial_config(
    *,
    cfg: ArraialConfig,
    db: Session = Depends(deps.get_db),
    _=Security(auth.verify_token, scopes=[ScopeEnum.ADMIN]),
) -> Any:
    _set_config_enabled(db, cfg.enabled)
    await arraial_ws_manager.broadcast(
        connection_type=ArraialConnectionType.GENERAL,
        message={"topic": "ARRAIAL_CONFIG", "enabled": cfg.enabled},
    )
    return cfg


@router.get("/points", status_code=200, response_model=List[ArraialPoints])
def get_arraial_points(
    *,
    db: Session = Depends(deps.get_db),
    _=Depends(deps.short_cache),
) -> Any:
    return _arraial_points


@router.put("/points", status_code=200, response_model=List[ArraialPoints])
async def update_arraial_points(
    *,
    points_update: ArraialPointsUpdate,
    db: Session = Depends(deps.get_db),
    auth_data: auth.AuthData = Security(auth.verify_token, scopes=[ScopeEnum.MANAGER_ARRAIAL]),
) -> Any:
    points = _find_points(points_update.nucleo)
    if points is None:
        raise HTTPException(status_code=404, detail="Núcleo not found")

    global _next_log_id
    prev_value = points["value"]
    points["value"] = prev_value + points_update.pointIncrement

    entry = ArraialLogEntry(
        id=_next_log_id,
        nucleo=points_update.nucleo,
        delta=points_update.pointIncrement,
        prev_value=prev_value,
        new_value=points["value"],
        user_id=int(auth_data.sub) if getattr(auth_data, "sub", None) else None,
        user_email=getattr(auth_data, "email", None),
        rolled_back=False,
        timestamp=datetime.now(timezone.utc),
    )
    _arraial_log.insert(0, entry)
    _next_log_id += 1

    await arraial_ws_manager.broadcast(
        connection_type=ArraialConnectionType.GENERAL,
        message={"topic": "ARRAIAL_POINTS", "points": _arraial_points},
    )

    return _arraial_points


@router.get("/log", status_code=200, response_model=ArraialLogResponse)
async def get_arraial_log(
    *,
    offset: int = Query(0, ge=0),
    limit: int = Query(25, ge=1, le=100),
    user_id: Optional[int] = None,
    nucleo: Optional[str] = None,
    rolled_back: Optional[bool] = None,
    since: Optional[datetime] = None,
    until: Optional[datetime] = None,
    _=Security(auth.verify_token, scopes=[ScopeEnum.MANAGER_ARRAIAL]),
) -> Any:
    items = _arraial_log

    if user_id is not None:
        items = [e for e in items if e.user_id == user_id]
    if nucleo is not None:
        items = [e for e in items if e.nucleo == nucleo]
    if rolled_back is not None:
        items = [e for e in items if bool(e.rolled_back) == rolled_back]
    if since is not None:
        items = [e for e in items if e.timestamp and e.timestamp >= since]
    if until is not None:
        items = [e for e in items if e.timestamp and e.timestamp <= until]

    slice_ = items[offset : offset + limit]
    next_offset = offset + limit if offset + limit < len(items) else None
    return {"items": slice_, "next_offset": next_offset}


@router.post("/rollback/{log_id}", status_code=200, response_model=List[ArraialPoints])
async def rollback_log(
    *,
    log_id: int,
    _=Security(auth.verify_token, scopes=[ScopeEnum.MANAGER_ARRAIAL]),
) -> Any:
    target = None
    for entry in _arraial_log:
        if entry.id == log_id:
            target = entry
            break
    if target is None:
        raise HTTPException(status_code=404, detail="Log entry not found")
    if target.rolled_back:
        return _arraial_points

    points = _find_points(target.nucleo)
    if points is None:
        raise HTTPException(status_code=404, detail="Núcleo not found")

    points["value"] -= target.delta
    target.rolled_back = True

    await arraial_ws_manager.broadcast(
        connection_type=ArraialConnectionType.GENERAL,
        message={"topic": "ARRAIAL_POINTS", "points": _arraial_points},
    )

    return _arraial_points
