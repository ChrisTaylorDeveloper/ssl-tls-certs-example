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
openssl req -x509 -new -nodes -sha256 -days 1826 \
  -subj '/C=US/ST=NewYork/L=NewYork/O=Org/OU=OrgUnit/CN=MyCA' \
  -key MyCA.key \
  -out MyCA.crt

# 5. INSPECT THE ROOT CERT OF THE CA
# openssl x509 -noout -text \
#   -in MyCA.crt

# 6. GENERATE NEW PRIVATE KEY AND A CSR FOR IT.
# Browsers rely mostly  on SAN, not CN.
# Note base and wildcard domain in subjectAltName extension.
openssl req -new -newkey rsa:2048 -nodes \
  `# these are the Subject Name attributes` \
  -subj "/C=US/ST=State/L=City/O=Organisation/OU=OrgUnit/CN=thedomain.com" \
  -addext "subjectAltName = DNS:thedomain.com, DNS:*.thedomain.com" \
  -keyout thedomain.key \
  -out thedomain.csr

# 7. INSPECT THE CERT SIGNING REQUEST
# Look for 'Subject Alternative Name'
# openssl req -noout -text -in thedomain.csr

# 8. CREATE AN EXTENSION FILE FOR THE SAN PROPERTIES
cat >thedomain.ext <<EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = thedomain.com
DNS.2 = *.thedomain.com
EOF

# 9. SIGN THE CSR WITH THE CA
openssl x509 -req -sha256 -CAcreateserial -days 365 \
  -in thedomain.csr \
  -CA MyCA.crt \
  -CAkey MyCA.key \
  -out thedomain.crt \
  -extfile thedomain.ext

# 10. INSPECT THE SIGNED CERT
# openssl x509 -in thedomain.crt -text -noout
