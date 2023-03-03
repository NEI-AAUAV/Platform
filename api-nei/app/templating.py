from jinja2 import Environment, select_autoescape, PackageLoader

from app.core.config import settings

_env = Environment(
    loader=PackageLoader("app", "templates"),
    autoescape=select_autoescape(["html", "xml"]),
)

_emailRegistrationTemplateHtml = _env.get_template("EmailRegistration.html")
_emailRegistrationTemplateText = _env.get_template("EmailRegistration.txt")


def render_email_registration_templates(
    email: str, name: str, token: str
) -> tuple[str, str]:
    """Renders the email templates for account registration

    **Parameters**
    * `email`: The email of the recipient
    * `name`: The name of the user
    * `token`: The confirmation token

    **Returns**
    A tuple with the rendered html email and the text email
    """
    endpoint = settings.HOST + settings.API_V1_STR + "/auth/verify"
    renderData = {"email": email, "name": name, "token": token, "endpoint": endpoint}
    return (
        _emailRegistrationTemplateHtml.render(renderData),
        _emailRegistrationTemplateText.render(renderData),
    )
