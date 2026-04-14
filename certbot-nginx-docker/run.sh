#!/bin/bash

source .env

# Clean up from previous run.
docker compose down --remove-orphans
docker volume rm --force certbot_conf
docker volume rm --force certbot_www

# Build and run up nginx service, with
# minimal conf required to get the certs.
docker compose build --build-arg NGINX_CONF=certs-issue nginx
docker compose up -d nginx

# Now ask certbot to get certs.
# Remembe to remove --dry-run !
docker compose run --build --rm certbot \
  certonly --dry-run \
  --webroot -w /var/www/certbot \
  --email chris@ctd.gg \
  -d "${DOMAIN}" \
  --agree-tos --no-eff-email --force-renewal

# Build and run nginx service again, but this
# time with the (default) production conf file.
docker compose build nginx
docker compose up -d nginx

sleep 6

# Should get a 301.
curl --head "${DOMAIN}"

# Should be fine, 200.
curl "${DOMAIN}"
