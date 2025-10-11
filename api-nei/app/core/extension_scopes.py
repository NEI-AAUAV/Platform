"""
Extension Scope Registry

This module provides a registry system for extensions to register their own scopes
without modifying the main platform code.
"""

from typing import Dict, List, Optional
from dataclasses import dataclass
from loguru import logger
import os
import json


@dataclass
class ExtensionScope:
    """Represents a scope registered by an extension"""
    scope: str
    description: str
    extension_name: str


class ExtensionScopeRegistry:
    """Registry for extension-provided scopes"""
    
    _scopes: Dict[str, ExtensionScope] = {}
    _initialized: bool = False
    
    @classmethod
    def register_scope(
        cls, 
        extension_name: str, 
        scope: str, 
        description: str
    ) -> None:
        """
        Register a scope from an extension
        
        Args:
            extension_name: Name of the extension (e.g., 'rally', 'gala')
            scope: The scope string (e.g., 'manager-rally')
            description: Human-readable description of the scope
        """
        scope_key = f"{extension_name}:{scope}"
        
        if scope_key in cls._scopes:
            logger.warning(f"Scope {scope_key} already registered, overwriting")
        
        cls._scopes[scope_key] = ExtensionScope(
            scope=scope,
            description=description,
            extension_name=extension_name
        )
        
        logger.info(f"Registered scope: {scope_key} - {description}")
    
    @classmethod
    def get_all_scopes(cls) -> Dict[str, ExtensionScope]:
        """Get all registered extension scopes"""
        return cls._scopes.copy()
    
    @classmethod
    def get_scopes_for_extension(cls, extension_name: str) -> List[ExtensionScope]:
        """Get all scopes for a specific extension"""
        return [
            scope for scope in cls._scopes.values() 
            if scope.extension_name == extension_name
        ]
    
    @classmethod
    def get_scope_dict(cls) -> Dict[str, str]:
        """
        Get scopes as a dictionary for OAuth2 scheme
        
        Returns:
            Dict mapping scope names to descriptions
        """
        return {
            scope.scope: scope.description 
            for scope in cls._scopes.values()
        }
    
    @classmethod
    def clear(cls) -> None:
        """Clear all registered scopes (mainly for testing)"""
        cls._scopes.clear()
        cls._initialized = False
    
    @classmethod
    def is_initialized(cls) -> bool:
        """Check if registry has been initialized"""
        return cls._initialized
    
    @classmethod
    def mark_initialized(cls) -> None:
        """Mark registry as initialized"""
        cls._initialized = True


def load_extension_scopes() -> Dict[str, str]:
    """
    Load all extension scopes for use in OAuth2 scheme
    
    Returns:
        Dictionary of scope names to descriptions
    """
    return ExtensionScopeRegistry.get_scope_dict()


def _get_enabled_extensions() -> set[str] | None:
    """Get the list of enabled extensions from environment variable.
    
    Returns:
        - None: ENABLED_EXTENSIONS not set (load all extensions for backward compatibility)
        - Empty set: ENABLED_EXTENSIONS is set but empty (load no extensions)
        - Set with extensions: ENABLED_EXTENSIONS contains specific extensions
    """
    enabled_extensions = os.getenv("ENABLED_EXTENSIONS")
    if enabled_extensions is None:
        return None  # Not set - backward compatibility, load all
    if not enabled_extensions.strip():
        return set()  # Set but empty - load no extensions
    return set(ext.strip() for ext in enabled_extensions.split(",") if ext.strip())


def _iter_extension_manifests(base_dirs: List[str]) -> List[str]:
    """Find all extension manifest.json files under provided base directories."""
    manifests: List[str] = []
    enabled_extensions = _get_enabled_extensions()
    
    for base in base_dirs:
        try:
            if not base:
                continue
            if not os.path.isdir(base):
                continue
            for entry in os.listdir(base):
                # Only include extensions that are explicitly enabled
                # If ENABLED_EXTENSIONS is set but empty, no extensions should be loaded
                # If ENABLED_EXTENSIONS is not set, load all extensions (backward compatibility)
                if enabled_extensions is not None and entry not in enabled_extensions:
                    logger.info(f"Skipping {entry} extension - not in ENABLED_EXTENSIONS")
                    continue
                    
                manifest_path = os.path.join(base, entry, "manifest.json")
                if os.path.isfile(manifest_path):
                    manifests.append(manifest_path)
        except Exception as exc:
            logger.warning(f"Error scanning manifests in {base}: {exc}")
    return manifests


def load_scopes_from_manifests() -> None:
    """Load extension scopes from extensions/*/manifest.json without importing extensions.

    Search order:
    - EXTENSIONS_DIR env var (absolute path)
    - /extensions (container default)
    - ../../extensions (repo layout when app cwd is app/api-nei)
    - ../extensions (alternative)
    """
    env_dir = os.getenv("EXTENSIONS_DIR")
    here = os.path.dirname(__file__)
    candidates = [
        env_dir,
        "/extensions",
        os.path.abspath(os.path.join(here, "..", "..", "extensions")),
        os.path.abspath(os.path.join(here, "..", "extensions")),
    ]

    manifests = _iter_extension_manifests(candidates)
    if not manifests:
        logger.info("No extension manifests found for scope registration")
        return

    registered = 0
    for manifest_path in manifests:
        try:
            with open(manifest_path, "r", encoding="utf-8") as fh:
                data = json.load(fh)
            extension_name = data.get("name")
            scopes = data.get("scopes", []) or []
            if not extension_name:
                logger.warning(f"Manifest missing name: {manifest_path}")
                continue
            for scope_def in scopes:
                scope_name = scope_def.get("name")
                description = scope_def.get("description", scope_name or "")
                if not scope_name:
                    logger.warning(f"Manifest scope missing name in {manifest_path}")
                    continue
                ExtensionScopeRegistry.register_scope(extension_name, scope_name, description)
                registered += 1
        except Exception as exc:
            logger.error(f"Failed loading manifest {manifest_path}: {exc}")

    if registered:
        ExtensionScopeRegistry.mark_initialized()
        logger.info(f"Registered {registered} scopes from manifests")

