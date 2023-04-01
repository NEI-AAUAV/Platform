import base64
import requests
from requests_oauthlib import OAuth1Session
from PIL import Image
from io import BytesIO


client_key = '_82e3318ee5c5cf2c7d7f7a1367fd4b3ea40858f08a'
client_secret = '...'

request_token_url = 'https://identity.ua.pt/oauth/request_token'
authorize_url = 'https://identity.ua.pt/oauth/authorize'
access_token_url = 'https://identity.ua.pt/oauth/access_token'
get_data_url = 'https://identity.ua.pt/oauth/get_data'


# Prevent SSL error: DH keys are too small
requests.packages.urllib3.disable_warnings()
requests.packages.urllib3.util.ssl_.DEFAULT_CIPHERS += ':HIGH:!DH:!aNULL'
try:
    requests.packages.urllib3.contrib.pyopenssl.util.ssl_.DEFAULT_CIPHERS += ':HIGH:!DH:!aNULL'
except AttributeError:
    # No pyopenssl support used / needed / available
    pass


def get_tokens():
    # Step 1: Request Token
    oauth = OAuth1Session(client_key, client_secret=client_secret)
    fetch_response = oauth.fetch_request_token(request_token_url)
    print('fetch_response\n', fetch_response)
    resource_owner_key = fetch_response.get('oauth_token')
    resource_owner_secret = fetch_response.get('oauth_token_secret')

    # Step 2: Authorize

    authorization_url = oauth.authorization_url(authorize_url)
    print('Please go here and authorize:', authorization_url)
    ...
    redirect_response = input('Paste redirect URL response: ')
    oauth_response = oauth.parse_authorization_response(redirect_response)
    print('oauth_response\n', oauth_response)

    verifier = oauth_response.get('oauth_verifier') 
    # Step 3: Access Token
    oauth = OAuth1Session(client_key,
                          client_secret=client_secret,
                          resource_owner_key=resource_owner_key,
                          resource_owner_secret=resource_owner_secret,
                          verifier=verifier)
    print("oauth\n", oauth.__dict__)
    oauth_tokens = oauth.fetch_access_token(access_token_url)
    print('oauth_tokens\n', oauth_tokens)
    resource_owner_key = oauth_tokens.get('oauth_token')
    resource_owner_secret = oauth_tokens.get('oauth_token_secret')

    get_data(resource_owner_key, resource_owner_secret)


def get_data(resource_owner_key, resource_owner_secret):
    # Step 4: Get Data
    oauth = OAuth1Session(client_key,
                          client_secret=client_secret,
                          resource_owner_key=resource_owner_key,
                          resource_owner_secret=resource_owner_secret)
    print("get data")
    print('oauth\n', oauth.__dict__)

    scopes = ['student_info','student_courses']
    '''
    scopes:
    - uu
    - name
    - student_info
    - student_courses
    '''
    for s in scopes:
        r = oauth.get(f'{get_data_url}?scope={s}&format=json')
        data = r.json()
        if s == 'student_info':
            print(data['NewDataSet']['ObterDadosAluno']['Curso'])
            print(data['NewDataSet']['ObterDadosAluno']['NMec'])
            print(data['NewDataSet']['ObterDadosAluno']['AnoCurricular'])
        if s == 'student_courses':
            print(data['NewDataSet'].keys())
get_tokens()
