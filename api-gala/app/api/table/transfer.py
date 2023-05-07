from fastapi import APIRouter, Security, HTTPException
from pydantic import BaseModel
from pymongo import ReturnDocument
from pymongo.errors import OperationFailure

from app.models.table import Table
from app.api.auth import AuthData, api_nei_auth
from app.core.db import DatabaseDep
from app.core.logging import logger

from ._utils import (
    NotFoundReCheck,
    sanitize_table,
    fetch_table,
    query_check_table_head_permissions,
    head_permission_check,
)

router = APIRouter()


class TableTransferForm(BaseModel):
    uid: int


@router.patch(
    "/{table_id}/transfer",
    responses={
        400: {"description": "The person doesn't belong to the table"},
        403: {"description": "The user doesn't have enough permissions"},
        404: {"description": "Table not found"},
    },
)
async def person_transfer_table(
    table_id: int,
    form_data: TableTransferForm,
    *,
    db: DatabaseDep,
    auth: AuthData = Security(api_nei_auth),
) -> Table:
    """Transfers the table to another person"""
    try:
        # Oportunistic path - Everything goes well
        res = await Table.get_collection(db).find_one_and_update(
            query_check_table_head_permissions(
                auth, {"_id": table_id, "persons.id": form_data.uid}
            ),
            {"$set": {"head": form_data.uid, "persons.$.confirmed": True}},
            return_document=ReturnDocument.AFTER,
        )

        if res is None:
            raise NotFoundReCheck
    except (OperationFailure, NotFoundReCheck) as e:
        # Something went wrong - Check the reason and tell the client
        table = await fetch_table(table_id, db)
        head_permission_check(auth, table)

        if all(person.id != form_data.uid for person in table.persons):
            raise HTTPException(
                status_code=400, detail="The person doesn't belong to the table"
            )

        logger.error(e)

        raise HTTPException(status_code=500, detail="Something went wrong")

    table = Table.parse_obj(res)
    return sanitize_table(auth, table)
