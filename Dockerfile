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

# Fetch the latest stable Chrome version and install Chrome and ChromeDriver
RUN CHROME_VERSION=$(curl -sSL https://googlechromelabs.github.io/chrome-for-testing/ | awk -F 'Version:' '/Stable/ {print $2}' | awk '{print $1}' | sed 's/<code>//g; s/<\/code>//g') && \
    CHROME_URL="https://storage.googleapis.com/chrome-for-testing-public/${CHROME_VERSION}/linux64/chrome-linux64.zip" && \
    echo "Fetching Chrome version: ${CHROME_VERSION}" && \
    curl -sSL ${CHROME_URL} -o /tmp/chrome-linux64.zip && \
    mkdir -p /opt/google/chrome && \
    mkdir -p /usr/local/bin && \
    unzip -q /tmp/chrome-linux64.zip -d /opt/google/chrome && \
    rm /tmp/chrome-linux64.zip
    
# Expose port 9000
EXPOSE 9000