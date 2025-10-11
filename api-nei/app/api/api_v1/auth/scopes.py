"""
OAuth2 Scopes API

Provides information about available OAuth2 scopes including extension scopes.
"""

from typing import List
from fastapi import APIRouter, Depends
from pydantic import BaseModel

from app.core.dynamic_oauth import dynamic_oauth2_scheme
from app.schemas.user import ScopeEnum

router = APIRouter()


class ScopesResponse(BaseModel):
    """Response model for available scopes"""
    scopes: List[str]
    descriptions: dict[str, str]


@router.get("/scopes", response_model=ScopesResponse)
async def get_available_scopes():
    """
    Get all available OAuth2 scopes including extension scopes.
    
    Returns:
        ScopesResponse: List of available scopes and their descriptions
    """
    # Get current scopes from the dynamic OAuth2 scheme
    current_scopes = dynamic_oauth2_scheme.get_scopes()
    
    return ScopesResponse(
        scopes=list(current_scopes.keys()),
        descriptions=current_scopes
    )

