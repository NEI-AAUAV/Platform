import asyncio

import httpx
import pytest

from app.core.config import settings
from loguru import logger

from app.integrations.google_drive import (
    MAX_FOLDER_IMAGES,
    GoogleDriveClient,
    extract_file_id,
    extract_folder_id,
)

FOLDER = "1AbCdEfGhIjK"
FOLDER_META = {"id": FOLDER, "mimeType": "application/vnd.google-apps.folder"}


@pytest.fixture(autouse=True)
def lh3_image_urls(monkeypatch):
    """Pin the Drive image prefix: deployments override it (nginx proxy)."""
    monkeypatch.setattr(settings, "DRIVE_IMAGE_BASE_URL", "https://lh3.googleusercontent.com/d/")


def _run(coro):
    return asyncio.run(coro)


@pytest.mark.parametrize(
    "url,expected",
    [
        ("https://drive.google.com/drive/folders/1AbCdEfGhIjK", "1AbCdEfGhIjK"),
        (
            "https://drive.google.com/drive/folders/1AbCdEfGhIjK?usp=sharing",
            "1AbCdEfGhIjK",
        ),
        ("https://drive.google.com/file/d/1AbCdEfGhIjK/view", None),
        ("not a url", None),
        ("", None),
        ("https://evil.example.com/drive/folders/1AbCdEfGhIjK", None),
    ],
)
def test_extract_folder_id(url: str, expected: str | None) -> None:
    assert extract_folder_id(url) == expected


@pytest.mark.parametrize(
    "url,expected",
    [
        ("https://drive.google.com/file/d/1AbCdEfGhIjK/view?usp=sharing", "1AbCdEfGhIjK"),
        ("https://drive.google.com/open?id=1AbCdEfGhIjK", "1AbCdEfGhIjK"),
        ("https://drive.google.com/uc?id=1AbCdEfGhIjK&export=download", "1AbCdEfGhIjK"),
        ("https://drive.google.com/drive/folders/1AbCdEfGhIjK", None),
        ("https://example.com/file/d/1AbCdEfGhIjK/view", None),
    ],
)
def test_extract_file_id(url: str, expected: str | None) -> None:
    assert extract_file_id(url) == expected


def _drive(files_pages: list[dict], folder_meta: dict | None = FOLDER_META, calls=None):
    """MockTransport imitating Drive: `files/<id>` answers the folder
    metadata, `files` answers the listing, one page per call."""
    pages = iter(files_pages)

    def handler(request: httpx.Request) -> httpx.Response:
        if calls is not None:
            calls.append(request)
        if request.url.path.endswith(f"/files/{FOLDER}"):
            if folder_meta is None:
                return httpx.Response(404, json={"error": "notFound"})
            return httpx.Response(200, json=folder_meta)
        return httpx.Response(200, json=next(pages))

    return httpx.MockTransport(handler)


def _client(transport: httpx.MockTransport) -> GoogleDriveClient:
    client = GoogleDriveClient(transport)
    client.start()
    return client


@pytest.fixture
def api_key(monkeypatch) -> str:
    monkeypatch.setattr(settings, "GOOGLE_API_KEY", "AIzaSecretKey")
    return "AIzaSecretKey"


def test_list_folder_is_disabled_without_api_key(monkeypatch) -> None:
    monkeypatch.setattr(settings, "GOOGLE_API_KEY", "")
    client = _client(httpx.MockTransport(lambda _: httpx.Response(200)))

    result = _run(client.list_folder(FOLDER))
    assert result.status == "disabled"
    assert result.images == ()


def test_list_folder_is_disabled_when_client_never_started(api_key) -> None:
    assert _run(GoogleDriveClient().list_folder(FOLDER)).status == "disabled"


def test_list_folder_success(api_key) -> None:
    client = _client(
        _drive(
            [
                {
                    "files": [
                        {"id": "file1", "name": "a.jpg", "description": "Caption A"},
                        {"id": "file2", "name": "b.jpg"},
                    ]
                }
            ]
        )
    )

    result = _run(client.list_folder(FOLDER))
    assert result.status == "ok"
    assert [i.file_id for i in result.images] == ["file1", "file2"]
    assert result.images[0].caption == "Caption A"
    assert result.images[1].caption is None
    assert result.images[0].thumb_url == "https://lh3.googleusercontent.com/d/file1=w600"
    assert result.images[0].url == "https://lh3.googleusercontent.com/d/file1=w2000"


def test_image_urls_follow_the_configured_base(api_key, monkeypatch) -> None:
    monkeypatch.setattr(settings, "DRIVE_IMAGE_BASE_URL", "https://nei.example/drive-img/")
    client = _client(_drive([{"files": [{"id": "file1"}]}]))

    image = _run(client.list_folder(FOLDER)).images[0]
    assert image.thumb_url == "https://nei.example/drive-img/file1=w600"


