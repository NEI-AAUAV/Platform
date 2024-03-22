import io
import json
import struct
import zipfile
from enum import Enum
from pathlib import Path
from typing import Callable, Set, Type, TypeVar, Optional, Any

from pydantic import BaseModel, create_model, model_validator
from pydantic_core import PydanticUndefined


# Path of the project root
# WARNING: If utils.py is moved this will break
ROOT_DIR = Path(__file__).resolve().parents[1]


class EnumList(Enum):
    @classmethod
    def list(cls):
        return list(map(lambda c: c.value, cls))


def include(fields: list[str]):
    """
    This decorator allows you to include default fields in the dictionary,
    and bypass the exclude_unset and exclude_none parameters.

    Usefult for fields like `created_at` and `updated_at`.
    """

    def decorator(cls: Type[BaseModel]):
        def model_dump(self, *args, **kwargs):
            # Get a dictionary representation of the model object
            d = super(cls, self).model_dump(*args, **kwargs)

            # Include fields in the dictionary
            # regardless of exclude_unset and exclude_none parameters
            for field in fields:
                if field not in d:
                    d[field] = getattr(self, field)

            return d

        cls.model_dump = model_dump
        return cls

    return decorator


class ValidateFromJson:
    """Validates schemas that are stringified.

    This is useful to validate requests with a form data containing an image
    file and a schema stringified.
    """

    @model_validator(mode="before")
    @classmethod
    def load_from_json(cls, data: Any) -> Any:
        if isinstance(data, dict):
            return data
        return json.loads(data)


class CustomZipFile(zipfile.ZipFile):
    # FIXME: this is a temporary solution that overrides the method _RealGetContents
    # to fix a bug about insuficient encoding types in the original ZipFile class.
    def _RealGetContents(self):
        """Read in the table of contents for the ZIP file."""
        fp = self.fp
        try:
            endrec = zipfile._EndRecData(fp)
        except OSError:
            raise zipfile.BadZipFile("File is not a zip file")
        if not endrec:
            raise zipfile.BadZipFile("File is not a zip file")
        size_cd = endrec[zipfile._ECD_SIZE]  # bytes in central directory
        offset_cd = endrec[zipfile._ECD_OFFSET]  # offset of central directory
        self._comment = endrec[zipfile._ECD_COMMENT]  # archive comment

        # "concat" is zero, unless zip was concatenated to another file
        concat = endrec[zipfile._ECD_LOCATION] - size_cd - offset_cd
        if endrec[zipfile._ECD_SIGNATURE] == zipfile.stringEndArchive64:
            # If Zip64 extension structures are present, account for them
            concat -= zipfile.sizeEndCentDir64 + zipfile.sizeEndCentDir64Locator

        # self.start_dir:  Position of start of central directory
        self.start_dir = offset_cd + concat
        if self.start_dir < 0:
            raise zipfile.BadZipFile("Bad offset for central directory")
        fp.seek(self.start_dir, 0)
        data = fp.read(size_cd)
        fp = io.BytesIO(data)
        total = 0
        while total < size_cd:
            centdir = fp.read(zipfile.sizeCentralDir)
            if len(centdir) != zipfile.sizeCentralDir:
                raise zipfile.BadZipFile("Truncated central directory")
            centdir = struct.unpack(zipfile.structCentralDir, centdir)
            if centdir[zipfile._CD_SIGNATURE] != zipfile.stringCentralDir:
                raise zipfile.BadZipFile("Bad magic number for central directory")
            filename = fp.read(centdir[zipfile._CD_FILENAME_LENGTH])

            for encoding in ("utf-8", "cp1252", "cp437"):
                try:
                    filename = filename.decode(encoding)
                    break
                except UnicodeDecodeError:
                    continue

            # Create ZipInfo instance to store file information
            x = zipfile.ZipInfo(filename)
            x.extra = fp.read(centdir[zipfile._CD_EXTRA_FIELD_LENGTH])
            x.comment = fp.read(centdir[zipfile._CD_COMMENT_LENGTH])
            x.header_offset = centdir[zipfile._CD_LOCAL_HEADER_OFFSET]
            (
                x.create_version,
                x.create_system,
                x.extract_version,
                x.reserved,
                x.flag_bits,
                x.compress_type,
                t,
                d,
                x.CRC,
                x.compress_size,
                x.file_size,
            ) = centdir[1:12]
            if x.extract_version > zipfile.MAX_EXTRACT_VERSION:
                raise NotImplementedError(
                    "zip file version %.1f" % (x.extract_version / 10)
                )
            x.volume, x.internal_attr, x.external_attr = centdir[15:18]
            # Convert date/time code to (year, month, day, hour, min, sec)
            x._raw_time = t
            x.date_time = (
                (d >> 9) + 1980,
                (d >> 5) & 0xF,
                d & 0x1F,
                t >> 11,
                (t >> 5) & 0x3F,
                (t & 0x1F) * 2,
            )

            x._decodeExtra()
            x.header_offset = x.header_offset + concat
            self.filelist.append(x)
            self.NameToInfo[x.filename] = x

            # update total bytes read from central directory
            total = (
                total
                + zipfile.sizeCentralDir
                + centdir[zipfile._CD_FILENAME_LENGTH]
                + centdir[zipfile._CD_EXTRA_FIELD_LENGTH]
                + centdir[zipfile._CD_COMMENT_LENGTH]
            )


def list_zip_contents(zip_file):
    contents = []
    with CustomZipFile(zip_file, "r") as zip_obj:
        for file in zip_obj.namelist():
            contents.append(file)
    return contents


_C = TypeVar("_C", bound=BaseModel)


def optional(*, exclude: Set[str] = set()) -> Callable[[Type[_C]], Type[_C]]:
    """Decorator function used to modify a pydantic model's fields to all be optional.

    Can also define fields to exclude from being optional.

    Based on https://github.com/pydantic/pydantic/issues/1223#issuecomment-1728386617
    """

    def dec(_cls: Type[_C]) -> Type[_C]:
        for field, field_info in _cls.model_fields.items():
            if field in exclude or field_info.annotation is None:
                continue

            field_info.annotation = Optional[field_info.annotation]
            field_info.default = None

        # The model was changed so the schema needs to rebuilt
        _cls.model_rebuild(force=True)
        return _cls

    return dec
