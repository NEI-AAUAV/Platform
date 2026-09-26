import asyncio

import httpx
import pytest

from app.core.config import settings
from app.integrations.google_drive import (
    GoogleDriveClient,
    extract_file_id,
    extract_folder_id,
)


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


def test_list_folder_images_returns_empty_without_api_key(monkeypatch) -> None:
    monkeypatch.setattr(settings, "GOOGLE_API_KEY", "")
    client = GoogleDriveClient(httpx.MockTransport(lambda _: httpx.Response(200)))
    client.start()

    assert _run(client.list_folder_images("folder-id")) == []


def test_list_folder_images_success(monkeypatch) -> None:
    monkeypatch.setattr(settings, "GOOGLE_API_KEY", "secret")

    def handler(request: httpx.Request) -> httpx.Response:
        assert "1AbC" in str(request.url)
        return httpx.Response(
            200,
            json={
                "files": [
                    {"id": "file1", "name": "a.jpg", "description": "Caption A"},
                    {"id": "file2", "name": "b.jpg"},
                ]
            },
        )

    client = GoogleDriveClient(httpx.MockTransport(handler))
    client.start()

    images = _run(client.list_folder_images("1AbC"))
    assert [i.file_id for i in images] == ["file1", "file2"]
    assert images[0].caption == "Caption A"
    assert images[0].thumb_url == "https://lh3.googleusercontent.com/d/file1=w600"
    assert images[0].url == "https://lh3.googleusercontent.com/d/file1=w2000"


def test_list_folder_images_caches_result(monkeypatch) -> None:
    monkeypatch.setattr(settings, "GOOGLE_API_KEY", "secret")
    calls = 0

    def handler(request: httpx.Request) -> httpx.Response:
        nonlocal calls
        calls += 1
        return httpx.Response(200, json={"files": [{"id": "file1"}]})

    client = GoogleDriveClient(httpx.MockTransport(handler))
    client.start()

    _run(client.list_folder_images("folder-id"))
    _run(client.list_folder_images("folder-id"))
    assert calls == 1


@pytest.mark.parametrize("upstream_status", [403, 404, 500])
def test_list_folder_images_upstream_error_is_empty(monkeypatch, upstream_status: int) -> None:
    monkeypatch.setattr(settings, "GOOGLE_API_KEY", "secret")
    client = GoogleDriveClient(
        httpx.MockTransport(lambda _: httpx.Response(upstream_status, text="nope"))
    )
    client.start()

    assert _run(client.list_folder_images("folder-id")) == []


def test_list_folder_images_invalid_json_is_empty(monkeypatch) -> None:
    monkeypatch.setattr(settings, "GOOGLE_API_KEY", "secret")
    client = GoogleDriveClient(
        httpx.MockTransport(lambda _: httpx.Response(200, text="not-json"))
    )
    client.start()

    assert _run(client.list_folder_images("folder-id")) == []


def test_list_folder_images_timeout_is_empty(monkeypatch) -> None:
    monkeypatch.setattr(settings, "GOOGLE_API_KEY", "secret")

    def timeout(request: httpx.Request) -> httpx.Response:
        raise httpx.ReadTimeout("slow", request=request)

    client = GoogleDriveClient(httpx.MockTransport(timeout))
    client.start()

    assert _run(client.list_folder_images("folder-id")) == []