def test_api_key_is_sent_as_header_never_in_the_url(api_key) -> None:
    calls: list[httpx.Request] = []
    client = _client(_drive([{"files": []}], calls=calls))

    _run(client.list_folder(FOLDER))
    assert calls
    for request in calls:
        assert request.headers["X-Goog-Api-Key"] == api_key
        assert api_key not in str(request.url)


def test_dimensions_are_returned_and_swapped_for_rotated_photos(api_key) -> None:
    client = _client(
        _drive(
            [
                {
                    "files": [
                        {"id": "land", "imageMediaMetadata": {"width": 4000, "height": 3000, "time": "2020:01:01 10:00:00"}},
                        {"id": "rot", "imageMediaMetadata": {"width": 4000, "height": 3000, "rotation": 1, "time": "2020:01:01 11:00:00"}},
                    ]
                }
            ]
        )
    )

    land, rot = _run(client.list_folder(FOLDER)).images
    assert (land.width, land.height) == (4000, 3000)
    assert (rot.width, rot.height) == (3000, 4000)


def test_photos_are_ordered_by_capture_time_then_name(api_key) -> None:
    client = _client(
        _drive(
            [
                {
                    "files": [
                        {"id": "undated-b", "name": "b.jpg"},
                        {"id": "late", "name": "a.jpg", "imageMediaMetadata": {"time": "2021:05:01 09:00:00"}},
                        {"id": "undated-a", "name": "a.jpg"},
                        {"id": "early", "name": "z.jpg", "imageMediaMetadata": {"time": "2019:05:01 09:00:00"}},
                    ]
                }
            ]
        )
    )

    ids = [i.file_id for i in _run(client.list_folder(FOLDER)).images]
    assert ids == ["early", "late", "undated-a", "undated-b"]


def test_listing_follows_pages(api_key) -> None:
    calls: list[httpx.Request] = []
    client = _client(
        _drive(
            [
                {"files": [{"id": "p1"}], "nextPageToken": "tok"},
                {"files": [{"id": "p2"}]},
            ],
            calls=calls,
        )
    )

    result = _run(client.list_folder(FOLDER))
    assert [i.file_id for i in result.images] == ["p1", "p2"]
    assert calls[-1].url.params["pageToken"] == "tok"


def test_listing_stops_at_the_image_cap_and_says_so(api_key) -> None:
    endless = ({"files": [{"id": f"f{n}-{i}"} for i in range(200)], "nextPageToken": "more"} for n in range(100))
    client = _client(_drive(endless))

    result = _run(client.list_folder(FOLDER))
    assert len(result.images) == MAX_FOLDER_IMAGES
    assert result.truncated is True


def test_a_folder_exactly_at_the_cap_is_not_truncated(api_key) -> None:
    pages = [
        {"files": [{"id": f"a{i}"} for i in range(200)], "nextPageToken": "p2"},
        {"files": [{"id": f"b{i}"} for i in range(200)], "nextPageToken": "p3"},
        {"files": [{"id": f"c{i}"} for i in range(100)]},
    ]
    result = _run(_client(_drive(pages)).list_folder(FOLDER))
    assert len(result.images) == MAX_FOLDER_IMAGES
    assert result.truncated is False


def test_a_complete_listing_is_not_truncated(api_key) -> None:
    result = _run(_client(_drive([{"files": [{"id": "file1"}]}])).list_folder(FOLDER))
    assert result.truncated is False


def test_requests_opt_into_shared_drives(api_key) -> None:
    """Folders inside a Shared Drive are invisible to the API unless each
    request opts in; the flags are harmless for My Drive folders."""
    calls: list[httpx.Request] = []
    _run(_client(_drive([{"files": [{"id": "file1"}]}], calls=calls)).list_folder(FOLDER))

    metadata, listing = calls
    assert metadata.url.params["supportsAllDrives"] == "true"
    assert listing.url.params["supportsAllDrives"] == "true"
    assert listing.url.params["includeItemsFromAllDrives"] == "true"


def _slow_pages(delay_after_first: float):
    """Drive answering the first listing page at once, later ones slowly."""
    served = 0

    async def handler(request: httpx.Request) -> httpx.Response:
        nonlocal served
        if request.url.path.endswith(f"/files/{FOLDER}"):
            return httpx.Response(200, json=FOLDER_META)
        served += 1
        if served > 1:
            await asyncio.sleep(delay_after_first)
        return httpx.Response(200, json={"files": [{"id": f"p{served}"}], "nextPageToken": "more"})

    return httpx.MockTransport(handler)


