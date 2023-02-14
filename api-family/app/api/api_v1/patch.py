from typing import Any, List, Optional
from datetime import datetime

from fastapi import APIRouter, HTTPException, Query, Security
from fastapi.requests import Request
from fastapi.responses import Response

from app import crud
from app.api import auth, deps
from app.exception import NotFoundException
from app.schemas.patch import PatchInDB, PatchCreate, PatchUpdate, PatchLazyList
from app.serializers import serializeDict


GMTIME_PATTERN = '%a, %d %b %Y %H:%M:%S GMT'

router = APIRouter()


@router.get("/", status_code=200, response_model=PatchLazyList,
            description="Retrieve the patches created by the active user, "
            "or all patches if authorized")
def get_patches(
    patcher_id: str = Query(alias='from'),
    until: int = Query(default=5, description='Number of years ago')
) -> Any:
    # TODO: add pagination perhaps
    # check authentication permissions
    ...


@router.get("/{id}", status_code=200, response_model=PatchInDB)
def get_patch(id: int, response: Response) -> Any:
    obj = crud.patch.get(id=id)
    obj = serializeDict(obj)

    # TODO: check obj['updated_at'] is datetime
    # Add Last-Modified header
    response['Last-Modified'] = obj['updated_at'].strftime(GMTIME_PATTERN)

    return obj


@router.get("/", status_code=200, response_model=PatchInDB)
def create_patch(
    obj_in: PatchCreate
) -> Any:
    # TODO: only with authentication
    ...


@router.put("/{id}", status_code=201, response_model=PatchInDB)
def update_patch(
    id: int, obj_in: PatchUpdate, request: Request
    _=Security(auth.verify_scopes, scopes=[auth.ScopeEnum.MANAGER_FAMILY]),
) -> Any:
    # TODO: Only with admin permissions

    # Validate If-Modified-Since header
    updated_since = request.headers.get('If-Modified-Since')
    if not updated_since:
        raise HTTPException(
            status_code=403, detail='If-Modified-Since header not provided')

    doc = crud.patch.get(id=id)
    if not doc:
        raise NotFoundException()
    doc = serializeDict(doc)

    updated_since = datetime.strptime(updated_since, GMTIME_PATTERN)
    if updated_since != doc['updated_at']:
        raise HTTPException(
            status_code=412, detail='Update attempt with stale information')

    doc = crud.patch.update(id, doc)
    return doc
