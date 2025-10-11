from fastapi import APIRouter
from typing import List, Dict, Any
import os
import json
from loguru import logger


router = APIRouter()


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


def _iter_extension_manifests() -> List[str]:
    env_dir = os.getenv("EXTENSIONS_DIR")
    here = os.path.dirname(__file__)
    candidates = [
        env_dir,
        "/extensions",
        os.path.abspath(os.path.join(here, "..", "..", "..", "extensions")),
        os.path.abspath(os.path.join(here, "..", "..", "extensions")),
    ]
    
    enabled_extensions = _get_enabled_extensions()
    manifests: List[str] = []
    
    for base in candidates:
        if not base or not os.path.isdir(base):
            continue
        try:
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


@router.get("/extensions/manifest")
def get_extensions_manifest() -> Dict[str, Any]:
    nav: List[Dict[str, Any]] = []
    seen: set[str] = set()
    manifests = _iter_extension_manifests()
    
    for path in manifests:
        try:
            with open(path, "r", encoding="utf-8") as fh:
                data = json.load(fh)
            entries = data.get("nav", []) or []
            for e in entries:
                # Only allow safe fields
                label = e.get("label")
                href = e.get("href")
                ext = data.get("name")
                key = f"{ext}:{label}:{href}"
                if key in seen:
                    continue
                seen.add(key)
                nav.append({
                    "label": label,
                    "href": href,
                    "requiresScopes": e.get("requiresScopes", []),
                    "extension": ext,
                })
        except Exception as exc:
            logger.error(f"Failed reading {path}: {exc}")
    return {"nav": nav}


