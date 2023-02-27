[NEI-AAUAv Platform](../README.md)

# Administrator Documentation

 to be written
<!-- TODO: complete -->

## JWT Keys

All APIs use Json Web Tokens ([JWT](https://jwt.io)) to authenticate user
requests, the keys need to be signed with a key, the APIs use a asymmetric
signing scheme in order to allow only the main API (`api-nei`) to generate
new tokens (using the private key) and all others APIs to validate those
tokens (using only the public key).

The signing algorithm currently used is `ES512`, this requires generating
a pair of `secp521r1` (521-bit prime field Weierstrass curve) keys this can
be done with openssl:

```bash
# For generating private keys
openssl ecparam -genkey -name secp521r1 -noout -out <path to private key>
# For generating public keys
openssl ec -in <path to private key> -pubout -out <path to public key> 
```

Afterwards the APIs can be configured with the path to the public key through
the `JWT_PUBLIC_KEY_PATH` environment variable, additionally the private key
can be configured trough the `JWT_SECRET_KEY_PATH` environment variable.

### For the crypto nerds 🤓

ECDSA can be broken if the nonce is reused between messages, but this shouldn't
be an issue because the library we are using generates the nonce according to
[RFC 6979](https://www.rfc-editor.org/rfc/rfc6979) which is a deterministic
procedure which also takes into account the message so the generated values
should always be different for different messages.

A better option would be to use EdDSA key like Ed25519 which is designed in a
way that doesn't present this issue, but the library we use for generating tokens
doesn't support these keys.

## Emails

The main api (`api-nei`) can be configured to send emails, currently they are used for:

- Account registration confirmation

By default emails are disabled in order to enable them the `EMAIL_ENABLED`
environment enabled needs to be set to `True` (case-sensitive), furthermore
the following environment variables need to be configured in order to authenticate
with an smtp server to send emails:

- `EMAIL_SENDER_ADDRESS` should be set to the email address from where emails will originate
- `EMAIL_SMTP_HOST` is the address of the smtp server
- `EMAIL_SMTP_PORT` (optional, defaults to 587) the port of the smtp server to use
- `EMAIL_SMTP_USER` the username to use when authenticating with the smtp server
- `EMAIL_SMTP_PASSWORD` the password to use when authenticating with the smtp server

### Gmail

These are the instructions on how to setup the Gmail email to use with the api.

First create a gmail account like normal, afterwards setup a no reply filter in
the inbox to ensure that any inbound emails are discarded, otherwise the inbox
might fill up and outgoing emails might have issues.

This can be done by following these steps:
- Log in the account
- On the gmail web interface click on the settings icon (gear wheel) on the
  top right of the page.
- This will open the quick settings pane on the right, click on "See all settings"
  on the top of the pane.
- Afterwards click on the "Filters and blocked addresses" tab.
- Click on the "Create a new filter" link.
- This will bring a modal with some fields, fill only the "To" field with the
  address of the account (don't fill any other fields) and click on "Create filter".
- A dropdown will appear with actions to take, select "Delete it" and click on
  "Create filter" again.

Additionally an automatic message can be sent, for this a template must be created first:

- Click on "Compose" on the top left of the interface.
- Write the subject and body of the email.
- Afterwards click on the three dots on the toolbar on the bottom of the compose window.
- This will bring an options menu, afterwards select "templates" and "Save draft as template".

Finally edit the filter to also include the "Send template" action.

Then in order to get the smtp credentials an app password needs to be created, to do this, goto
<myaccount.google.com> then to security and create an app password (this requires that the account
has two factor authentication enabled). The resulting code will be the smtp password so the
configuration becomes:

- `EMAIL_SENDER_ADDRESS` the email address of the gmail account
- `EMAIL_SMTP_HOST` smtp.gmail.com
- `EMAIL_SMTP_PORT` 587 (default)
- `EMAIL_SMTP_USER` the email address of the gmail account
- `EMAIL_SMTP_PASSWORD` the generated app password
