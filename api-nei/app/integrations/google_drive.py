"""Read-only client for listing images inside a public Google Drive folder.

Editors link a shared Drive folder from Directus (history.drive_folder_url);
this module resolves that link to a list of viewable image URLs at read
time. It never uploads, writes, or requires an OAuth user — only a
Drive-API-restricted API key (settings.GOOGLE_API_KEY).

Photos are served from Drive, not copied into our storage: image URLs point
at `settings.DRIVE_IMAGE_BASE_URL` (Google's lh3 host by default, or an
nginx caching proxy in front of it in production).

Failure is always soft: a bad link, a private folder, a missing key, or an
API error all resolve to an empty image list rather than raising, because a
photo gallery must never break the milestone it belongs to. The result
carries a `status` so callers can still tell "empty" from "broken".

Every fetch runs under a total time budget (`FOLDER_FETCH_BUDGET_SECONDS`)
that is shorter than web-nei's request timeout: a slow Drive answers with
the photos listed so far (`truncated`) instead of paging on after the
browser has already given up.

Folders inside Shared Drives are only visible to the API when the request
opts in (`supportsAllDrives` / `includeItemsFromAllDrives`); both flags are
no-ops for ordinary My Drive folders.

The API key travels in the `X-Goog-Api-Key` header, never the query string,
and errors are logged by status code only — an httpx error's message
includes the request URL, which must never reach the logs.
"""
from __future__ import annotations

import asyncio
import re
import time
from dataclasses import dataclass, field
from typing import Literal, Optional
from urllib.parse import ParseResult, urlparse

import httpx
from loguru import logger

from app.core.config import settings

_DRIVE_HOSTS = {"drive.google.com", "docs.google.com"}
_FOLDER_PATH_RE = re.compile(r"/folders/([A-Za-z0-9_-]{10,})")
# A single-file link: `/file/d/<id>` in the path, or `?id=<id>` (open/uc
# links). One pattern serves Python *and* PostgreSQL (`~`): the timeline
# counts usable `history_media` rows in SQL, and that count must agree with
# what `extract_file_id` later accepts. Only syntax both engines read alike:
# no named groups, and `\Z` (Python's `$` also matches before a final "\n").
DRIVE_FILE_URL_PATTERN = (
    r"^https?://(?:drive|docs)\.google\.com"
    r"(?:(?:/[^?#]*)?/file/d/([A-Za-z0-9_-]{10,})"
    r"|(?:/[^?#]*)?\?(?:[^#]*&)?id=([A-Za-z0-9_-]{10,})(?:[&#]|\Z))"
)
_FILE_URL_RE = re.compile(DRIVE_FILE_URL_PATTERN)

_DRIVE_FILES_ENDPOINT = "https://www.googleapis.com/drive/v3/files"
_FOLDER_MIME_TYPE = "application/vnd.google-apps.folder"
_THUMB_WIDTH = 600
_FULL_WIDTH = 2000
# Hard cap on photos per folder: Drive pages are followed until this many,
# and a larger folder is reported as `truncated`.
MAX_FOLDER_IMAGES = 500
_PAGE_SIZE = 200
# web-nei gives up on a request after 5s: the whole folder fetch (metadata +
# every listing page) must answer before that, and no single request may eat
# the whole budget.
FOLDER_FETCH_BUDGET_SECONDS = 4.0
_REQUEST_TIMEOUT_SECONDS = 3.0
_SHARED_DRIVE_PARAMS = {"supportsAllDrives": "true"}

# A working folder is stable; a broken one is usually fixed by an editor
# re-sharing it, so it is retried sooner; a transient error sooner still.
_TTL_OK_SECONDS = 10 * 60
_TTL_UNAVAILABLE_SECONDS = 5 * 60
_TTL_ERROR_SECONDS = 60
_CACHE_MAX_ENTRIES = 256

DriveStatus = Literal["ok", "unavailable", "error", "disabled"]
"""`unavailable`: the folder is private, deleted, or not a folder (Drive
answers 404 for all of these to an anonymous API key). `error`: Drive or
the network failed, or the API key was rejected. `disabled`: no API key."""


def drive_image_url(file_id: str, width: int) -> str:
    return f"{settings.DRIVE_IMAGE_BASE_URL}{file_id}=w{width}"


