import os
from io import BytesIO
from hashlib import md5
from datetime import datetime
from typing import Optional, Union, Any, Dict, List

import magic
from loguru import logger
from PIL import Image, ImageOps
from sqlalchemy import select
from sqlalchemy.orm import Session
from fastapi import UploadFile
from fastapi.encoders import jsonable_encoder
from starlette.datastructures import UploadFile as StarletteUploadFile

from app.exception import FileFormatException
from app.crud.base import CRUDBase
from app.models.user import User, UserEmail
from app.schemas.user import UserCreate, UserUpdate
from app.core.config import settings
from app.api.api_v1.auth._deps import hash_password

mime = magic.Magic(mime=True)


class CRUDUser(CRUDBase[User, UserCreate, UserUpdate]):
    def get_email_fq(
        self, db: Session, *, id: int, email: str, for_update: bool = False
    ) -> Optional[tuple[User, UserEmail]]:
        """Fetches a user and it's email utilizing a fully qualified search (id and email).

        This method should be preferred over `get_by_email` when both the user id and email
        are known beforehand (and both are needed), since it prevents problems with an user
        that has been deleted and a new one that gets the same email address.

        **Parameters**
        * `db`: A SQLAlchemy ORM session
        * `email`: The user's email address
        """
        stmt = select(self.model, UserEmail).where(
            self.model.id == id,
            self.model.id == UserEmail.user_id,
            UserEmail.email == email,
        )

        if for_update:
            stmt = stmt.with_for_update()

        return db.execute(stmt).one_or_none()

    def get_by_email(
        self, db: Session, email: str, *, for_update: bool = False
    ) -> Optional[tuple[User, UserEmail]]:
        """Fetches a user from the database by it's email.

        **Parameters**
        * `db`: A SQLAlchemy ORM session
        * `email`: The user's email address
        """
        query = db.query(self.model, UserEmail).filter(
            self.model.id == UserEmail.user_id, UserEmail.email == email
        )

        if for_update:
            query = query.with_for_update().populate_existing()

        return query.one_or_none()

    def create(
        self,
        db: Session,
        *,
        obj_in: UserCreate,
        active: bool = not settings.EMAIL_ENABLED,
    ) -> User:
        """Creates a new user in the database with an associated email.

        **Parameters**
        * `db`: A SQLAlchemy ORM session
        * `obj_in`: The user creation data
        * `email`: The user's email address
        * `active`: Whether the provided email should be considered already active or not
        """
        obj_in_data = jsonable_encoder(obj_in)
        del obj_in_data["email"]

        if obj_in.password is not None:
            obj_in_data["hashed_password"] = hash_password(
                obj_in.password.get_secret_value()
            )

        del obj_in_data["password"]

        obj_in_data["created_at"] = datetime.now()
        obj_in_data["updated_at"] = datetime.now()

        db_obj = self.model(**obj_in_data)

        # Start a new transaction since all changes that will be made must be
        # atomic (either everything is updated successfully or nothing is updated)
        with db.begin_nested():
            # Add the user to the database.
            db.add(db_obj)
            # Make sure the new user is created in the database so that an id is
            # generated for it.
            db.flush()

            # Add an user email entry to the database.
            db.add(UserEmail(email=obj_in.email, active=active, user_id=db_obj.id))

        return db_obj

    def get_multi_with_emails(self, db: Session) -> List[tuple[User, Optional[UserEmail]]]:
        """Get all users with their associated emails (if any)"""
        from sqlalchemy.orm import joinedload
        
        query = db.query(self.model).outerjoin(UserEmail, self.model.id == UserEmail.user_id)
        users_with_emails = []
        
        for user in query.all():
            # Get the active email for this user
            email = db.query(UserEmail).filter(
                UserEmail.user_id == user.id,
                UserEmail.active == True
            ).first()
            users_with_emails.append((user, email))
        
        return users_with_emails

    def update(
        self,
        db: Session,
        *,
        db_obj: User,
        obj_in: Union[UserUpdate, Dict[str, Any]],
    ) -> User:
        if isinstance(obj_in, dict):
            update_data = obj_in
        else:
            update_data = obj_in.model_dump(exclude_unset=True)
        update_data["updated_at"] = datetime.now()
        return super(CRUDUser, self).update(db, db_obj=db_obj, obj_in=update_data)

    def activate_email(self, db: Session, *, user: User, email: str):
        """Marks an email as active for a user.

        **Parameters**
        * `db`: A SQLAlchemy ORM session
        * `user`: The user
        * `email`: The user's email address
        """
        db_obj = (
            db.query(UserEmail)
            .filter(UserEmail.user_id == user.id, UserEmail.email == email)
            .first()
        )
        assert db_obj is not None
        db_obj.active = True

        db.add(db_obj)
        db.commit()
        db.refresh(db_obj)

        return db_obj

    async def update_image(
        self,
        db: Session,
        *,
        db_obj: User,
        image: UploadFile | bytes | None,
    ) -> User:
        img_path = None
        delete_old = image is None

        if image is not None:
            try:
                if isinstance(image, StarletteUploadFile):
                    image = await image.read()
                img_bytes = BytesIO(image)
                md5sum = md5(img_bytes.getbuffer())
                img = Image.open(img_bytes)
            except:
                raise FileFormatException()
            ext = img.format
            if not ext in ("JPEG", "PNG", "BMP"):
                raise FileFormatException(detail="Image format must be JPEG or PNG.")

            # TODO: rescale if necessary

            # Handle EXIF orientation tag
            img = ImageOps.exif_transpose(img)

            # Convert image mode to RGB to allow JPEG conversion
            img = img.convert("RGB")

            # Create path if it doesn't exist
            os.makedirs(f"static/users/{db_obj.id}", exist_ok=True)

            # Save optimized image on static folder
            img_path = f"/users/{db_obj.id}/{md5sum.hexdigest()}.jpg"
            img.save(
                f"static{img_path}",
                format="JPEG",
                quality="web_high",
                optimize=True,
                progressive=True,
            )

            delete_old = img_path != db_obj._image

        if delete_old:
            # Delete image
            try:
                os.remove(f"static{db_obj._image}")
            except Exception as e:
                logger.error(
                    f"Failed to delete profile picture for user {db_obj.id}: {e}"
                )

        setattr(db_obj, "image", img_path)
        db.add(db_obj)
        db.commit()
        return db_obj

    async def update_curriculum(
        self,
        db: Session,
        *,
        db_obj: User,
        curriculum: Optional[UploadFile],
    ) -> User:
        curriculum_path = None
        if curriculum:
            try:
                curriculum_data = await curriculum.read()
                file_type = mime.from_buffer(curriculum_data)
            except:
                raise FileFormatException(detail="Failed to detect file type.")
            curriculum_path = f"/users/{db_obj.id}/cv.pdf"

            if file_type == "application/pdf":
                # Create path if it doesn't exist
                os.makedirs(f"static/users/{db_obj.id}", exist_ok=True)

                with open(f"static{curriculum_path}", "wb") as f:
                    f.write(curriculum_data)
            else:
                raise FileFormatException(detail="Curriculum format must be PDF.")
        elif db_obj.curriculum:
            # Delete curriculum
            try:
                os.remove(f"static{db_obj._curriculum}")
            except:
                pass  # ignore errors

        setattr(db_obj, "curriculum", curriculum_path)
        db.add(db_obj)
        db.commit()
        return db_obj


user = CRUDUser(User)
