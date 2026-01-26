"""
User API endpoints for Family Tree.
"""
import logging
from typing import List, Optional

from fastapi import APIRouter, HTTPException, Query, Security, UploadFile, File, Form

from app.api import auth
from app.crud.crud_user import user as crud_user
from app.crud.crud_course import course as crud_course
from app.schemas.user import (
    UserCreate, UserUpdate, UserInDB, UserList,
    UserBulkCreate, BulkCreateError, BulkCreateResponse
)
from app.constants import DEFAULT_SKIP, DEFAULT_LIMIT, MAX_LIMIT, DEFAULT_SORT_FIELD, DEFAULT_SORT_ORDER



router = APIRouter()
logger = logging.getLogger(__name__)


@router.get("/", status_code=200, response_model=UserList)
def get_users(
    skip: int = Query(default=DEFAULT_SKIP, ge=0, description="Number of records to skip"),
    limit: int = Query(default=DEFAULT_LIMIT, ge=1, le=MAX_LIMIT, description="Max records to return"),
    start_year_gte: Optional[int] = Query(default=None, alias="from_year", description="Filter by start_year >= value"),
    patrao_id: Optional[int] = Query(default=None, description="Filter by patrao_id"),
    search: Optional[str] = Query(default=None, description="Search by name (case-insensitive)"),
    year: Optional[int] = Query(default=None, description="Filter by exact start_year"),
    role_id: Optional[str] = Query(default=None, description="Filter by role ID"),
    role_year: Optional[int] = Query(default=None, description="Filter by role year (year of role assignment)"),
    sort_by: Optional[str] = Query(default=DEFAULT_SORT_FIELD, description="Sort field: name, _id (or id), year, nmec, patrao_id"),
    order: Optional[str] = Query(default=DEFAULT_SORT_ORDER, description="Sort order: asc, desc"),
    _=Security(auth.verify_scopes, scopes=[auth.ScopeEnum.MANAGER_FAMILY]),
):
    """
    List users with optional filters.
    
    - **skip**: Number of records to skip (pagination)
    - **limit**: Maximum number of records to return
    - **from_year**: Filter users with start_year >= this value
    - **patrao_id**: Filter users by their patrão
    - **search**: Search users by name (case-insensitive partial match)
    - **year**: Filter by exact start year
    - **role_id**: Filter by role
    - **role_year**: Filter by year of role assignment
    """
    users = crud_user.get_multi(
        skip=skip, 
        limit=limit, 
        start_year_gte=start_year_gte,
        patrao_id=patrao_id,
        search=search,
        year=year,
        role_id=role_id,
        role_year=role_year,
        sort_by=sort_by,
        order=order
    )
    
    total = crud_user.count(
        search=search,
        year=year,
        role_id=role_id,
        role_year=role_year
    )
    
    return UserList(
        items=users,
        total=total,
        skip=skip,
        limit=limit
    )


@router.get("/years", status_code=200, response_model=List[int])
def get_years_list(
    _=Security(auth.verify_scopes, scopes=[auth.ScopeEnum.MANAGER_FAMILY]),
):
    """
    Get list of all distinct start years present in the database.
    Useful for populating filter dropdowns.
    """
    return crud_user.get_years()



@router.get("/{id}", status_code=200, response_model=UserInDB)
def get_user(
    id: int,
    _=Security(auth.verify_scopes, scopes=[auth.ScopeEnum.MANAGER_FAMILY]),
):
    """
    Get a single user by ID.
    """
    user = crud_user.get(id)
    if not user:
        raise HTTPException(status_code=404, detail=f"User with id {id} not found")
    return user


@router.get("/{id}/children", status_code=200, response_model=List[UserInDB])
def get_user_children(
    id: int,
    _=Security(auth.verify_scopes, scopes=[auth.ScopeEnum.MANAGER_FAMILY]),
):
    """
    Get all children (pedaços) of a user.
    """
    if not crud_user.exists(id):
        raise HTTPException(status_code=404, detail=f"User with id {id} not found")
    
    children = crud_user.get_children(id)
    return children


@router.put("/{id}/image", status_code=200, response_model=UserInDB)
async def update_user_image(
    id: int,
    image: UploadFile = File(None),
    remove: bool = Form(False),
    _=Security(auth.verify_scopes, scopes=[auth.ScopeEnum.MANAGER_FAMILY]),
):
    """
    Upload or remove a user's photo.
    Send multipart/form-data with `image` file; pass `remove=true` to delete.
    """
    from app.services.storage import storage_client
    if not storage_client.enabled:
        raise HTTPException(status_code=503, detail="Image upload is disabled: R2 storage is not configured.")

    if remove and image is not None:
        raise HTTPException(status_code=400, detail="Choose image or remove, not both")

    image_bytes = None if remove else (await image.read() if image is not None else None)

    updated = await crud_user.update_image(id, image_bytes)
    if not updated:
        raise HTTPException(status_code=404, detail=f"User with id {id} not found")
    return updated


