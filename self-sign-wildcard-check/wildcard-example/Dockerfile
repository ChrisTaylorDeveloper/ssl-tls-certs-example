FROM php:8.2-apache
RUN a2enmod ssl && a2enmod rewrite && a2enmod headers
COPY selfsigned/ /etc/selfsigned/
COPY vhost.conf /etc/apache2/sites-available/000-default.conf
COPY index.html /var/www/html/index.html
