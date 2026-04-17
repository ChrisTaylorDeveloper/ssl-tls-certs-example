#!/usr/bin/env bash

set -e

# 1. CLEAN UP FROM PREVIOUS RUN
rm -rf workdir/ && mkdir workdir && cd workdir

# 2. GENERATE RSA PRIVATE KEY FOR THE CA
# AES encrypted variant, requires pass-phrase.
# openssl genrsa -aes256 \
#   -out MyCA.key 4096
# Key not encrypted, no pass-phrase required.
openssl genrsa \
  -out MyCA.key 2048

# 3. INSPECT THE CA PRIVATE KEY
# openssl rsa -noout -text \
#   -in MyCA.key

# 4. CREATE A SELF-SIGNED ROOT CERT FOR THE CA
# MyCA.crt is installed in a browser.
# TODO: Could I use -out MyCA.pem instead?
openssl req -x509 -new -nodes -sha256 -days 1826 \
  -subj '/C=US/ST=SomeState/L=City/O=MyOrg/OU=OrgUnit/CN=MyOrgRootCA' \
  -key MyCA.key \
  -out MyCA.crt

# 5. INSPECT THE ROOT CERT OF THE CA
# openssl x509 -noout -text \
#   -in MyCA.crt

# 6. GENERATE NEW PRIVATE KEY AND A CSR FOR IT.
# Browsers rely mostly  on SAN, not CN.
# Note the base and wildcard domain in the subjectAltName extension.
# TODO: Add in OU also?
openssl req -new -newkey rsa:2048 -nodes \
  -subj "/C=US/ST=State/L=City/O=Organization/CN=example.com" \
  -addext "subjectAltName = DNS:example.com, DNS:*.example.com" \
  -keyout server.key \
  -out server.csr

# 7. INSPECT THE CERT SIGNING REQUEST
# Look for 'Subject Alternative Name'
# openssl req -noout -text -in server.csr

# 8. CREATE AN EXTENSION FILE FOR THE SAN PROPERTIES
cat >example.ext <<EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = example.com
DNS.2 = *.example.com
EOF