@dataclass(frozen=True)
class DriveImage:
    file_id: str
    caption: Optional[str] = None
    width: Optional[int] = None
    height: Optional[int] = None

    @property
    def thumb_url(self) -> str:
        return drive_image_url(self.file_id, _THUMB_WIDTH)

    @property
    def url(self) -> str:
        return drive_image_url(self.file_id, _FULL_WIDTH)


@dataclass(frozen=True)
class DriveFolderResult:
    status: DriveStatus
    images: tuple[DriveImage, ...] = ()
    # More photos exist than `images` holds: the folder is over
    # MAX_FOLDER_IMAGES, or Drive was too slow to list all of it in time.
    truncated: bool = False


def extract_folder_id(url: str) -> Optional[str]:
    """Return the folder id from a drive.google.com folder link, or None."""
    return _extract_id(url, _FOLDER_PATH_RE)


def extract_file_id(url: str) -> Optional[str]:
    """Return the file id from a drive.google.com single-file link, or None."""
    match = _FILE_URL_RE.match(url or "")
    if match is None:
        return None
    return match.group(1) or match.group(2)


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


def _image_from_item(item: dict) -> DriveImage:
    meta = item.get("imageMediaMetadata") or {}
    width, height = meta.get("width"), meta.get("height")
    # Drive reports the stored dimensions; a 90°/270° rotation swaps them
    # for display.
    if meta.get("rotation") in (1, 3):
        width, height = height, width
    return DriveImage(
        file_id=item["id"],
        caption=item.get("description") or None,
        width=width,
        height=height,
    )


def _sort_key(item: dict) -> tuple[int, str, str]:
    """Photos with an EXIF capture time first, in capture order; the rest
    after them, by file name (so editors can still order undated scans by
    renaming them)."""
    taken = (item.get("imageMediaMetadata") or {}).get("time")
    return (0 if taken else 1, taken or "", item.get("name") or "")


class _DriveHTTPError(Exception):
    def __init__(self, status_code: int) -> None:
        super().__init__(status_code)
        self.status_code = status_code


class _NotAFolder(Exception):
    pass


@dataclass
class _Listing:
    """Filled page by page, so a fetch cut short by the time budget still
    has whatever it listed before the deadline."""

    items: list[dict] = field(default_factory=list)
    has_more: bool = False


@dataclass
class _CacheEntry:
    result: DriveFolderResult
    expires_at: float


