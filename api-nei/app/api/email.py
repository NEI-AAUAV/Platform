import aiosmtplib
from email.utils import formatdate, make_msgid
from email.message import Message
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

from app.core.logging import logger
from app.core.config import settings
import app.templating as templating

if settings.EMAIL_ENABLED:
    logger.info("Email is enabled")
else:
    logger.warning("Email is disabled")


def _generate_email_message(
    email: str, subject: str, bodies: tuple[str, str]
) -> Message:
    """Generates an html (with text fallback) email message

    **Parameters**
    * `email`: The email of the recipient
    * `subject`: The subject line of the email message
    * `bodies`: The html and text (in this order) content of the email

    **Returns**
    An email message with all needed fields configured for delivery
    """

    message = MIMEMultipart("alternative")
    message["To"] = email
    message["From"] = settings.EMAIL_SENDER_ADDRESS
    message["Date"] = formatdate(localtime=True)
    message["Subject"] = subject
    message["Message-Id"] = make_msgid(domain=settings.EMAIL_DOMAIN)

    (htmlContent, textContent) = bodies
    message.attach(MIMEText(textContent))
    message.attach(MIMEText(htmlContent, "html"))

    return message


async def send_email_confirmation(email: str, name: str, token: str):
    """Sends an email with a link to confirm account registration

    **Parameters**
    * `email`: The email of the recipient
    * `name`: The name of the user
    * `token`: The confirmation token
    """
    bodies = templating.render_email_registration_templates(email, name, token)
    message = _generate_email_message(
        email, "Confirma a tua conta no site do NEI", bodies
    )

    await aiosmtplib.send(
        message,
        hostname=settings.EMAIL_SMTP_HOST,
        port=settings.EMAIL_SMTP_PORT,
        username=settings.EMAIL_SMTP_USER,
        password=settings.EMAIL_SMTP_PASSWORD,
    )


async def send_password_reset(email: str, name: str, token: str):
    """Sends an email with a link to reset the user's password

    **Parameters**
    * `email`: The email of the recipient
    * `name`: The name of the user
    * `token`: The confirmation token
    """
    bodies = templating.render_password_reset_templates(email, name, token)
    message = _generate_email_message(
        email, "Recupera a tua password no site do NEI", bodies
    )

    await aiosmtplib.send(
        message,
        hostname=settings.EMAIL_SMTP_HOST,
        port=settings.EMAIL_SMTP_PORT,
        username=settings.EMAIL_SMTP_USER,
        password=settings.EMAIL_SMTP_PASSWORD,
    )


async def send_password_changed(email: str, name: str):
    """Sends an email with a notification that the password was changed

    **Parameters**
    * `email`: The email of the recipient
    * `name`: The name of the user
    """
    bodies = templating.render_password_changed_templates(email, name)
    message = _generate_email_message(
        email, "A tua password no site do NEI foi alterada", bodies
    )

    await aiosmtplib.send(
        message,
        hostname=settings.EMAIL_SMTP_HOST,
        port=settings.EMAIL_SMTP_PORT,
        username=settings.EMAIL_SMTP_USER,
        password=settings.EMAIL_SMTP_PASSWORD,
    )
