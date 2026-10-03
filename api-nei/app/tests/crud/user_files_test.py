"""Profile picture and curriculum handling of CRUDUser (no database needed)."""
from io import BytesIO
from pathlib import Path
from types import SimpleNamespace
from unittest.mock import MagicMock

import pytest
from PIL import Image
from starlette.datastructures import UploadFile

from app.crud.crud_user import user as crud_user
from app.exception import FileFormatException

pytestmark = pytest.mark.anyio

PDF = b"%PDF-1.4\n1 0 obj\n<<>>\nendobj\ntrailer\n<<>>\n%%EOF\n"


@pytest.fixture
def anyio_backend() -> str:
    return "asyncio"


@pytest.fixture(autouse=True)
def static_cwd(tmp_path: Path, monkeypatch: pytest.MonkeyPatch) -> Path:
    """The CRUD writes to the relative `static/` dir; sandbox it."""
    monkeypatch.chdir(tmp_path)
    return tmp_path


@pytest.fixture
def db() -> MagicMock:
    return MagicMock()


def _db_user(**kw) -> SimpleNamespace:
    base = dict(id=7, image=None, _image=None, curriculum=None, _curriculum=None)
    return SimpleNamespace(**{**base, **kw})


def _image_bytes(fmt: str = "PNG", mode: str = "RGBA") -> bytes:
    buf = BytesIO()
    Image.new(mode, (4, 4)).save(buf, format=fmt)
    return buf.getvalue()


# --- update_image -----------------------------------------------------------


async def test_image_is_stored_as_jpeg_named_after_its_hash(static_cwd, db) -> None:
    u = _db_user()

    await crud_user.update_image(db, db_obj=u, image=_image_bytes("PNG"))

    assert u.image.startswith("/users/7/") and u.image.endswith(".jpg")
    stored = static_cwd / "static" / u.image.lstrip("/")
    with Image.open(stored) as img:
        assert img.format == "JPEG"
    db.add.assert_called_once_with(u)
    db.flush.assert_called_once()


async def test_same_image_twice_yields_same_path(db) -> None:
    data = _image_bytes("PNG")
    a, b = _db_user(), _db_user()

    await crud_user.update_image(db, db_obj=a, image=data)
    await crud_user.update_image(db, db_obj=b, image=data)

    assert a.image == b.image


async def test_upload_file_objects_are_accepted(db) -> None:
    u = _db_user()
    upload = UploadFile(BytesIO(_image_bytes("JPEG", "RGB")), filename="me.jpg")

    await crud_user.update_image(db, db_obj=u, image=upload)

    assert u.image.endswith(".jpg")


async def test_replacing_image_deletes_the_previous_file(static_cwd, db) -> None:
    u = _db_user()
    await crud_user.update_image(db, db_obj=u, image=_image_bytes("PNG"))
    u._image = previous = u.image

    other = BytesIO()
    Image.new("RGB", (8, 8), "red").save(other, format="PNG")
    await crud_user.update_image(db, db_obj=u, image=other.getvalue())

    assert u.image != previous
    assert not (static_cwd / "static" / previous.lstrip("/")).exists()
    assert (static_cwd / "static" / u.image.lstrip("/")).exists()


async def test_none_removes_image_and_clears_field(static_cwd, db) -> None:
    u = _db_user()
    await crud_user.update_image(db, db_obj=u, image=_image_bytes())
    u._image = u.image
    path = static_cwd / "static" / u.image.lstrip("/")
    assert path.exists()

    await crud_user.update_image(db, db_obj=u, image=None)

    assert u.image is None and not path.exists()


async def test_removing_nonexistent_image_does_not_raise(db) -> None:
    u = _db_user(_image="/users/7/gone.jpg")

    await crud_user.update_image(db, db_obj=u, image=None)

    assert u.image is None


async def test_non_image_bytes_are_rejected(db) -> None:
    with pytest.raises(FileFormatException):
        await crud_user.update_image(db, db_obj=_db_user(), image=b"not an image")
    db.add.assert_not_called()


async def test_unsupported_image_format_is_rejected(db) -> None:
    with pytest.raises(FileFormatException, match="JPEG or PNG"):
        await crud_user.update_image(
            db, db_obj=_db_user(), image=_image_bytes("GIF", "P")
        )


# --- update_curriculum ------------------------------------------------------


def _upload(data: bytes) -> UploadFile:
    return UploadFile(BytesIO(data), filename="cv.pdf")


async def test_pdf_curriculum_is_stored(static_cwd, db) -> None:
    u = _db_user()

    await crud_user.update_curriculum(db, db_obj=u, curriculum=_upload(PDF))

    assert u.curriculum == "/users/7/cv.pdf"
    assert (static_cwd / "static/users/7/cv.pdf").read_bytes() == PDF
    db.flush.assert_called_once()


async def test_non_pdf_curriculum_is_rejected_and_not_stored(static_cwd, db) -> None:
    u = _db_user()

    with pytest.raises(FileFormatException, match="PDF"):
        await crud_user.update_curriculum(
            db, db_obj=u, curriculum=_upload(b"plain text, not a pdf")
        )

    assert not (static_cwd / "static/users/7/cv.pdf").exists()
    assert u.curriculum is None


async def test_none_deletes_existing_curriculum(static_cwd, db) -> None:
    u = _db_user()
    await crud_user.update_curriculum(db, db_obj=u, curriculum=_upload(PDF))
    u._curriculum = u.curriculum

    await crud_user.update_curriculum(db, db_obj=u, curriculum=None)

    assert u.curriculum is None
    assert not (static_cwd / "static/users/7/cv.pdf").exists()


async def test_none_without_existing_curriculum_is_a_noop(db) -> None:
    u = _db_user()

    await crud_user.update_curriculum(db, db_obj=u, curriculum=None)

    assert u.curriculum is None
