import os
from fastapi import APIRouter, Depends, HTTPException, status, Response, BackgroundTasks
from fastapi.responses import JSONResponse, RedirectResponse
from app.core.config import settings
from ._deps import generate_response
import httpx

import base64

from authlib.integrations.httpx_client import AsyncOAuth1Client

from io import BytesIO
from app.api import deps
from sqlalchemy.orm import Session

from loguru import logger
from app import crud
from app.schemas import (
    CourseCreate,
    SubjectCreate,
    UserCreate,
    UserAcademicDetailsCreate,
    UserUpdate,
)

router = APIRouter()

request_token_url = "https://identity.ua.pt/oauth/request_token"
authorize_url = "https://identity.ua.pt/oauth/authorize"
access_token_url = "https://identity.ua.pt/oauth/access_token"
get_data_url = "https://identity.ua.pt/oauth/get_data"


# Prevent SSL error: DH keys are too small
httpx._config.DEFAULT_CIPHERS += ':HIGH:!DH:!aNULL'

# Save tokens
tokens = {}


@router.get(
    "/token",
    responses={503: {"description": "Service Unavailable"}},
)
async def get_token(
    oauth_verifier: str = None,
    oauth_token: str = None,
    *,
    db: Session = Depends(deps.get_db),
    # background_tasks: BackgroundTasks,
) -> Response:
    if oauth_token is None:
        print(settings.IDP_SECRET_KEY)
        # Step 1: Request Token
        oauth = AsyncOAuth1Client(
            settings.IDP_KEY, client_secret=settings.IDP_SECRET_KEY)

        fetch_response = await oauth.fetch_request_token(request_token_url)

        token = fetch_response.get("oauth_token")
        token_secret = fetch_response.get("oauth_token_secret")
        tokens[token] = token_secret

        # Step 2: Authorize
        authorization_url = oauth.create_authorization_url(authorize_url)
        return JSONResponse(status_code=200, content={"url": authorization_url})

    else:
        if oauth_token not in tokens:
            raise HTTPException(status_code=404, detail="Token not found")

        # Step 3: Access Token
        oauth = AsyncOAuth1Client(
            settings.IDP_KEY,
            client_secret=settings.IDP_SECRET_KEY,
            token=oauth_token,
            token_secret=tokens[oauth_token],
            verifier=oauth_verifier,
        )
        oauth_tokens = await oauth.fetch_access_token(access_token_url)
        token = oauth_tokens.get("oauth_token")
        token_secret = oauth_tokens.get("oauth_token_secret")
        data = await get_data(token, token_secret, scopes=["name", "uu"])

        name, uu = (
            data["name"],
            data["uu"],
        )

        maybe_user = crud.user.get_by_email(db, email=uu["email"])
        if maybe_user is None:
            # save new user in db
            user_in = UserCreate(
                iupi=uu["iupi"],
                name=name["name"],
                surname=name["surname"],
            )
            logger.info(f"Creating user: {user_in}")
            user = crud.user.create(
                db, obj_in=user_in, email=uu["email"], active=True)
        else:
            # update user
            user, user_email = maybe_user
            user_up = UserUpdate(
                id=maybe_user[0].id,
                iupi=uu["iupi"],
                name=name["name"],
                surname=name["surname"],
            )
            logger.info(f"Updating user {user.id}: {user_up}")
            user = crud.user.update(db, db_obj=user, obj_in=user_up)

        del tokens[oauth_token]
        return generate_response(db, user)


async def get_data(token, token_secret, scopes):
    """
    Permitted scopes, how to access data and keys:
    - uu (nothing needs to be done) -> email, iupi
    - name (nothing needs to be done) -> name, surname
    - student_info (access ['NewDataSet']['ObterDadosAluno'] -> NMec, Curso, AnoCurricular, Foto
    - student_courses (access ['NewDataSet']['ObterListaDisciplinasAluno'] -> array de disciplinas
    """
    oauth = AsyncOAuth1Client(
        settings.IDP_KEY,
        client_secret=settings.IDP_SECRET_KEY,
        token=token,
        token_secret=token_secret,
    )
    data = {}
    for s in scopes:
        res = await oauth.get(f"{get_data_url}?scope={s}&format=json")
        res = res.json()
        if s == "student_info":
            data["student_info"] = res["NewDataSet"]["ObterDadosAluno"]
        elif s == "student_courses":
            data["student_courses"] = res["NewDataSet"][
                "ObterListaDisciplinasAluno"
            ]
        elif s == "name":
            data["name"] = res
        elif s == "uu":
            data["uu"] = res
        else:
            logger.warning(f"Scope {s} not found, ignoring...")

    return data
