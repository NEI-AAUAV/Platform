from fastapi import APIRouter
from typing import List, Dict, Any
import os
import json
from loguru import logger


router = APIRouter()


def _iter_extension_manifests() -> List[str]:
    env_dir = os.getenv("EXTENSIONS_DIR")
    here = os.path.dirname(__file__)
    candidates = [
        env_dir,
        "/extensions",
        os.path.abspath(os.path.join(here, "..", "..", "..", "extensions")),
        os.path.abspath(os.path.join(here, "..", "..", "extensions")),
    ]
    manifests: List[str] = []
    for base in candidates:
        if not base or not os.path.isdir(base):
            continue
        try:
            for entry in os.listdir(base):
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


