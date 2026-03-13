FROM php:8.3-apache

# Remove conflicting MPM modules from mods-enabled
RUN rm -f /etc/apache2/mods-enabled/mpm_*.load /etc/apache2/mods-enabled/mpm_*.conf

# Enable only prefork
RUN a2enmod mpm_prefork

RUN apt-get update && apt-get install -y \
 libcurl4-openssl-dev \
 && docker-php-ext-install pdo pdo_mysql mysqli curl \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

ENV PORT=8080
RUN sed -i 's/80/${PORT}/g' /etc/apache2/sites-available/000-default.conf /etc/apache2/ports.conf

COPY . /var/www/html/

CMD ["apache2-foreground"]
