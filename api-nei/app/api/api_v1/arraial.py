from fastapi import APIRouter, Depends, HTTPException, Security, Query, Request
from sqlalchemy.orm import Session
from sqlalchemy import text
from typing import Any, List, Optional, Tuple
from pydantic import BaseModel, field_validator
from datetime import datetime, timezone, timedelta
from functools import lru_cache

from app import crud
from app.api import deps
from app.api.api_v1 import auth
from app.schemas.user.user import ScopeEnum
from app.api.api_v1.arraial_ws import arraial_ws_manager, ArraialConnectionType

router = APIRouter()

# Valid núcleos for the Arraial system
VALID_NUCLEOS = ["NEEETA", "NEECT", "NEI"]

# Arraial configuration constants
BOOST_DURATION_MINUTES = 10
BOOST_MULTIPLIER = 1.25
RATE_LIMIT_PER_MINUTE = 500  # Increased for 5 concurrent managers to mitigate race condition

# Simple in-memory rate limiting (for production, use Redis)
# Global in-memory rate limit store: {(user_id, endpoint, time_bucket): count}
_rate_limit_store = {}

def _cleanup_rate_limit_store(current_time: int, retention_minutes: int = 2):
    """Remove expired entries from the rate limit store to prevent memory leaks."""
    expired_keys = []
    min_time_bucket = current_time - retention_minutes
    for key in list(_rate_limit_store.keys()):
        # key = (user_id, endpoint, time_bucket)
        if key[2] < min_time_bucket:
            expired_keys.append(key)
    for key in expired_keys:
        del _rate_limit_store[key]

def _rate_limit_check(user_id: str, endpoint: str, current_time: int) -> bool:
    """Simple rate limiting: RATE_LIMIT_PER_MINUTE requests per minute per user per endpoint"""
    # Clean up old entries to prevent memory leaks
    _cleanup_rate_limit_store(current_time)
    
    key = (user_id, endpoint, current_time)
    count = _rate_limit_store.get(key, 0)
    limit = RATE_LIMIT_PER_MINUTE  # High enough for normal usage, catches abuse
    if count >= limit:
        return False
    _rate_limit_store[key] = count + 1
    return True

