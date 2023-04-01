from fastapi import APIRouter, Depends, HTTPException, status, JSONResponse
import base64
import requests
from requests_oauthlib import OAuth1Session
from PIL import Image
from io import BytesIO
from loguru import logger
from app import crud
from schemas import CourseCreate, SubjectCreate, UserCreate, UserAcademicDetailsCreate, UserUpdate
router = APIRouter()
# Can me moved after its working

idp_key = '_82e3318ee5c5cf2c7d7f7a1367fd4b3ea40858f08a
idp_secret = '...'

request_token_url = 'https://identity.ua.pt/oauth/request_token'
authorize_url = 'https://identity.ua.pt/oauth/authorize'
access_token_url = 'https://identity.ua.pt/oauth/access_token'
get_data_url = 'https://identity.ua.pt/oauth/get_data'

# Save tokens
tokens = {}

@router.get(
    "/",
    responses={503 : {"description": "Service Unavailable"}},
    response_model=fastapi.JSONResponse)
async def get_token(
    db: Session = Depends(get_db),
    oauth_verifier: str = None,
    oauth_token: str = None,
):
    if oauth_token is None:
        # Step 1: Request Token
        
        fetch_response = oauth.fetch_request_token(request_token_url)
        
        logger.debug(f"fetch_response", fetch_response)
        resource_owner_key = fetch_response.get('oauth_token')
        resource_owner_secret = fetch_response.get('oauth_token_secret')
        tokens[resource_owner_key] = resource_owner_secret
    
        # Step 2: Authorize
        authorization_url = oauth.authorization_url(authorize_url)

        return JSONResponse(status_code=200, url=authorization_url)

    else:
        logger.debug(f"oauth_verifier", oauth_verifier)
        logger.debug(f"oauth_token", oauth_token)

        # Step 3: Access Token
        oauth = OAuth1Session(idp_key,
                              idp_secret=idp_secret,
                              resource_owner_key=oauth_token,
                              resource_owner_secret=tokens[oauth_token],
                              verifier=oauth_verifier)
        
        oauth_tokens = oauth.fetch_access_token(access_token_url)
        logger.debug(f"oauth_tokens", oauth_tokens)
        resource_owner_key = oauth_tokens.get('oauth_token')
        resource_owner_secret = oauth_tokens.get('oauth_token_secret')
        data = get_data(resource_owner_key, resource_owner_secret)
        # save to db
        student_courses, student_info, name, uu = data['student_courses'], data['student_info'], data['name'], data['uu']

        courseInfo = student_info['NMec'].split('-')

        course = crud.course.get_by_code(db, code=int(courseInfo[0].strip()))
        if course is None:
            course_in = CourseCreate(
                name=courseInfo[1].strip(),
                code=courseInfo[0   ].strip(),
            )
            crud.course.create(db, obj_in=course_in)
            
        for subject in student_courses:
            subject = crud.subject.get_by_code(db, code=int(subject['CodDisciplina']))
            if subject is None:
                subject_in = SubjectCreate(
                    name=subject['NomeDisciplina'],
                    code=subject['CodDisciplina'],
                )
                crud.subject.create(db, obj_in=subject_in)

        user = crud.user.get_by_email(db, email=uu['email'])
        if user is None:
            user_in = UserCreate(
                iupi=uu['iupi'],
                nmec=student_info['NMec'],
                email=uu['email'],
                name=name['name'],
                surname=name['surname'],                
            )
            user = crud.user.create(db, obj_in=user_in)
            userid = user.id
            createImg(user.id, data['Foto'])
            subList = []
            for subject in student_courses:
                subList.append(crud.get_by_code(db, code=int(subject['CodDisciplina'])))
            userAc = UserAcademicDetailsCreate(
                user_id=userid,
                course_id=int(courseInfo[0].strip()),
                year=student_info['AnoCurricular'],
                subjects=subList,
            )
            crud.user_academic.create(db, obj_in=userAc)
        else:
            # update user

            user_up = UserUpdate(
                id=user.id,
                iupi=uu['iupi'],
                nmec=student_info['NMec'],
                email=uu['email'],
                name=name['name'],
                surname=name['surname'],
            )



            
        return JSONResponse(status_code=200)


    
def get_data(resource_owner_key, resource_owner_secret):
    '''
    Permitted scopes, how to access data and keys:
    - uu (nothing needs to be done) -> email, iupi
    - name (nothing needs to be done) -> name, surname
    - student_info (access ['NewDataSet']['ObterDadosAluno'] -> NMec, Curso, AnoCurricular, Foto
    - student_courses (access ['NewDataSet']['ObterListaDisciplinasAluno'] -> array de disciplinas 
    '''
    scopes = ['student_courses', 'student_info', 'name', 'uu']
    oauth = OAuth1Session(idp_key,
                          idp_secret=idp_secret,
                          resource_owner_key=resource_owner_key,
                          resource_owner_secret=resource_owner_secret)
    returndata = {}
    for s in scopes:
        r = oauth.get(f'{get_data_url}?scope={s}&format=json')
        if s == 'student_info':
            returndata['student_info'] = r.json()['NewDataSet']['ObterDadosAluno']
        elif s == 'student_courses':
            returndata['student_courses'] = r.json()['NewDataSet']['ObterDisciplinasAluno']
        elif s == 'name':
            returndata['name'] = r.json()
        elif s == 'uu':
            returndata['uu'] = r.json()
    
    return returndata

def createImg(id, img):
    try:
        # Save photo as JPEG image
        imgEnc = Image.open(BytesIO(base64.b64decode(img)))
        imgEnc.save('../static/img/' + str(id) + '/ pfpUA.jpg', 'JPEG')
        userup = UserUpdate()
    except:
        # Some error occurred
        pass