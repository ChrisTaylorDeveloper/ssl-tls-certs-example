#!/usr/bin/env bash

set -e

# CLEAN UP FROM PREVIOUS RUN.
rm -rf workdir/ && mkdir workdir && cd workdir

# GENERATE RSA PRIVATE KEY FOR THE CA
# AES encrypted variant, requires pass-phrase.
# openssl genrsa -aes256 \
#   -out MyCA.key 4096
# No pass-phrase required, key not encrypted.
openssl genrsa \
  -out MyCA.key 2048

# INSPECT THE CA PRIVATE KEY
# openssl rsa -in MyCA.key -noout -text

# CREATE A SELF-SIGNED ROOT CERT FOR THE CA
# MyCA.crt is installed in a browser.
# TODO: Maybe I could use -out MyCA.pem ??
openssl req -x509 -new -nodes -sha256 -days 1826 \
  -subj '/C=US/ST=SomeState/L=City/O=MyOrg/OU=OrgUnit/CN=MyOrgRootCA' \
  -key MyCA.key \
  -out MyCA.crt

# INSPECT THE ROOT CERT OF THE CA
# openssl x509 -in MyCA.crt -noout -text

# GENERATES A NEW RSA PRIVATE KEY AND A CSR IN ONE GO.
# Adds the subjectAltName extension so both base domain and wildcard is covered
# Modern browsers rely almost exclusively on the SAN field, not CN.
# # TODO: Add in OU also?
# openssl req -new -newkey rsa:2048 -nodes \
#   -subj "/C=US/ST=State/L=City/O=Organization/CN=example.com" \
#   -addext "subjectAltName = DNS:example.com, DNS:*.example.com" \
#   -keyout server.key \
#   -out server.csr