def _check_rate_limit(request: Request, auth_data: auth.AuthData, endpoint: str):
    """Check if user has exceeded rate limit"""
    user_id = str(auth_data.sub) if hasattr(auth_data, 'sub') else 'anonymous'
    current_time = int(datetime.now().timestamp() // 60)  # 1-minute buckets
    
    if not _rate_limit_check(user_id, endpoint, current_time):
        raise HTTPException(
            status_code=429,
            detail="Rate limit exceeded. Please try again later."
        )


class ArraialPoints(BaseModel):
    nucleo: str
    value: int


class ArraialPointsUpdate(BaseModel):
    nucleo: str
    pointIncrement: int
    
    @field_validator('nucleo')
    @classmethod
    def validate_nucleo(cls, v: str) -> str:
        if not v or len(v) > 20:
            raise ValueError('Núcleo must be between 1 and 20 characters')
        if v not in VALID_NUCLEOS:
            raise ValueError(f'Invalid núcleo. Must be one of: {", ".join(VALID_NUCLEOS)}')
        return v
    
    @field_validator('pointIncrement')
    @classmethod
    def validate_point_increment(cls, v: int) -> int:
        if v < -1000 or v > 1000:
            raise ValueError('Point increment must be between -1000 and 1000')
        return v


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
    event: Optional[str] = None  # e.g., "BOOST_ACTIVATED"


class ArraialLogResponse(BaseModel):
    items: List[ArraialLogEntry]
    next_offset: Optional[int] = None


class ArraialConfig(BaseModel):
    enabled: bool
    paused: bool = False
    boosts: Optional[dict] = None  # { nucleo: iso8601 or None }


# Mock data for now - you can replace this with database calls later
_arraial_points = [
    {"nucleo": "NEEETA", "value": 0},
    {"nucleo": "NEECT", "value": 0},
    {"nucleo": "NEI", "value": 0}
]

# In-memory change log (newest first)
_arraial_log: List[ArraialLogEntry] = []
_next_log_id: int = 1
_boost_ends: dict = {nucleo: None for nucleo in VALID_NUCLEOS}


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
        db.execute(text("INSERT INTO app_setting(key, value) VALUES ('arraial_enabled', 'false') ON CONFLICT (key) DO NOTHING"))
        db.commit()
        return False
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


def _get_config_paused(db: Session) -> bool:
    db.execute(text(SETTING_TABLE_SQL))
    row = db.execute(text("SELECT value FROM app_setting WHERE key = 'arraial_paused'"))\
        .first()
    if row is None:
        db.execute(text("INSERT INTO app_setting(key, value) VALUES ('arraial_paused', 'false') ON CONFLICT (key) DO NOTHING"))
        db.commit()
        return False
    return (row[0] or "").lower() == "true"


def _set_config_paused(db: Session, paused: bool) -> None:
    db.execute(text(SETTING_TABLE_SQL))
    db.execute(
        text(
            """
            INSERT INTO app_setting(key, value) VALUES ('arraial_paused', :val)
            ON CONFLICT (key) DO UPDATE SET value = EXCLUDED.value
            """
        ),
        {"val": "true" if paused else "false"},
    )
    db.commit()


def _get_boosts_response() -> dict:
    # returns { nucleo: iso8601 or None }
    result = {}
    now = datetime.now(timezone.utc)
    for n, end in _boost_ends.items():
        if end and end > now:
            result[n] = end.isoformat()
        else:
            result[n] = None
    return result


def _is_boost_active(nucleo: str) -> bool:
    end = _boost_ends.get(nucleo)
    return bool(end and end > datetime.now(timezone.utc))


def _find_points(nucleo: str) -> dict:
    for points in _arraial_points:
        if points["nucleo"] == nucleo:
            return points
    return None


@router.get("/config", status_code=200, response_model=ArraialConfig)
def get_arraial_config(*, db: Session = Depends(deps.get_db)) -> Any:
    return {"enabled": _get_config_enabled(db), "paused": _get_config_paused(db), "boosts": _get_boosts_response()}


@router.put("/config", status_code=200, response_model=ArraialConfig)
async def update_arraial_config(
    *,
    cfg: ArraialConfig,
    db: Session = Depends(deps.get_db),
    _=Security(auth.verify_token, scopes=[ScopeEnum.ADMIN]),
) -> Any:
    _set_config_enabled(db, cfg.enabled)
    _set_config_paused(db, cfg.paused)
    payload = {"topic": "ARRAIAL_CONFIG", "enabled": cfg.enabled, "paused": cfg.paused}
    await arraial_ws_manager.broadcast(
        connection_type=ArraialConnectionType.GENERAL,
        message=payload,
    )
    return cfg


@router.get("/points", status_code=200, response_model=List[ArraialPoints])
def get_arraial_points(
    *,
    db: Session = Depends(deps.get_db),
) -> Any:
    return _arraial_points


@router.put("/points", status_code=200, response_model=List[ArraialPoints])
async def update_arraial_points(
    *,
    request: Request,
    points_update: ArraialPointsUpdate,
    db: Session = Depends(deps.get_db),
    auth_data: auth.AuthData = Security(auth.verify_token, scopes=[ScopeEnum.MANAGER_ARRAIAL]),
) -> Any:
    # Check rate limit
    _check_rate_limit(request, auth_data, "update_points")
    # Enforce paused config
    if _get_config_paused(db):
        raise HTTPException(status_code=423, detail="Point updates are paused by an administrator")
    
    points = _find_points(points_update.nucleo)
    if points is None:
        raise HTTPException(status_code=404, detail="Núcleo not found")

    global _next_log_id
    prev_value = points["value"]
    increment = points_update.pointIncrement
    # apply boost only to positive increments
    if increment > 0 and _is_boost_active(points_update.nucleo):
        boosted = int(increment * BOOST_MULTIPLIER)
        increment = boosted
    new_value = prev_value + increment
    
    # Prevent negative points
    if new_value < 0:
        raise HTTPException(
            status_code=400, 
            detail=f"Cannot reduce points below zero. Current: {prev_value}, Attempted reduction: {points_update.pointIncrement}"
        )
    
    points["value"] = new_value

    entry = ArraialLogEntry(
        id=_next_log_id,
        nucleo=points_update.nucleo,
        delta=increment,
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


@router.post("/boost/{nucleo}", status_code=200)
async def activate_boost(
    *,
    nucleo: str,
    db: Session = Depends(deps.get_db),
    auth_data: auth.AuthData = Security(auth.verify_token, scopes=[ScopeEnum.MANAGER_ARRAIAL]),
) -> Any:
    if nucleo not in VALID_NUCLEOS:
        raise HTTPException(status_code=400, detail="Invalid núcleo")
    now = datetime.now(timezone.utc)
    end = _boost_ends.get(nucleo)
    add_seconds = BOOST_DURATION_MINUTES * 60
    if end and end > now:
        _boost_ends[nucleo] = end + timedelta(seconds=add_seconds)
    else:
        _boost_ends[nucleo] = now + timedelta(seconds=add_seconds)

    # Log boost activation
    global _next_log_id
    entry = ArraialLogEntry(
        id=_next_log_id,
        nucleo=nucleo,
        delta=0,
        prev_value=_find_points(nucleo)["value"],
        new_value=_find_points(nucleo)["value"],
        user_id=int(auth_data.sub) if getattr(auth_data, "sub", None) else None,
        user_email=getattr(auth_data, "email", None),
        rolled_back=False,
        timestamp=datetime.now(timezone.utc),
        event="BOOST_ACTIVATED",
    )
    _arraial_log.insert(0, entry)
    _next_log_id += 1

    # Broadcast
    await arraial_ws_manager.broadcast(
        connection_type=ArraialConnectionType.GENERAL,
        message={"topic": "ARRAIAL_BOOST", "boosts": _get_boosts_response()},
    )

    return {"ok": True, "boosts": _get_boosts_response()}


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

    # Handle rollback for different event types
    if target.event == "BOOST_ACTIVATED":
        # Subtract boost duration from the boost end for the target núcleo
        end = _boost_ends.get(target.nucleo)
        if end is not None:
            new_end = end - timedelta(minutes=BOOST_DURATION_MINUTES)
            # If the new end is in the past or now, clear the boost
            if new_end <= datetime.now(timezone.utc):
                _boost_ends[target.nucleo] = None
            else:
                _boost_ends[target.nucleo] = new_end
        target.rolled_back = True

        # Broadcast updated boosts
        await arraial_ws_manager.broadcast(
            connection_type=ArraialConnectionType.GENERAL,
            message={"topic": "ARRAIAL_BOOST", "boosts": _get_boosts_response()},
        )

        # Return points unchanged to satisfy response_model
        return _arraial_points

    points = _find_points(target.nucleo)
    if points is None:
        raise HTTPException(status_code=404, detail="Núcleo not found")

    # Prevent going below zero if subsequent changes occurred
    points["value"] = max(0, points["value"] - target.delta)
    target.rolled_back = True

    await arraial_ws_manager.broadcast(
        connection_type=ArraialConnectionType.GENERAL,
        message={"topic": "ARRAIAL_POINTS", "points": _arraial_points},
    )

    return _arraial_points

@router.post("/reset", status_code=200)
async def reset_arraial(
    *,
    db: Session = Depends(deps.get_db),
    _=Security(auth.verify_token, scopes=[ScopeEnum.ADMIN]),
) -> Any:
    # Reset points to zero
    for p in _arraial_points:
        p["value"] = 0
    # Clear boosts
    for k in list(_boost_ends.keys()):
        _boost_ends[k] = None
    # Clear log
    global _arraial_log, _next_log_id
    _arraial_log = []
    _next_log_id = 1

    # Broadcast updates so clients refresh
    await arraial_ws_manager.broadcast(
        connection_type=ArraialConnectionType.GENERAL,
        message={"topic": "ARRAIAL_POINTS", "points": _arraial_points},
    )
    await arraial_ws_manager.broadcast(
        connection_type=ArraialConnectionType.GENERAL,
        message={"topic": "ARRAIAL_BOOST", "boosts": _get_boosts_response()},
    )

    return {"ok": True}
