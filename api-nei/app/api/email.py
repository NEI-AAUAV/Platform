import aiosmtplib
from email.utils import formatdate, make_msgid
from email.message import Message
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

from app.core.logging import logger
from app.core.config import settings
from app.templating import render_email_registration_templates

if settings.EMAIL_ENABLED:
    logger.info("Email is enabled")
else:
    logger.warning("Email is disabled")


async def send_email_confirmation(email: str, name: str, token: str):
    """Sends an email with a link to confirm account registration

    **Parameters**
    * `email`: The email of the recipient
    * `name`: The name of the user
    * `token`: The confirmation token
    """
    message = MIMEMultipart("alternative")
    message["To"] = email
    message["From"] = settings.EMAIL_SENDER_ADDRESS
    message["Date"] = formatdate(localtime=True)
    message["Subject"] = "Confirma a tua conta no site do nei"
    message["Message-Id"] = make_msgid(domain=settings.EMAIL_DOMAIN)

    (htmlContent, textContent) = render_email_registration_templates(email, name, token)
    message.attach(MIMEText(textContent))
    message.attach(MIMEText(htmlContent, "html"))

    await aiosmtplib.send(
        message,
        hostname=settings.EMAIL_SMTP_HOST,
        port=settings.EMAIL_SMTP_PORT,
        username=settings.EMAIL_SMTP_USER,
        password=settings.EMAIL_SMTP_PASSWORD,
    )
