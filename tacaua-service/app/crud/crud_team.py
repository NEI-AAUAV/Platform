from io import BytesIO
from typing import Optional

from PIL import Image, ImageOps
from fastapi import UploadFile
from sqlalchemy.orm import Session

from app.exception import ImageFormatException
from app.crud.base import CRUDBase
from app.schemas.team import TeamCreate, TeamUpdate
from app.models.team import Team


class CRUDTeam(CRUDBase[Team, TeamCreate, TeamUpdate]):


    # it would be nice to add a team to a modality and to a group at the same time

    
    async def update_image(
        self,
        db: Session,
        *,
        db_obj: Team,
        image: Optional[UploadFile],
    ) -> Team:
        img_path = None
        if image:
            img_data = await image.read()
            img = Image.open(BytesIO(img_data))
            ext = img.format
            if not ext in ('JPEG', 'PNG'):
                raise ImageFormatException()

            # TODO: rescale if necessary

            # Handle EXIF orientation tag
            img = ImageOps.exif_transpose(img)

            # Convert image mode to RGB to allow JPEG conversion
            img = img.convert("RGB")

            # Save optimized image on static folder
            img_path = f"/team/{db_obj.id}.{ext.lower()}"
            img.save(f"static{img_path}",
                    format='JPEG',
                    quality='web_high',
                    optimize=True,
                    progressive=True)

        setattr(db_obj, 'image', img_path)
        db.add(db_obj)
        db.commit()
        return db_obj


team = CRUDTeam(Team)
