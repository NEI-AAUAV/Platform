This directory contains the **development** private and public keys used to sign and verify JWTs.

> ⚠️ Do not use in production!

1. Generate a private key:
```bash
openssl ecparam -genkey -name secp521r1 -noout -out jwt.key
```

2. Extract the public key from the private key:
```bash
openssl ec -in jwt.key -pubout -out jwt.key.pub
```