class GoogleDriveClient:
    """Thin wrapper around the Drive v3 `files` endpoints, with a small
    in-memory cache (per worker process) so opening the same gallery
    repeatedly, or the list endpoint counting every gallery, doesn't hammer
    the Drive API."""

    def __init__(
        self,
        transport: httpx.AsyncBaseTransport | None = None,
        budget_seconds: float = FOLDER_FETCH_BUDGET_SECONDS,
    ) -> None:
        self._transport = transport
        self._budget_seconds = budget_seconds
        self._client: httpx.AsyncClient | None = None
        self._cache: dict[str, _CacheEntry] = {}
        self._inflight: dict[str, asyncio.Task[DriveFolderResult]] = {}

    def start(self) -> None:
        if self._client is None:
            self._client = httpx.AsyncClient(
                timeout=httpx.Timeout(_REQUEST_TIMEOUT_SECONDS),
                transport=self._transport,
            )

    async def close(self) -> None:
        if self._client is not None:
            await self._client.aclose()
            self._client = None

    async def list_folder(self, folder_id: str) -> DriveFolderResult:
        if not settings.GOOGLE_API_KEY or self._client is None:
            return DriveFolderResult(status="disabled")

        cached = self._cache.get(folder_id)
        if cached is not None and cached.expires_at > time.monotonic():
            return cached.result

        # One fetch per folder at a time; shielded so a caller that goes away
        # (client disconnect) doesn't cancel it — it is bounded by the fetch
        # budget anyway, and still lands in the cache for the next request.
        task = self._inflight.get(folder_id)
        if task is None:
            task = asyncio.create_task(self._fetch_and_store(folder_id))
            self._inflight[folder_id] = task
            task.add_done_callback(lambda _: self._inflight.pop(folder_id, None))
        return await asyncio.shield(task)

    async def _fetch_and_store(self, folder_id: str) -> DriveFolderResult:
        result = await self._fetch_folder(folder_id)
        self._store(folder_id, result, time.monotonic())
        return result

    def _store(self, folder_id: str, result: DriveFolderResult, now: float) -> None:
        if result.status == "ok" and not result.truncated:
            ttl = _TTL_OK_SECONDS
        elif result.status == "unavailable":
            ttl = _TTL_UNAVAILABLE_SECONDS
        else:
            # Errors and partial listings: Drive may answer in full next time.
            ttl = _TTL_ERROR_SECONDS
        self._cache.pop(folder_id, None)
        while len(self._cache) >= _CACHE_MAX_ENTRIES:
            # dicts keep insertion order: drop the oldest entry.
            self._cache.pop(next(iter(self._cache)))
        self._cache[folder_id] = _CacheEntry(result=result, expires_at=now + ttl)

    async def _fetch_folder(self, folder_id: str) -> DriveFolderResult:
        listing = _Listing()
        try:
            await asyncio.wait_for(
                self._list_folder_into(folder_id, listing), self._budget_seconds
            )
        except asyncio.TimeoutError:
            logger.warning(
                "Google Drive listing for folder {} exceeded {}s; {} photos listed",
                folder_id,
                self._budget_seconds,
                len(listing.items),
            )
            if not listing.items:
                return DriveFolderResult(status="error")
            return _folder_result(listing.items, truncated=True)
        except _NotAFolder:
            return DriveFolderResult(status="unavailable")
        except _DriveHTTPError as exc:
            if exc.status_code == 404:
                return DriveFolderResult(status="unavailable")
            logger.warning(
                "Google Drive request for folder {} failed with HTTP {}",
                folder_id,
                exc.status_code,
            )
            return DriveFolderResult(status="error")
        except (httpx.HTTPError, ValueError, KeyError, TypeError) as exc:
            logger.warning(
                "Google Drive request for folder {} failed: {}",
                folder_id,
                type(exc).__name__,
            )
            return DriveFolderResult(status="error")

        return _folder_result(listing.items, truncated=listing.has_more)

    async def _list_folder_into(self, folder_id: str, listing: _Listing) -> None:
        folder = await self._get(
            f"{_DRIVE_FILES_ENDPOINT}/{folder_id}",
            {"fields": "id,mimeType", **_SHARED_DRIVE_PARAMS},
        )
        if folder.get("mimeType") != _FOLDER_MIME_TYPE:
            raise _NotAFolder()

        page_token: Optional[str] = None
        while True:
            params = {
                "q": f"'{folder_id}' in parents and mimeType contains 'image/' and trashed=false",
                "fields": "nextPageToken,files(id,name,description,"
                "imageMediaMetadata(width,height,rotation,time))",
                "pageSize": str(_PAGE_SIZE),
                "includeItemsFromAllDrives": "true",
                **_SHARED_DRIVE_PARAMS,
            }
            if page_token:
                params["pageToken"] = page_token
            data = await self._get(_DRIVE_FILES_ENDPOINT, params)
            listing.items.extend(item for item in data.get("files", []) if item.get("id"))
            page_token = data.get("nextPageToken")
            if len(listing.items) >= MAX_FOLDER_IMAGES:
                listing.has_more = bool(page_token) or len(listing.items) > MAX_FOLDER_IMAGES
                del listing.items[MAX_FOLDER_IMAGES:]
                return
            if not page_token:
                return

    async def _get(self, url: str, params: dict[str, str]) -> dict:
        assert self._client is not None
        response = await self._client.get(
            url, params=params, headers={"X-Goog-Api-Key": settings.GOOGLE_API_KEY}
        )
        if response.status_code >= 400:
            raise _DriveHTTPError(response.status_code)
        return response.json()


def _folder_result(items: list[dict], truncated: bool) -> DriveFolderResult:
    ordered = sorted(items, key=_sort_key)
    return DriveFolderResult(
        status="ok",
        images=tuple(_image_from_item(item) for item in ordered),
        truncated=truncated,
    )


drive_client = GoogleDriveClient()