@router.post("/", status_code=201, response_model=UserInDB)
def create_user(
    obj_in: UserCreate,
    _=Security(auth.verify_scopes, scopes=[auth.ScopeEnum.MANAGER_FAMILY]),
):
    """
    Create a new user. Requires MANAGER_FAMILY scope.
    
    - **name**: Full name (required)
    - **sex**: M or F (required)
    - **start_year**: Year of entry, 2 digits (required)
    - **patrao_id**: ID of the patrão (optional, null for roots)
    - **faina_name**: Faina name (optional, auto-generated from last name if not provided)
    """
    # Validate patrao_id exists if provided
    if obj_in.patrao_id is not None:
        if not crud_user.exists(obj_in.patrao_id):
            raise HTTPException(
                status_code=400, 
                detail=f"Patrão with id {obj_in.patrao_id} not found"
            )
    
    # Validate course_id exists if provided
    # Validate course_id exists if provided
    if obj_in.course_id is not None and not crud_course.exists(obj_in.course_id):
        raise HTTPException(
            status_code=400, 
            detail=f"Course with id {obj_in.course_id} not found"
        )
    
    # Validate nmec is unique if provided
    if obj_in.nmec is not None:
        existing = crud_user.get_by_nmec(obj_in.nmec)
        if existing:
            raise HTTPException(
                status_code=400,
                detail=f"User with nmec {obj_in.nmec} already exists"
            )
    
    user = crud_user.create(obj_in=obj_in)
    return user


@router.post("/bulk", status_code=201, response_model=BulkCreateResponse)
def create_users_bulk(
    users_in: List[UserBulkCreate],
    dry_run: bool = Query(False, description="Preview without creating (no changes saved)"),
    atomic: bool = Query(False, description="All-or-nothing: rollback if any error"),
    _=Security(auth.verify_scopes, scopes=[auth.ScopeEnum.MANAGER_FAMILY]),
):
    """
    Create multiple users in bulk. Requires MANAGER_FAMILY scope.
    
    Features:
    - **dry_run**: Preview what would happen without actually creating users
    - **atomic**: If true, either all succeed or none (rollback on any error)
    - Partial success is allowed (unless atomic=True)
    - Duplicate name detection (warning, not error)
    - Future year validation
    
    Limits:
    - Maximum 100 users per request
    
    Returns: { created, errors, warnings, total_submitted, total_created, total_errors, dry_run }
    """
    from datetime import datetime
    
    # Batch size limit
    MAX_BATCH_SIZE = 100
    if len(users_in) > MAX_BATCH_SIZE:
        raise HTTPException(
            status_code=400,
            detail=f"Máximo de {MAX_BATCH_SIZE} utilizadores por pedido. Enviados: {len(users_in)}"
        )
    
    # Pre-fetch existing IDs
    all_patrao_ids = {u.patrao_id for u in users_in if u.patrao_id is not None}
    all_course_ids = {u.course_id for u in users_in if u.course_id is not None}
    
    existing_patrao_ids = set(crud_user.get_existing_ids(list(all_patrao_ids))) if all_patrao_ids else set()
    existing_course_ids = _fetch_existing_course_ids(all_course_ids)
    
    # Detect duplicates within batch (warnings)
    warnings = _detect_batch_duplicates(users_in)
    
    # Validation loop
    users_to_create = []
    errors = []
    
    seen_nmecs = set()
    current_year = datetime.now().year % 100

    for idx, user_data in enumerate(users_in):
        error_msg = _validate_bulk_user(
            user_data, 
            current_year, 
            existing_patrao_ids, 
            existing_course_ids, 
            seen_nmecs
        )
        
        data_dict = user_data.dict()
        if error_msg:
            errors.append(BulkCreateError(row=idx, data=data_dict, message=error_msg))
        else:
            users_to_create.append((idx, user_data, data_dict))
            if user_data.nmec:
                seen_nmecs.add(user_data.nmec)

    # Handle dry run and atomic checks
    if (atomic and errors) or dry_run:
        return _build_bulk_response(
            users_in, 
            users_to_create if dry_run else [], 
            errors, 
            warnings, 
            dry_run
        )
    
    # Execute creation
    created_users, creation_errors = _execute_bulk_creation(users_to_create, existing_patrao_ids)
    errors.extend(creation_errors)

    return BulkCreateResponse(
        created=created_users,
        errors=errors,
        warnings=warnings,
        total_submitted=len(users_in),
        total_created=len(created_users),
        total_errors=len(errors),
        dry_run=False
    )


def _execute_bulk_creation(
    users_to_create: List[tuple],
    existing_patrao_ids: set
) -> tuple[List[dict], List[BulkCreateError]]:
    """Execute the user creation transaction."""
    created_users = []
    errors = []
    
    for idx, _, data_dict in users_to_create:
        try:
            # Create user
            user = crud_user.create(obj_in=UserCreate(**data_dict))
            created_users.append(user)
            # Add to valid patraos for subsequent
            existing_patrao_ids.add(user["_id"])
        except Exception as e:
            msg = e.detail if hasattr(e, 'detail') else str(e)
            logger.error(f"Error creating user row {idx}: {e}")
            errors.append(BulkCreateError(row=idx, data=data_dict, message=msg))
            
    return created_users, errors


