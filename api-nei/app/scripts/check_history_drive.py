"""Report published milestones whose Google Drive gallery folder is broken.

A broken folder never errors on the site — the gallery just shows fewer
photos — so editors have no other way to notice one. Run inside the api-nei
container:

    python -m app.scripts.check_history_drive

Exits 1 when any folder is not `ok`, so it can back a scheduled check.
"""
from __future__ import annotations

import asyncio
import sys

from sqlalchemy import select

from app.core.config import settings
from app.db.session import SessionLocal
from app.integrations.google_drive import GoogleDriveClient, extract_folder_id
from app.models.history import History


def _linked_folders() -> list[tuple[int, str, str]]:
    with SessionLocal() as db:
        rows = db.execute(
            select(History.id, History.title, History.drive_folder_url)
            .where(History.published.is_(True), History.drive_folder_url.is_not(None))
            .order_by(History.moment.desc())
        ).all()
    return [(id_, title, url) for id_, title, url in rows if url]


async def _check(rows: list[tuple[int, str, str]]) -> int:
    client = GoogleDriveClient()
    client.start()
    broken = 0
    try:
        for id_, title, url in rows:
            folder_id = extract_folder_id(url)
            if folder_id is None:
                status, count = "invalid-link", 0
            else:
                result = await client.list_folder(folder_id)
                status, count = result.status, len(result.images)
            if status != "ok":
                broken += 1
            print(f"{status:<13} {count:>4} fotos  #{id_} {title}")
    finally:
        await client.close()
    return broken


def main() -> int:
    if not settings.GOOGLE_API_KEY:
        print("GOOGLE_API_KEY is not set: Drive galleries are disabled.", file=sys.stderr)
        return 1
    rows = _linked_folders()
    broken = asyncio.run(_check(rows))
    print(f"\n{len(rows)} pastas verificadas, {broken} com problemas.")
    return 1 if broken else 0


if __name__ == "__main__":
    sys.exit(main())
