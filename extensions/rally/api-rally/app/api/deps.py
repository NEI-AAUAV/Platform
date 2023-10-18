import os
from typing import Generator, Optional
from datetime import datetime, timedelta

from jose import JWTError, jwt
from passlib.context import CryptContext
from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
from sqlalchemy.orm import Session

from app import crud
from app.db.session import SessionLocal
from app.models.user import User
from app.schemas.user import AdminUser, DetailedUser


# to get a string like this run:
# openssl rand -hex 32
SECRET_KEY = os.getenv(
    "SECRET_KEY", "4bd9e1c86c459885f0f0be7a1ce5aba0c8765359a65d7c0080f12e775f5e61b1"
)
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 60 * 24


def get_db() -> Generator:
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/api/rally/v1/user/token")


def verify_password(password, hashed_password):
    return pwd_context.verify(password, hashed_password)


def get_password_hash(password):
    return pwd_context.hash(password)


def get_user(db, username: str) -> Optional[User]:
    return db.query(User).filter(User.username == username).first()


def authenticate_user(db: Session, username: str, password: str) -> Optional[User]:
    user = get_user(db, username)
    if user is None:
        return None
    if not verify_password(password, user.hashed_password):
        return None
    return user


def create_access_token(data: dict, expires_delta: Optional[timedelta] = None):
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.utcnow() + expires_delta
    else:
        expire = datetime.utcnow() + timedelta(minutes=15)
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt


async def get_current_user(
    token: str = Depends(oauth2_scheme), db: Session = Depends(get_db)
) -> DetailedUser:
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        user_id: Optional[str] = payload.get("sub")
        if user_id is None:
            raise credentials_exception
    except JWTError:
        raise credentials_exception

    user = crud.user.get(db, id=int(user_id))
    if user is None:
        raise credentials_exception
    return DetailedUser.model_validate(user)


async def get_participant(
    curr_user: DetailedUser = Depends(get_current_user),
) -> DetailedUser:
    if curr_user.disabled:
        raise HTTPException(status_code=400, detail="Inactive user")
    return curr_user


async def get_admin(curr_user: DetailedUser = Depends(get_participant)) -> AdminUser:
    if not curr_user.is_admin:
        raise HTTPException(status_code=403, detail="User without admin permissions")
    return AdminUser.model_validate(curr_user)


async def get_admin_or_staff(
    curr_user: DetailedUser = Depends(get_participant),
) -> DetailedUser:
    if not curr_user.is_admin and not curr_user.staff_checkpoint_id:
        raise HTTPException(status_code=403, detail="User without permissions")
    return curr_user
