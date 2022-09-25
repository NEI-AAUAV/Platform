from io import BytesIO
import re
from typing import List, Optional
from PIL import Image, ImageOps
from fastapi import UploadFile
from sqlalchemy.orm import Session, noload

from app.crud.base import CRUDBase
from app.schemas.course import CourseCreate, CourseUpdate
from app.models.course import Course
from app.core.logging import logger


class CRUDCourse(CRUDBase[Course, CourseCreate, CourseUpdate]):

    SVG_R = r'(?:<\?xml\b[^>]*>[^<]*)?(?:<!--.*?-->[^<]*)*(?:<svg|<!DOCTYPE svg)\b'
    SVG_RE = re.compile(SVG_R, re.DOTALL)

    async def update_image(
        self,
        db: Session,
        *,
        db_obj: Course,
        image: Optional[UploadFile],
    ) -> Course:
        img_path = None
        if image:
            img_data = await image.read()
            # Avoid any conversion exception
            img_str = img_data.decode('latin_1')

            # Check if is SVG
            if self.SVG_RE.match(img_str) is not None:
                img_path = f"/course/{db_obj.id}.svg"
                with open(f"static{img_path}", 'w') as f:
                    f.write(img_str)
            else:
                img = Image.open(BytesIO(img_data))
                ext = img.format
                if not ext in ('JPEG', 'PNG'):
                    raise Exception("Invalid Image Format")

                # TODO: rescale if necessary

                # Handle EXIF orientation tag
                img = ImageOps.exif_transpose(img)

                # Convert image mode to RGB to allow JPEG conversion
                img = img.convert("RGB")

                # Save optimized image on static folder
                img_path = f"/course/{db_obj.id}.{ext.lower()}"
                img.save(f"static{img_path}",
                        format='JPEG',
                        quality='web_high',
                        optimize=True,
                        progressive=True)

        setattr(db_obj, 'image', img_path)
        db.add(db_obj)
        db.commit()
        return db_obj


course = CRUDCourse(Course)
