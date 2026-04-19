#!/bin/bash

rm -f ./selfsigned/wildcard*

# Create private key and CSR
openssl req -newkey rsa:2048 -nodes \
  -keyout ./selfsigned/wildcard.key -out ./selfsigned/wildcard.csr \
  -subj "/C=US/ST=State/L=City/O=Company/OU=IT/CN=*.365entertainmenttravel.com"

# Create the self-signed certificate
openssl x509 -req -days 365 -in ./selfsigned/wildcard.csr \
  -signkey ./selfsigned/wildcard.key -out ./selfsigned/wildcard.crt