def test_a_slow_drive_answers_with_the_photos_listed_before_the_budget(api_key) -> None:
    client = GoogleDriveClient(_slow_pages(delay_after_first=5), budget_seconds=0.2)
    client.start()

    result = _run(client.list_folder(FOLDER))
    assert result.status == "ok"
    assert [i.file_id for i in result.images] == ["p1"]
    assert result.truncated is True


def test_a_drive_too_slow_to_list_anything_is_an_error(api_key) -> None:
    async def hang(request: httpx.Request) -> httpx.Response:
        await asyncio.sleep(5)
        return httpx.Response(200, json=FOLDER_META)

    client = GoogleDriveClient(httpx.MockTransport(hang), budget_seconds=0.2)
    client.start()

    result = _run(client.list_folder(FOLDER))
    assert result.status == "error"
    assert result.images == ()


def test_the_fetch_budget_is_below_the_web_client_timeout() -> None:
    from app.integrations import google_drive

    web_nei_timeout_seconds = 5.0  # web-nei/src/services/client.jsx
    assert google_drive.FOLDER_FETCH_BUDGET_SECONDS < web_nei_timeout_seconds
    assert google_drive._REQUEST_TIMEOUT_SECONDS <= google_drive.FOLDER_FETCH_BUDGET_SECONDS


def test_partial_listings_are_retried_sooner_than_complete_ones(api_key) -> None:
    # Not a patched clock: asyncio's own timers (the budget) read it too.
    import time

    from app.integrations import google_drive

    client = GoogleDriveClient(_slow_pages(delay_after_first=5), budget_seconds=0.2)
    client.start()

    _run(client.list_folder(FOLDER))
    remaining = client._cache[FOLDER].expires_at - time.monotonic()
    assert remaining <= google_drive._TTL_ERROR_SECONDS


def test_success_is_cached(api_key) -> None:
    calls: list[httpx.Request] = []
    client = _client(_drive([{"files": [{"id": "file1"}]}], calls=calls))

    _run(client.list_folder(FOLDER))
    _run(client.list_folder(FOLDER))
    assert len(calls) == 2  # folder metadata + one listing page, once


def test_private_or_missing_folder_is_unavailable(api_key) -> None:
    client = _client(_drive([], folder_meta=None))

    result = _run(client.list_folder(FOLDER))
    assert result.status == "unavailable"
    assert result.images == ()


def test_a_file_link_instead_of_a_folder_is_unavailable(api_key) -> None:
    client = _client(_drive([], folder_meta={"id": FOLDER, "mimeType": "image/jpeg"}))

    assert _run(client.list_folder(FOLDER)).status == "unavailable"


@pytest.mark.parametrize("upstream_status", [400, 403, 429, 500])
def test_upstream_error_is_an_error(api_key, upstream_status: int) -> None:
    client = _client(
        httpx.MockTransport(lambda _: httpx.Response(upstream_status, text="nope"))
    )

    result = _run(client.list_folder(FOLDER))
    assert result.status == "error"
    assert result.images == ()


def test_errors_are_retried_sooner_than_successes(api_key, monkeypatch) -> None:
    """A transient failure must not hide the gallery for the full success
    TTL: the next request after the short error TTL tries Drive again."""
    clock = [1000.0]
    monkeypatch.setattr("app.integrations.google_drive.time.monotonic", lambda: clock[0])
    calls = 0

    def handler(request: httpx.Request) -> httpx.Response:
        nonlocal calls
        calls += 1
        return httpx.Response(503)

    client = _client(httpx.MockTransport(handler))

    _run(client.list_folder(FOLDER))
    _run(client.list_folder(FOLDER))
    assert calls == 1  # still cached a moment later

    clock[0] += 61
    _run(client.list_folder(FOLDER))
    assert calls == 2


def test_invalid_json_is_an_error(api_key) -> None:
    client = _client(httpx.MockTransport(lambda _: httpx.Response(200, text="not-json")))

    assert _run(client.list_folder(FOLDER)).status == "error"


def test_timeout_is_an_error(api_key) -> None:
    def timeout(request: httpx.Request) -> httpx.Response:
        raise httpx.ReadTimeout("slow", request=request)

    client = _client(httpx.MockTransport(timeout))

    assert _run(client.list_folder(FOLDER)).status == "error"


@pytest.mark.parametrize("failure", ["status", "transport"])
def test_api_key_never_reaches_the_logs(api_key, failure: str) -> None:
    def handler(request: httpx.Request) -> httpx.Response:
        if failure == "transport":
            raise httpx.ConnectError(f"boom {request.url}", request=request)
        return httpx.Response(403, text=f"bad key {api_key}")

    messages: list[str] = []
    sink = logger.add(lambda m: messages.append(str(m)), level="DEBUG")
    try:
        _run(_client(httpx.MockTransport(handler)).list_folder(FOLDER))
    finally:
        logger.remove(sink)

    assert messages, "the failure should still be logged"
    assert all(api_key not in m for m in messages)
