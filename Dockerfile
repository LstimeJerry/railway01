FROM php:8.3-apache

# Disable all MPM modules
RUN a2dismod mpm_prefork mpm_worker mpm_event 2>/dev/null || true

# Enable only prefork (it's already available in the image)
RUN a2enmod mpm_prefork

RUN apt-get update && apt-get install -y \
 libcurl4-openssl-dev \
 && docker-php-ext-install pdo pdo_mysql mysqli curl \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

ENV PORT=8080
RUN sed -i 's/80/${PORT}/g' /etc/apache2/sites-available/000-default.conf /etc/apache2/ports.conf

COPY . /var/www/html/

CMD ["apache2-foreground"]
