### https://www.google.com/search?q=crear+un+dockerfile+ubuntu+22.04+php8.3+con+nginx+para+laravel12+y+supervisord&sca_esv=63ad467223b51100&rlz=1C1PRFI_enPE1063PE1063&sxsrf=AE3TifMX0iQ8DOjIJareVKP_9aPhX8VTfg%3A1755640281569&ei=2fGkaLW7IrvS1sQPkLyISQ&ved=0ahUKEwj1i9ja7ZePAxU7qZUCHRAeIgkQ4dUDCBA&uact=5&oq=crear+un+dockerfile+ubuntu+22.04+php8.3+con+nginx+para+laravel12+y+supervisord&gs_lp=Egxnd3Mtd2l6LXNlcnAiTmNyZWFyIHVuIGRvY2tlcmZpbGUgdWJ1bnR1IDIyLjA0IHBocDguMyBjb24gbmdpbnggcGFyYSBsYXJhdmVsMTIgeSBzdXBlcnZpc29yZEikH1CpAliPHXABeACQAQCYAWOgAaEJqgECMTS4AQPIAQD4AQGYAgCgAgCYAwCIBgGSBwCgB9gMsgcAuAcAwgcAyAcA&sclient=gws-wiz-serp

# Usa la imagen base de Ubuntu 22.04
FROM ubuntu:22.04

# Establece la zona horaria
ENV TZ=America/Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Actualiza el sistema e instala dependencias
RUN apt-get update && apt-get install -y \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    nginx \
    supervisor

RUN add-apt-repository -y ppa:ondrej/php \
    && apt-get update \
    && apt-get install -y \
    php8.3 \
    php8.3-fpm \
    php8.3-cli \
    php8.3-mysql \
    php8.3-xml \
    php8.3-zip \
    php8.3-mbstring \
    php8.3-bcmath \
    php8.3-gd \
    composer \
    git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Instala Node.js y npm
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
RUN apt-get update && apt-get install -y nodejs
RUN npm install -g npm

# Configura Nginx
COPY docker/nginx/default.conf /etc/nginx/sites-available/default
#RUN ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/
##RUN rm /etc/nginx/sites-enabled/default

# Configura Supervisor
COPY docker/etc/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Crea un directorio para la aplicación Laravel
#RUN mkdir -p /var/www/laravel

# Copia los archivos de la aplicación Laravel
WORKDIR /var/www/html
COPY . /var/www/html

# Instala las dependencias de Laravel
RUN composer install --no-interaction --optimize-autoloader --no-dev

# Genera la clave de la aplicación
RUN php artisan key:generate

# Ejecuta las migraciones
# RUN php artisan migrate --force

# Cambia el usuario y grupo para nginx y php-fpm
RUN chown -R www-data:www-data /var/www/html
RUN find /var/www/html -type d -print0 | xargs -0 chmod 775
RUN find /var/www/html -type f -print0 | xargs -0 chmod 664

# Define el puerto para Nginx
EXPOSE 80

# Comando para iniciar la aplicación
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
