from fastapi import APIRouter, Security, HTTPException
from pymongo import ReturnDocument
from pymongo.errors import OperationFailure
from typing import Any
from app.core.db.types import DBType

from app.models.table import Table
from app.api.auth import api_nei_auth, AuthData
from app.core.db import DatabaseDep
from app.core.logging import logger
from app.utils import NotFoundReCheck

from ._utils import (
    sanitize_table,
    fetch_table,
    head_permission_check,
    query_check_table_head_permissions,
)

router = APIRouter()


async def common(
    *, uid: int, table_id: int, protected: bool, auth: AuthData, db: DBType
) -> Table:
    table = await fetch_table(table_id, db)

    update_cmd: dict[str, Any] = {
        "$pull": {
            "persons": {"id": uid},
        },
    }

    if uid == table.head:
        update_cmd["$set"] = {"head": None, "name": None}

    try:
        query = {"_id": table_id, "persons.id": uid}

        if protected:
            query = query_check_table_head_permissions(auth, query)

        # Oportunistic path - Everything goes well
        res = await Table.get_collection(db).find_one_and_update(
            query,
            update_cmd,
            return_document=ReturnDocument.AFTER,
        )

        if res is None:
            raise NotFoundReCheck
    except (OperationFailure, NotFoundReCheck) as e:
        # Something went wrong - Check the reason and tell the client
        table = await fetch_table(table_id, db)

        if protected:
            head_permission_check(auth, table)

        if table.head == uid and len(table.persons) > 1:
            raise HTTPException(
                status_code=400, detail="Table head cannot leave a non-empty table"
            )

        if all(person.id != uid for person in table.persons):
            raise HTTPException(
                status_code=400, detail="The person doesn't belong to the table"
            )

        logger.error(e)

        raise HTTPException(status_code=500, detail="Something went wrong")

    table = Table.parse_obj(res)
    return sanitize_table(auth, table)


@router.delete(
    "/{table_id}/leave",
    responses={
        400: {
            "description": "The table head cannot leave a non-empty table or the person doesn't belong to the table"
        },
        404: {"description": "Table not found"},
    },
)
async def person_leave_table(
    table_id: int,
    *,
    db: DatabaseDep,
    auth: AuthData = Security(api_nei_auth),
) -> Table:
    """Removes the self person from the table"""
    return await common(
        uid=auth.sub, table_id=table_id, protected=False, auth=auth, db=db
    )


@router.delete(
    "/{table_id}/remove/{uid}",
    responses={
        400: {
            "description": "The table head cannot leave a non-empty table or the person doesn't belong to the table"
        },
        404: {"description": "Table not found"},
    },
)
async def person_remove_table(
    table_id: int,
    uid: int,
    *,
    db: DatabaseDep,
    auth: AuthData = Security(api_nei_auth),
) -> Table:
    """Removes a person from the table"""
    return await common(uid=uid, table_id=table_id, protected=True, auth=auth, db=db)
