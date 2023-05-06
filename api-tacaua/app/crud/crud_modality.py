from io import BytesIO
from typing import List, Optional

from PIL import Image, ImageOps
from fastapi import UploadFile
from sqlalchemy.orm import Session, noload

from app.exception import ImageFormatException
from app.crud.base import CRUDBase
from app.schemas.modality import ModalityCreate, ModalityUpdate
from app.models.modality import Modality


class CRUDModality(CRUDBase[Modality, ModalityCreate, ModalityUpdate]):

    async def update_image(
        self,
        db: Session,
        *,
        db_obj: Modality,
        image: Optional[UploadFile],
    ) -> Modality:
        # TODO: should allow SVG
        img_path = None
        if image:
            try:
                img_data = await image.read()
                img = Image.open(BytesIO(img_data))
            except:
                raise ImageFormatException()
            ext = img.format
            if not ext in ('JPEG', 'PNG'):
                raise ImageFormatException()

            # TODO: rescale if necessary

            # Handle EXIF orientation tag
            img = ImageOps.exif_transpose(img)

            # Convert image mode to RGB to allow JPEG conversion
            img = img.convert("RGB")

            # Save optimized image on static folder
            img_path = f"/modality/{db_obj.id}.{ext.lower()}"
            img.save(f"static{img_path}",
                    format='JPEG',
                    quality='web_high',
                    optimize=True,
                    progressive=True)

        setattr(db_obj, 'image', img_path)
        db.add(db_obj)
        db.commit()
        return db_obj

    def get_multi(
        self, db: Session, *, skip: int = None, limit: int = None
    ) -> List[Modality]:
        return db.query(self.model).options(
            noload('*')).offset(skip).limit(limit).all()


modality = CRUDModality(Modality)
