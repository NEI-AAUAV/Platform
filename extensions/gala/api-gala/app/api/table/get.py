from fastapi import APIRouter, Security
from typing import List, Any

from app.models.table import Table
from app.api.auth import AuthData, api_nei_auth, auth_responses
from app.core.db import DatabaseDep

from ._utils import sanitize_table, fetch_table

router = APIRouter()



@router.get(
    "/list/public",
    responses={
        **auth_responses,
    },
)
async def list_tables(
    *,
    db: DatabaseDep,
) -> List[Table]:
    """List all available tables"""
    res = await Table.get_collection(db).find().to_list(None)

    def mapper(table_res: Any) -> Table:
        table = Table.parse_obj(table_res)
        return table

    return list(map(mapper, res))


@router.get(
    "/list",
    responses={
        **auth_responses,
    },
)
async def list_tables(
    *,
    db: DatabaseDep,
    auth: AuthData = Security(api_nei_auth),
) -> List[Table]:
    """List all available tables"""
    res = await Table.get_collection(db).find().to_list(None)

    def mapper(table_res: Any) -> Table:
        table = Table.parse_obj(table_res)
        return sanitize_table(auth, table)

    return list(map(mapper, res))


@router.get(
    "/{table_id}",
    responses={
        **auth_responses,
        404: {"description": "Table not found"},
    },
)
async def get_table(
    table_id: int,
    *,
    db: DatabaseDep,
    auth: AuthData = Security(api_nei_auth),
) -> Table:
    """Fetches the given table"""
    table = await fetch_table(table_id, db)
    return sanitize_table(auth, table)
