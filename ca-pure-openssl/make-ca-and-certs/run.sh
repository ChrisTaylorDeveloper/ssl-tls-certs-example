#!/usr/bin/env bash

set -e

# 1. CLEAN UP FROM PREVIOUS RUN
rm -rf workdir/ && mkdir workdir && cd workdir

DOMAIN=foobar.cloud
CA="Dev-CA-Signed-$DOMAIN"

# 2. GENERATE RSA PRIVATE KEY FOR THE CA
# AES encrypted variant, requires pass-phrase.
# openssl genrsa -aes256 \
#   -out "$CA".key 4096
# Key not encrypted, no pass-phrase required.
openssl genrsa \
  -out "$CA".key 2048

# 3. INSPECT THE CA PRIVATE KEY
# openssl rsa -noout -text \
#   -in "$CA".key

# 4. CREATE A SELF-SIGNED ROOT CERT FOR THE CA
# "$CA".crt is installed in a browser.
openssl req -x509 -new -nodes -sha256 -days 1826 \
  -subj "/C=UK/ST=Channel Islands/L=Guernsey/O=Chris Taylor Developer/OU=Engineering Department/CN=$CA" \
  -key "$CA".key \
  -out "$CA".crt

# 5. INSPECT THE ROOT CERT OF THE CA
# openssl x509 -noout -text \
#   -in "$CA".crt

# 6. GENERATE NEW PRIVATE KEY AND A CSR FOR IT.
# Browsers rely mostly on SAN, not CN.
# Note base and wildcard domain in subjectAltName extension.
openssl req -new -newkey rsa:2048 -nodes \
  `# these are the Subject Name attributes` \
  -subj "/C=UK/ST=Channel Islands/L=Jersey/O=Chris Taylor Developer/OU=IT Department/CN=$DOMAIN" \
  -addext "subjectAltName = DNS:$DOMAIN, DNS:*.$DOMAIN" \
  -keyout "$DOMAIN".key \
  -out "$DOMAIN".csr

# 7. INSPECT THE CERT SIGNING REQUEST
# Look for 'Subject Alternative Name'
# openssl req -noout -text \
#   -in "$DOMAIN".csr

# 8. CREATE AN EXTENSION FILE FOR SUBJECT ALTERNATIVE NAME PROPS
# Required in next step.
cat >"$DOMAIN".ext <<EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = "$DOMAIN"
DNS.2 = *."$DOMAIN"
EOF

# 9. THE CA SIGNS THE CSR
openssl x509 -req -sha256 -CAcreateserial -days 365 \
  -in "$DOMAIN".csr \
  -CA "$CA".crt \
  -CAkey "$CA".key \
  -out "$DOMAIN".crt \
  -extfile "$DOMAIN".ext

# 10. INSPECT THE SIGNED CERT
# openssl x509 -text -noout \
#   -in "$DOMAIN".crt

# 10. VERITY OUR CA DID IN FACT ISSUE OUR CERTIFICATE
# openssl verify -CAfile "$CA".crt "$DOMAIN".crt
