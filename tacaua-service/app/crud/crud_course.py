from io import BytesIO
from typing import List, Optional
from PIL import Image, ImageOps
from fastapi import UploadFile
from sqlalchemy.orm import Session, noload

from app.crud.base import CRUDBase
from app.schemas.course import CourseCreate, CourseUpdate
from app.models.course import Course
from app.core.logging import logger


class CRUDCourse(CRUDBase[Course, CourseCreate, CourseUpdate]):

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
            img = Image.open(BytesIO(img_data))
            ext = img.format
            logger.debug(ext)
            if not ext in ('JPEG', 'PNG', 'SVG'):
                raise Exception("Invalid Image Format")

            # TODO: rescale if necessary

            # handle EXIF orientation tag
            img = ImageOps.exif_transpose(img)

            # convert image mode to RGB to allow JPEG conversion
            img = img.convert("RGB")

            # save optimized image on static folder
            img_path = f"/course/{db_obj.id}"
            img.save(f"static{img_path}",
                    format="JPEG",
                    quality="web_high",
                    optimize=True,
                    progressive=True)

        setattr(db_obj, 'image', img_path)
        db.add(db_obj)
        db.commit()
        return db_obj


course = CRUDCourse(Course)
