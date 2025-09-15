from fastapi import APIRouter, Depends, HTTPException, Security
from sqlalchemy.orm import Session
from typing import Any, List
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


# Mock data for now - you can replace this with database calls later
_arraial_points = [
    {"nucleo": "NEEETA", "value": 0},
    {"nucleo": "NEECT", "value": 0},
    {"nucleo": "NEI", "value": 0}
]


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
    _=Security(auth.verify_token, scopes=[ScopeEnum.MANAGER_NEI]),
) -> Any:
    """
    Update arraial points for a specific team.
    """
    # Find the núcleo and update its points
    for points in _arraial_points:
        if points["nucleo"] == points_update.nucleo:
            points["value"] += points_update.pointIncrement
            break
    else:
        raise HTTPException(status_code=404, detail="Núcleo not found")
    
    # Broadcast updated points to all connected clients
    await arraial_ws_manager.broadcast(
        connection_type=ArraialConnectionType.GENERAL,
        message={"topic": "ARRAIAL_POINTS", "points": _arraial_points},
    )

    return _arraial_points
