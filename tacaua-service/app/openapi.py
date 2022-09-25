from fastapi import FastAPI
from fastapi_responses import custom_openapi as show_response_errors

from app.api.api_v1.modality import create_modality, update_modality
from app.api.api_v1.team import create_team, update_team
from app.api.api_v1.course import create_course, update_course
from .utils import update_schema_name


def custom_openapi(app: FastAPI):
    app.openapi = show_response_errors(app)
    update_schema_name(app, create_modality, "ModalityCreateForm")
    update_schema_name(app, update_modality, "ModalityUpdateForm")
    update_schema_name(app, create_team, "TeamCreateForm")
    update_schema_name(app, update_team, "TeamUpdateForm")
    update_schema_name(app, create_course, "CourseCreateForm")
    update_schema_name(app, update_course, "CourseUpdateForm")
