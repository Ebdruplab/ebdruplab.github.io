---
title: "Certificate Creation guide"
weight: 15
draft: false
description: "Learn how to generate and convert certificates using OpenSSL with this comprehensive guide."
slug: "certs"
tags: ["certs", "helpers", "guide", "scripts", "certificates", "notes"]
date: 2024-04-15
---


# Certificates guide

This provides info on how to generate certificates, and how to convert to diffrent certs form.

## Creating of a cert openssl.conf

1. Create an `openssl.conf` configuration, and insert:  

```bash
# Define all variables at the beginning for easy adjustments
# openssl req -new -config openssl.conf -keyout ebdruplab_dk.key -out ebdruplab_dk.csr
FQDN = ebdruplab.dk
ORGNAME = ebdruplab
EMAIL = example@ebdruplab.dk
COUNTRY = DK
STATE = 8200
CITY = Aarhus
ORG_UNIT = team
ALTNAMES = DNS:$FQDN, DNS:www.ebdruplab.dk

[ req ]
default_bits       = 2048                # RSA Key size
default_md         = sha256              # Hashing algorithm
prompt             = no                  # Disable prompt for overriding values
encrypt_key        = no                  # Private key is not encrypted
distinguished_name = dn
req_extensions     = req_ext             # Include extensions from below

[ dn ]
C            = $COUNTRY                 # Country Code
ST           = $STATE                   # State or Province
L            = $CITY                    # City
O            = $ORGNAME                 # Organization Name
OU           = $ORG_UNIT                # Organizational Unit
CN           = $FQDN                    # Common Name for the certificate
emailAddress = $EMAIL                   # Email Address

[ req_ext ]
subjectAltName = $ALTNAMES              # Defines alternate names for the certificate

```  

2. Change the varaibles to fit your domain (remember mail, ALTNAMES and so on)
3. Run command: `openssl req -new -config openssl.conf -keyout ebdruplab_dk.key -out ebdruplab_dk.csr` (change names of the keyout and -out accordenly)
4. Encrypt the private key using command: `openssl rsa -in ebdruplab_dk.key -aes256 -out encrypted_ebdruplab_dk.key` (save the password in a secure vault)
5. To decrypt the key: `openssl rsa -in encrypted_ebdruplab_dk.key -out decrypted_ebdruplab_dk.key`

## Conversion of certs

**CRT to PEM:** `cat certificate.crt ca_bundle.crt > combined.pem` (check that there are all on seperate lines)  
**CRT to PKCS12:** `openssl pkcs12 -export -out ebdruplab_dk.p12 -inkey sdecrypted_ebdruplab_dk.key -in ebdruplab_dk.crt -certfile ca_bundle.crt`  
