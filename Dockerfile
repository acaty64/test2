FROM php:8.3.12-fpm

# Set working directory
WORKDIR /var/www

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    git \
    curl \
    libzip-dev \
    npm \
    cron \
    iputils-ping

RUN npm install --global yarn

RUN curl -sL https://deb.nodesource.com/setup_22.x | bash - 
RUN apt-get install -y nodejs

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install extensions
RUN docker-php-ext-install pdo_mysql gd zip

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy existing application directory contents
COPY --chown=www-data:www-data app /var/www

# Copy cronjob file
COPY cronjob /etc/cron.d/laravel-cron

# Apply appropriate permissions to the cronjob file
RUN chmod 0644 /etc/cron.d/laravel-cron

# Apply ownership to the log file for cron
RUN touch /var/log/cron.log && chown -f www-data:www-data /var/log/cron.log

# Start cron and PHP-FPM together
CMD if [ ! -f /var/www/.env ]; then \
        composer create-project --prefer-dist laravel/laravel .; \
    fi && \
    cron && php-fpm

# Expose port 9000
EXPOSE 9000