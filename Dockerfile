# Base con PHP-FPM 8.3
FROM php:8.3-fpm

# Instalar dependencias del sistema
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      nginx supervisor cron git unzip curl wget gnupg ca-certificates \
      libnss3 libasound2 libxdamage1 libxrandr2 libxkbcommon0 \
      libatk-bridge2.0-0 libgtk-3-0 libgbm1 \
      libicu-dev pkg-config libzip-dev \
 && rm -rf /var/lib/apt/lists/*

# Extensiones PHP requeridas por Laravel
RUN docker-php-ext-install \
      pdo_mysql bcmath intl zip opcache \
 && pecl install redis \
 && docker-php-ext-enable redis

# Composer desde imagen oficial
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Nginx config
RUN mkdir -p /run/nginx /var/www/html
COPY docker/nginx/default.conf /etc/nginx/conf.d/default.conf
RUN rm -f /etc/nginx/sites-enabled/default || true \
 && rm -f /etc/nginx/sites-available/default || true

# PHP-FPM pool config
COPY docker/php/www.conf /usr/local/etc/php-fpm.d/www.conf

# Supervisor config
COPY docker/etc/supervisord.conf /etc/supervisor/supervisord.conf
COPY docker/etc/supervisor/*.conf /etc/supervisor/conf.d/

# Permisos del código
RUN chown -R www-data:www-data /var/www/html

WORKDIR /var/www/html

# Si no montas volumen, puedes copiar código aquí:
# COPY . /var/www/html

EXPOSE 80

# Arranque con Supervisor (maneja nginx, php-fpm y chromedriver)
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
