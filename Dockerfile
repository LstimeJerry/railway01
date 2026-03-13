FROM php:8.3-apache

# Fix MPM conflict: disable mpm_event, enable mpm_prefork
RUN a2dismod mpm_event && a2enmod mpm_prefork

RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    && docker-php-ext-install pdo pdo_mysql mysqli curl \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY . /var/www/html/
EXPOSE 80
