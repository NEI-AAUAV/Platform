from io import BytesIO
from typing import List, Union, Dict, Any
from PIL import Image, ImageOps
from fastapi.encoders import jsonable_encoder
from sqlalchemy.orm import Session, noload

from app.crud.base import CRUDBase
from app.schemas.modality import ModalityCreate, ModalityUpdate
from app.models.modality import Modality
from app.core.logging import logger


class CRUDModality(CRUDBase[Modality, ModalityCreate, ModalityUpdate]):

    async def save_image(self, image: Image, name: str) -> str:
        img_data = await image.read()
        img = Image.open(BytesIO(img_data))
        ext = img.format
        if not ext in ('JPEG', 'PNG'):
            raise Exception("Invalid Image Format")

        # handle EXIF orientation tag
        img = ImageOps.exif_transpose(img)

        # convert image mode to RGB to allow JPEG conversion
        img = img.convert("RGB")

        # save optimized image on static folder
        img_path = f"/modality/{name}"
        img.save(f"static{img_path}",
                 format="JPEG",
                 quality="web_high",
                 optimize=True,
                 progressive=True)
        return img_path

    def get_multi(
        self, db: Session, *, skip: int = None, limit: int = None
    ) -> List[Modality]:
        return db.query(self.model).options(
            noload('*')).offset(skip).limit(limit).all()

    async def create(
        self, db: Session, *, obj_in: ModalityCreate, image: Image
    ) -> Modality:
        db_obj = super().create(db=db, obj_in=obj_in)
        img_url = await self.save_image(image, db_obj.id)
        setattr(db_obj, 'image', img_url)
        db.add(db_obj)
        db.commit()
        return db_obj

    async def update(
        self,
        db: Session,
        *,
        db_obj: Modality,
        obj_in: Union[ModalityUpdate, Dict[str, Any]],
        image: Image = None
    ) -> Modality:
        db_obj = super().update(db=db, db_obj=db_obj, obj_in=obj_in)
        img_url = await self.save_image(image, db_obj.id)
        setattr(db_obj, 'image', img_url)
        db.add(db_obj)
        db.commit()
        return db_obj


modality = CRUDModality(Modality)
