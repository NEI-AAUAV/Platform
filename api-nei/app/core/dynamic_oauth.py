"""
Dynamic OAuth2 Scheme

This module provides a dynamic OAuth2 scheme that can be updated with extension scopes.
"""

from typing import Dict, Optional
from fastapi.security import OAuth2PasswordBearer
from fastapi import Request
from fastapi.openapi.models import OAuthFlows as OAuthFlowsModel
from fastapi.security.utils import get_authorization_scheme_param
from starlette.status import HTTP_401_UNAUTHORIZED
from starlette.responses import Response
from loguru import logger

from app.core.config import settings
from app.core.extension_scopes import load_extension_scopes


class DynamicOAuth2PasswordBearer(OAuth2PasswordBearer):
    """OAuth2PasswordBearer that can dynamically update scopes"""
    
    def __init__(self, tokenUrl: str, scopes: Optional[Dict[str, str]] = None, **kwargs):
        self._base_scopes = scopes or {}
        self._token_url = tokenUrl
        super().__init__(tokenUrl=tokenUrl, scopes=self._base_scopes, **kwargs)
    
    def get_scopes(self) -> Dict[str, str]:
        """Get current scopes including extension scopes"""
        base_scopes = self._base_scopes.copy()
        extension_scopes = load_extension_scopes()
        return {**base_scopes, **extension_scopes}
    
    def update_scopes(self):
        """Update the OAuth2 scheme with current extension scopes"""
        current_scopes = self.get_scopes()
        self.scopes = current_scopes
        
        # Update the flows model for OpenAPI
        if hasattr(self, 'flows') and self.flows:
            if hasattr(self.flows, 'password') and self.flows.password:
                self.flows.password.scopes = current_scopes
        
        logger.info(f"Updated OAuth2 scopes: {list(current_scopes.keys())}")
    
    async def __call__(self, request: Request) -> Optional[str]:
        """Extract token from request"""
        authorization: str = request.headers.get("Authorization")
        scheme, param = get_authorization_scheme_param(authorization)
        if not authorization or scheme.lower() != "bearer":
            if self.auto_error:
                from fastapi import HTTPException, status
                raise HTTPException(
                    status_code=HTTP_401_UNAUTHORIZED,
                    detail="Not authenticated",
                    headers={"WWW-Authenticate": "Bearer"},
                )
            else:
                return None
        return param


# Create the dynamic OAuth2 scheme
def create_dynamic_oauth_scheme() -> DynamicOAuth2PasswordBearer:
    """Create a dynamic OAuth2 scheme with base scopes"""
    base_scopes = {
        "admin": "Full access to everything.",
        "manager-family": "Edit faina family.",
        "manager-tacaua": "Edit data related to tacaua.",
        "manager-nei": "Edit data related to nei.",
        "manager-jantar-gala": "Edit data related to jantar de gala.",
        "manager-arraial": "Edit data related to arraial.",
    }
    
    scheme = DynamicOAuth2PasswordBearer(
        auto_error=False,
        tokenUrl=settings.API_V1_STR + "/auth/login",
        scopes=base_scopes,
    )
    
    # Update with extension scopes
    scheme.update_scopes()
    
    return scheme


# Global instance
dynamic_oauth2_scheme = create_dynamic_oauth_scheme()

