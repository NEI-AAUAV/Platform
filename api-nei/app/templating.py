from jinja2 import Environment, select_autoescape, PackageLoader

from app.core.config import settings

_env = Environment(
    loader=PackageLoader("app", "email-templates"),
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
    endpoint = settings.HOST + settings.EMAIL_ACCOUNT_VERIFY_ENDPOINT
    renderData = {"email": email, "name": name, "token": token, "endpoint": endpoint}
    return (
        _emailRegistrationTemplateHtml.render(renderData),
        _emailRegistrationTemplateText.render(renderData),
    )


_passwordResetTemplateHtml = _env.get_template("PasswordReset.html")
_passwordResetTemplateText = _env.get_template("PasswordReset.txt")


def render_password_reset_templates(
    email: str, name: str, token: str
) -> tuple[str, str]:
    """Renders the email templates for password resets

    **Parameters**
    * `email`: The email of the recipient
    * `name`: The name of the user
    * `token`: The password reset token

    **Returns**
    A tuple with the rendered html email and the text email
    """
    endpoint = settings.HOST + settings.PASSWORD_RESET_ENDPOINT
    renderData = {"email": email, "name": name, "token": token, "endpoint": endpoint}
    return (
        _passwordResetTemplateHtml.render(renderData),
        _passwordResetTemplateText.render(renderData),
    )


_passwordChangedTemplateHtml = _env.get_template("PasswordChanged.html")
_passwordChangedTemplateText = _env.get_template("PasswordChanged.txt")


def render_password_changed_templates(email: str, name: str) -> tuple[str, str]:
    """Renders the email templates for password changes notifications

    **Parameters**
    * `email`: The email of the recipient
    * `name`: The name of the user

    **Returns**
    A tuple with the rendered html email and the text email
    """
    renderData = {"email": email, "name": name}
    return (
        _passwordChangedTemplateHtml.render(renderData),
        _passwordChangedTemplateText.render(renderData),
    )


_magicLinkTemplateHtml = _env.get_template("MagicLink.html")
_magicLinkTemplateText = _env.get_template("MagicLink.txt")


def render_magic_link_templates(
    email: str, name: str, reason: str, token: str
) -> tuple[str, str]:
    """Renders the email templates for magic links

    **Parameters**
    * `email`: The email of the recipient
    * `name`: The name of the user
    * `reason`: The reason why the user is recieving this email
    * `token`: The magic link token

    **Returns**
    A tuple with the rendered html email and the text email
    """
    endpoint = settings.HOST + settings.MAGIC_LINK_ENDPOINT
    renderData = {
        "email": email,
        "name": name,
        "token": token,
        "endpoint": endpoint,
        "reason": reason,
    }
    return (
        _magicLinkTemplateHtml.render(renderData),
        _magicLinkTemplateText.render(renderData),
    )
