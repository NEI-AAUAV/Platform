from fastapi import APIRouter, HTTPException, BackgroundTasks, Security
from pydantic import BaseModel
from typing import Any, List, Optional
from app.api.api_v1 import auth
from app.schemas.user import ScopeEnum
from app.core.config import settings

import requests

router = APIRouter()


# points hardcoded because no time xd
class Points(BaseModel):
    nucleo: str
    value: int

class PointUpdate(BaseModel):
    nucleo: str
    pointIncrement: int

PointsList = [
    {"nucleo":"NEEETA", "value" : 0},
    {"nucleo":"NEECT", "value" : 0},
    {"nucleo":"NEI", "value" : 0},    
]

@router.get("/points", status_code=200, response_model=List[Points])
def get_points():
    return PointsList

@router.put("/points", status_code=200, response_model=List[Points])
def update_points(
    *,
    point_in: PointUpdate,
    auth_data: auth.AuthData = Security(
        auth.verify_token, scopes=[ScopeEnum.MANAGER_NEI]
    )
):
    existing_nucleo = next((item for item in PointsList if item["nucleo"] == point_in.nucleo), None)
    
    if existing_nucleo:
        existing_nucleo["value"] += point_in.pointIncrement
    else:
        raise HTTPException(status_code=404, detail="Nucleo not found.")
    # add ws
    return PointsList

@router.put("/reset", status_code=200, response_model=List[Points])
def reset(    
    *,
    auth_data: auth.AuthData = Security(
        auth.verify_token, scopes=[ScopeEnum.MANAGER_NEI]
    )):
    for nucleo in PointsList:
        nucleo["value"] = 0
    # add ws
    return PointsList

def ws_send_update(data):
    requests.post(
        f"{settings.HOST}/api/nei/v1/ws/broadcast", json=data
    )