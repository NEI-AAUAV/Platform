"""Read-only client for listing images inside a public Google Drive folder.

Editors link a shared Drive folder from Directus (history.drive_folder_url);
this module resolves that link to a list of viewable image URLs at read
time. It never uploads, writes, or requires an OAuth user — only a
Drive-API-restricted API key (settings.GOOGLE_API_KEY).

Failure is always soft: a bad link, a private folder, a missing key, or an
API error all resolve to an empty list rather than raising, because a
photo gallery must never break the milestone it belongs to.
"""
from __future__ import annotations

import re
import time
from dataclasses import dataclass
from typing import Optional
from urllib.parse import ParseResult, parse_qs, urlparse

import httpx
from loguru import logger

from app.core.config import settings

_DRIVE_HOSTS = {"drive.google.com", "docs.google.com"}
_ID_RE = re.compile(r"[A-Za-z0-9_-]{10,}")
_FOLDER_PATH_RE = re.compile(r"/folders/([A-Za-z0-9_-]{10,})")
_FILE_PATH_RE = re.compile(r"/file/d/([A-Za-z0-9_-]{10,})")

_DRIVE_FILES_ENDPOINT = "https://www.googleapis.com/drive/v3/files"
_THUMB_WIDTH = 600
_FULL_WIDTH = 2000
_CACHE_TTL_SECONDS = 10 * 60


@dataclass(frozen=True)
class DriveImage:
    file_id: str
    caption: Optional[str]

    @property
    def thumb_url(self) -> str:
        return f"https://lh3.googleusercontent.com/d/{self.file_id}=w{_THUMB_WIDTH}"

    @property
    def url(self) -> str:
        return f"https://lh3.googleusercontent.com/d/{self.file_id}=w{_FULL_WIDTH}"


def extract_folder_id(url: str) -> Optional[str]:
    """Return the folder id from a drive.google.com folder link, or None."""
    return _extract_id(url, _FOLDER_PATH_RE)


def extract_file_id(url: str) -> Optional[str]:
    """Return the file id from a drive.google.com single-file link, or None."""
    file_id = _extract_id(url, _FILE_PATH_RE)
    if file_id:
        return file_id
    # `open?id=...` / `uc?id=...` style links.
    parsed = _parse_drive_url(url)
    if parsed is None:
        return None
    query = parse_qs(parsed.query)
    candidate = query.get("id", [None])[0]
    if candidate and _ID_RE.fullmatch(candidate):
        return candidate
    return None


def _extract_id(url: str, path_re: re.Pattern[str]) -> Optional[str]:
    parsed = _parse_drive_url(url)
    if parsed is None:
        return None
    match = path_re.search(parsed.path)
    return match.group(1) if match else None


def _parse_drive_url(url: str) -> Optional[ParseResult]:
    if not url:
        return None
    try:
        parsed = urlparse(url)
    except ValueError:
        return None
    if parsed.scheme not in ("http", "https") or parsed.netloc not in _DRIVE_HOSTS:
        return None
    return parsed


@dataclass
class _CacheEntry:
    images: list[DriveImage]
    expires_at: float


class GoogleDriveClient:
    """Thin wrapper around the Drive v3 `files.list` endpoint, with a small
    in-memory cache so opening the same gallery repeatedly (or the list
    endpoint eager-loading covers) doesn't hammer the Drive API."""

    def __init__(self, transport: httpx.AsyncBaseTransport | None = None) -> None:
        self._transport = transport
        self._client: httpx.AsyncClient | None = None
        self._cache: dict[str, _CacheEntry] = {}

    def start(self) -> None:
        if self._client is None:
            self._client = httpx.AsyncClient(
                timeout=httpx.Timeout(8.0), transport=self._transport
            )

    async def close(self) -> None:
        if self._client is not None:
            await self._client.aclose()
            self._client = None

    async def list_folder_images(self, folder_id: str) -> list[DriveImage]:
        if not settings.GOOGLE_API_KEY:
            return []

        cached = self._cache.get(folder_id)
        now = time.monotonic()
        if cached is not None and cached.expires_at > now:
            return cached.images

        images = await self._fetch_folder_images(folder_id)
        self._cache[folder_id] = _CacheEntry(
            images=images, expires_at=now + _CACHE_TTL_SECONDS
        )
        return images

    async def _fetch_folder_images(self, folder_id: str) -> list[DriveImage]:
        assert self._client is not None, "GoogleDriveClient.start() was never called"
        params = {
            "q": f"'{folder_id}' in parents and mimeType contains 'image/' and trashed=false",
            "fields": "files(id,name,description)",
            "orderBy": "name",
            "pageSize": "200",
            "key": settings.GOOGLE_API_KEY,
        }
        try:
            response = await self._client.get(_DRIVE_FILES_ENDPOINT, params=params)
            response.raise_for_status()
            data = response.json()
        except (httpx.HTTPError, ValueError) as exc:
            logger.warning(
                "Google Drive folder listing failed for {}: {}", folder_id, exc
            )
            return []

        return [
            DriveImage(file_id=item["id"], caption=item.get("description"))
            for item in data.get("files", [])
            if item.get("id")
        ]


drive_client = GoogleDriveClient()
