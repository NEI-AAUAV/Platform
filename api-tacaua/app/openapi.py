from fastapi import FastAPI

from app.api.v1.team import create_team, update_team
from app.api.v1.course import create_course, update_course
from .utils import update_schema_name


def custom_openapi(app: FastAPI):
    update_schema_name(app, create_team, "TeamCreateForm")
    update_schema_name(app, update_team, "TeamUpdateForm")
    update_schema_name(app, create_course, "CourseCreateForm")
    update_schema_name(app, update_course, "CourseUpdateForm")
