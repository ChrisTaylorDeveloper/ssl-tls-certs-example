#!/usr/bin/env bash

set -e

# CLEAN UP FROM PREVIOUS RUN
rm -rf workdir/ && mkdir workdir && cd workdir

# GENERATE RSA PRIVATE KEY FOR THE CA
# AES encrypted variant, requires pass-phrase.
# openssl genrsa -aes256 \
#   -out MyCA.key 4096
# Key not encrypted, no pass-phrase required.
openssl genrsa \
  -out MyCA.key 2048

# INSPECT THE CA PRIVATE KEY
# openssl rsa -noout -text \
#   -in MyCA.key

# CREATE A SELF-SIGNED ROOT CERT FOR THE CA
# MyCA.crt is installed in a browser.
# TODO: Could I use -out MyCA.pem instead?
openssl req -x509 -new -nodes -sha256 -days 1826 \
  -subj '/C=US/ST=SomeState/L=City/O=MyOrg/OU=OrgUnit/CN=MyOrgRootCA' \
  -key MyCA.key \
  -out MyCA.crt

# INSPECT THE ROOT CERT OF THE CA
# openssl x509 -noout -text \
#   -in MyCA.crt

# GENERATE NEW PRIVATE KEY AND A CSR FOR IT.
# Modern browsers rely almost exclusively on SAN field, not CN.
# Note the base and wildcard domain in the subjectAltName extension.
# # TODO: Add in OU also?
openssl req -new -newkey rsa:2048 -nodes \
  -subj "/C=US/ST=State/L=City/O=Organization/CN=example.com" \
  -addext "subjectAltName = DNS:example.com, DNS:*.example.com" \
  -keyout server.key \
  -out server.csr

# INSPECT THE CERT SIGNING REQUEST
# openssl req -noout -text -in server.csr