def _fetch_existing_course_ids(course_ids: set) -> set:
    """Fetch valid course IDs from set."""
    valid = set()
    if course_ids:
        for cid in course_ids:
            if crud_course.exists(cid):
                valid.add(cid)
    return valid


def _detect_batch_duplicates(users_in: List[UserBulkCreate]) -> List[str]:
    """Identify duplicate names in batch and return warnings."""
    seen_names = {}
    warnings = []
    for idx, user_data in enumerate(users_in):
        name_lower = user_data.name.strip().lower()
        if name_lower not in seen_names:
            seen_names[name_lower] = []
        seen_names[name_lower].append(idx)
    
    for name, indices in seen_names.items():
        if len(indices) > 1:
            rows_str = ", ".join(str(i + 1) for i in indices)
            warnings.append(f"Nome duplicado '{name}' nas linhas: {rows_str}")
    return warnings


def _validate_bulk_user(
    user_data: UserBulkCreate,
    current_year: int,
    existing_patrao_ids: set,
    existing_course_ids: set,
    seen_nmecs: set
) -> Optional[str]:
    """Validate a single user for bulk creation."""
    # Future year check
    if user_data.start_year > current_year:
        return f"Ano {user_data.start_year} é no futuro (ano atual: {current_year})"
    
    # Patrão check
    if user_data.patrao_id is not None and user_data.patrao_id not in existing_patrao_ids:
        return f"Patrão com id {user_data.patrao_id} não encontrado"
    
    # Course check
    if user_data.course_id is not None and user_data.course_id not in existing_course_ids:
        return f"Curso com id {user_data.course_id} não encontrado"
    
    # NMEC unique check
    if user_data.nmec is not None:
        if user_data.nmec in seen_nmecs:
            return f"Nmec {user_data.nmec} duplicado neste ficheiro"
        if crud_user.get_by_nmec(user_data.nmec):
            return f"Utilizador com nmec {user_data.nmec} já existe"
            
    return None


def _build_bulk_response(
    users_in: List,
    users_to_create: List,
    errors: List,
    warnings: List,
    dry_run: bool
) -> BulkCreateResponse:
    """Build response for dry-run or atomic failure."""
    mock_created = []
    if dry_run:
        for idx, _, data_dict in users_to_create:
            mock_created.append({
                **data_dict, 
                "_id": -1, 
                "user_roles": []
            })
            
    return BulkCreateResponse(
        created=mock_created,
        errors=errors,
        warnings=warnings,
        total_submitted=len(users_in),
        total_created=len(mock_created),
        total_errors=len(errors),
        dry_run=dry_run
    )


@router.put("/{id}", status_code=200, response_model=UserInDB)
def update_user(
    id: int,
    obj_in: UserUpdate,
    _=Security(auth.verify_scopes, scopes=[auth.ScopeEnum.MANAGER_FAMILY]),
):
    """
    Update a user. Requires MANAGER_FAMILY scope.
    Only provided fields will be updated.
    """
    # Check user exists
    if not crud_user.exists(id):
        raise HTTPException(status_code=404, detail=f"User with id {id} not found")
    
    # Validate patrao_id if being updated
    if obj_in.patrao_id is not None:
        if obj_in.patrao_id == id:
            raise HTTPException(status_code=400, detail="User cannot be their own patrão")
        if not crud_user.exists(obj_in.patrao_id):
            raise HTTPException(
                status_code=400, 
                detail=f"Patrão with id {obj_in.patrao_id} not found"
            )
    
    # Validate course_id if being updated
    if obj_in.course_id is not None and not crud_course.exists(obj_in.course_id):
        raise HTTPException(
            status_code=400, 
            detail=f"Course with id {obj_in.course_id} not found"
        )
    
    # Validate nmec uniqueness if being updated
    if obj_in.nmec is not None:
        existing = crud_user.get_by_nmec(obj_in.nmec)
        if existing and existing["_id"] != id:
            raise HTTPException(
                status_code=400,
                detail=f"User with nmec {obj_in.nmec} already exists"
            )
    
    user = crud_user.update(id=id, obj_in=obj_in)
    return user


@router.delete("/{id}", status_code=204)
def delete_user(
    id: int,
    _=Security(auth.verify_scopes, scopes=[auth.ScopeEnum.MANAGER_FAMILY]),
):
    """
    Delete a user. Requires MANAGER_FAMILY scope.
    
    Warning: This will leave orphaned children (pedaços).
    Consider reassigning them first.
    """
    if not crud_user.exists(id):
        raise HTTPException(status_code=404, detail=f"User with id {id} not found")
    
    # Check for children (pedaços)
    children = crud_user.get_children(id)
    if children:
        raise HTTPException(
            status_code=400,
            detail=f"Cannot delete user with {len(children)} children. Reassign them first."
        )
    
    crud_user.delete(id=id)
    return None
