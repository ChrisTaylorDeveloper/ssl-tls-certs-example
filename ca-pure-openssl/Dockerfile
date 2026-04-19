FROM php:8.2-apache

RUN \
  a2enmod ssl && \
  a2enmod rewrite && \
  a2enmod headers

COPY index.html /var/www/html/index.html
COPY certs-keys/ /etc/certs-keys/
COPY vhost.conf /etc/apache2/sites-available/000-default.conf

ARG DOMAIN=change_me
RUN \
  sed -i "s/server_name/$DOMAIN/g" /etc/apache2/sites-available/000-default.conf && \
  sed -i "s/server_alias/*.$DOMAIN/g" /etc/apache2/sites-available/000-default.conf

