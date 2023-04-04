from fastapi import APIRouter, Depends, HTTPException, status, Response
from fastapi.responses import JSONResponse, RedirectResponse
from app.core.config import settings
from ._deps import generate_response
import requests

import base64

from requests_oauthlib import OAuth1Session
from PIL import Image
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
requests.packages.urllib3.disable_warnings()
requests.packages.urllib3.util.ssl_.DEFAULT_CIPHERS += ":HIGH:!DH:!aNULL"
try:
    requests.packages.urllib3.contrib.pyopenssl.util.ssl_.DEFAULT_CIPHERS += (
        ":HIGH:!DH:!aNULL"
    )
except AttributeError:
    # No pyopenssl support used / needed / available
    pass

# Save tokens
tokens = {}


@router.get(
    "/token",
    responses={503: {"description": "Service Unavailable"}},
)
async def get_token(
    db: Session = Depends(deps.get_db),
    oauth_verifier: str = None,
    oauth_token: str = None,
) -> Response:
    if oauth_token is None:
        # Step 1: Request Token
        oauth = OAuth1Session(
            settings.IDP_KEY, client_secret=settings.IDP_SECRET_KEY)

        fetch_response = oauth.fetch_request_token(request_token_url)

        resource_owner_key = fetch_response.get("oauth_token")
        resource_owner_secret = fetch_response.get("oauth_token_secret")
        tokens[resource_owner_key] = resource_owner_secret

        # Step 2: Authorize
        authorization_url = oauth.authorization_url(authorize_url)
        return JSONResponse(status_code=200, content={"url": authorization_url})

    else:
        if oauth_token not in tokens:
            raise HTTPException(status_code=404, detail="Token not found")

        # Step 3: Access Token
        oauth = OAuth1Session(
            settings.IDP_KEY,
            client_secret=settings.IDP_SECRET_KEY,
            resource_owner_key=oauth_token,
            resource_owner_secret=tokens[oauth_token],
            verifier=oauth_verifier,
        )
        oauth_tokens = oauth.fetch_access_token(access_token_url)
        resource_owner_key = oauth_tokens.get("oauth_token")
        resource_owner_secret = oauth_tokens.get("oauth_token_secret")
        data = get_data(resource_owner_key, resource_owner_secret)
        # save to db
        student_courses, student_info, name, uu = (
            data["student_courses"],
            data["student_info"],
            data["name"],
            data["uu"],
        )

        courseInfo = student_info["Curso"].split("-")

        course = crud.course.get_by_code(db, code=int(courseInfo[0].strip()))
        if course is None:
            course_in = CourseCreate(
                name=courseInfo[1].strip(),
                code=courseInfo[0].strip(),
            )
            crud.course.create(db, obj_in=course_in)

        for subject in student_courses:
            subjectInDb = crud.subject.get_by_code(
                db, code=int(subject["CodDisciplina"]))
            if subjectInDb is None:
                subject_in = SubjectCreate(
                    name=subject["NomeDisciplina"],
                    code=subject["CodDisciplina"],
                    short="",
                    discontinued=0,
                    optional=0,
                    curricular_year=student_info["AnoCurricular"],
                    course_id=int(courseInfo[0].strip()),
                )
                crud.subject.create(db, obj_in=subject_in)

        user = crud.user.get_by_email(db, email=uu["email"])
        if user is None:
            user_in = UserCreate(
                iupi=uu["iupi"],
                nmec=student_info["NMec"],
                email=uu["email"],
                name=name["name"],
                surname=name["surname"],
            )
            logger.info(f"Creating user: {user_in}")
            user = crud.user.create(db, obj_in=user_in)
            userid = user.id
            createImg(user.id, student_info["Foto"], db)
            subList = []
            for subject in student_courses:
                subList.append(crud.subject.get_by_code(
                    db, code=int(subject["CodDisciplina"])))
            userAc = UserAcademicDetailsCreate(
                user_id=userid,
                course_id=int(courseInfo[0].strip()),
                curricular_year=student_info["AnoCurricular"],
                year=student_info["AnoCurricular"],
            )
            userAcModel = crud.user_academic.create(db, obj_in=userAc)
            userAcModel.subjects = subList
            db.add(userAcModel)
            db.add_all(subList)
            db.commit()
        else:
            # update user

            user_up = UserUpdate(
                id=user.id,
                iupi=uu["iupi"],
                nmec=student_info["NMec"],
                email=uu["email"],
                name=name["name"],
                surname=name["surname"],
            )
            logger.info(f"Updating user {user.id}: {user_up}")
            user = crud.user.update(db, db_obj=user, obj_in=user_up)

            # get user academic details
            userAc = crud.user_academic.get_by_user_id(db, user_id=user.id)

            # check if subjects are the same
            subList = []
            for subject in student_courses:
                subList.append(crud.subject.get_by_code(
                    db, code=int(subject["CodDisciplina"])))

            userAc_up = UserAcademicDetailsCreate(
                user_id=user.id,
                course_id=int(courseInfo[0].strip()),
                curricular_year=student_info["AnoCurricular"],
                year=student_info["AnoCurricular"],
            )
            if userAc is None:
                userAc = crud.user_academic.create(db, obj_in=userAc_up)
            else:
                userAc = crud.user_academic.update(
                    db, db_obj=userAc, obj_in=userAc_up)

            userAc.subjects = subList
            db.add(userAc)
            db.add_all(subList)
            db.commit()

        del tokens[oauth_token]
        return generate_response(db, user)


def get_data(resource_owner_key, resource_owner_secret):
    """
    Permitted scopes, how to access data and keys:
    - uu (nothing needs to be done) -> email, iupi
    - name (nothing needs to be done) -> name, surname
    - student_info (access ['NewDataSet']['ObterDadosAluno'] -> NMec, Curso, AnoCurricular, Foto
    - student_courses (access ['NewDataSet']['ObterListaDisciplinasAluno'] -> array de disciplinas
    """
    scopes = ["student_courses", "student_info", "name", "uu"]
    oauth = OAuth1Session(
        settings.IDP_KEY,
        client_secret=settings.IDP_SECRET_KEY,
        resource_owner_key=resource_owner_key,
        resource_owner_secret=resource_owner_secret,
    )
    returndata = {}
    for s in scopes:
        r = oauth.get(f"{get_data_url}?scope={s}&format=json")
        if s == "student_info":
            returndata["student_info"] = r.json(
            )["NewDataSet"]["ObterDadosAluno"]
        elif s == "student_courses":
            returndata["student_courses"] = r.json()["NewDataSet"][
                "ObterListaDisciplinasAluno"
            ]
        elif s == "name":
            returndata["name"] = r.json()
        elif s == "uu":
            returndata["uu"] = r.json()

    return returndata


def createImg(id, img, db):
    try:
        logger.info(f"Creating image for user " + str(id))
        # Save photo as JPEG image
        imgEnc = Image.open(BytesIO(base64.b64decode(img)))
        imgEnc.save(f"../static/img/{id}/pfpUA.jpg", "JPEG")
        user = crud.user.get(db, id=id)
        user_in = UserUpdate(
            id=user.id,
            iupi=user.iupi,
            nmec=user.nmec,
            email=user.email,
            name=user.name,
            surname=user.surname,
            image=f"../static/img/{id}/pfpUA.jpg",
        )
        user = crud.user.update(db, db_obj=user, obj_in=user_in)
        logger.info(f"User updated: {user.dict()} {user.__dict__}")
    except:
        # Some error occurred
        pass
