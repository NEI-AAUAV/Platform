from fastapi import APIRouter, Security, HTTPException
from pydantic import BaseModel
from pydantic.fields import Field
from pymongo import ReturnDocument
from pymongo.errors import OperationFailure
from typing import Annotated

from app.models.table import Table
from app.api.auth import AuthData, api_nei_auth, auth_responses
from app.core.db import DatabaseDep
from app.core.logging import logger
from app.utils import NotFoundReCheck

from ._utils import (
    sanitize_table,
    fetch_table,
    query_check_table_head_permissions,
    head_permission_check,
)

router = APIRouter()


class TableEditForm(BaseModel):
    name: Annotated[str, Field(min_length=3, max_length=20)]


@router.put(
    "/{table_id}/edit",
    responses={
        **auth_responses,
        404: {"description": "Table not found"},
    },
)
async def edit_table(
    table_id: int,
    form_data: TableEditForm,
    *,
    db: DatabaseDep,
    auth: AuthData = Security(api_nei_auth),
) -> Table:
    """Edits the table"""
    try:
        # Oportunistic path - Everything goes well
        res = await Table.get_collection(db).find_one_and_update(
            query_check_table_head_permissions(auth, {"_id": table_id}),
            {"$set": form_data.dict()},
            return_document=ReturnDocument.AFTER,
        )

        if res is None:
            raise NotFoundReCheck
    except (OperationFailure, NotFoundReCheck) as e:
        # Something went wrong - Check the reason and tell the client
        table = await fetch_table(table_id, db)
        head_permission_check(auth, table)

        logger.error(e)

        raise HTTPException(status_code=500, detail="Something went wrong")

    table = Table.parse_obj(res)
    return sanitize_table(auth, table)
