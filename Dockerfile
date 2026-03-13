FROM php:8.3-apache

# Completely disable all MPM modules by removing them from the filesystem
RUN rm -f /etc/apache2/mods-available/mpm_*.load && \
    rm -f /etc/apache2/mods-available/mpm_*.conf && \
    rm -f /etc/apache2/mods-enabled/mpm_*.load && \
    rm -f /etc/apache2/mods-enabled/mpm_*.conf

# Create mpm_prefork module files manually
RUN echo "LoadModule mpm_prefork_module modules/mod_mpm_prefork.so" > /etc/apache2/mods-available/mpm_prefork.load && \
    echo "" > /etc/apache2/mods-available/mpm_prefork.conf && \
    ln -s /etc/apache2/mods-available/mpm_prefork.load /etc/apache2/mods-enabled/mpm_prefork.load && \
    ln -s /etc/apache2/mods-available/mpm_prefork.conf /etc/apache2/mods-enabled/mpm_prefork.conf

RUN apt-get update && apt-get install -y \
 libcurl4-openssl-dev \
 && docker-php-ext-install pdo pdo_mysql mysqli curl \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

ENV PORT=8080
RUN sed -i 's/80/${PORT}/g' /etc/apache2/sites-available/000-default.conf /etc/apache2/ports.conf

COPY . /var/www/html/

CMD ["apache2-foreground"]
