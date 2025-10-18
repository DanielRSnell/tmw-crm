# Production Dockerfile for Krayin CRM
# Based on official Krayin Dockerfile adapted for standalone deployment
FROM php:8.2-apache

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    libfreetype6-dev \
    libicu-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libwebp-dev \
    libzip-dev \
    unzip \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

# Configure PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp
RUN docker-php-ext-configure intl

# Install PHP extensions
RUN docker-php-ext-install \
    bcmath \
    calendar \
    exif \
    gd \
    intl \
    mysqli \
    pdo \
    pdo_mysql \
    zip

# Install Composer
COPY --from=composer:2.7 /usr/bin/composer /usr/local/bin/composer

# Install Node.js and npm
COPY --from=node:22.9 /usr/local/lib/node_modules /usr/local/lib/node_modules
COPY --from=node:22.9 /usr/local/bin/node /usr/local/bin/node
RUN ln -s /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm

# Set working directory
WORKDIR /var/www/html

# Copy Apache configuration
COPY ./docker/apache.conf /etc/apache2/sites-available/000-default.conf

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Copy application code
COPY . /var/www/html

# Install PHP dependencies (production only)
RUN composer install --no-dev --optimize-autoloader --prefer-dist

# Install Node dependencies and build assets
RUN npm install && npm run build

# Set permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 775 /var/www/html/storage \
    && chmod -R 775 /var/www/html/bootstrap/cache

# Configure PHP for production
RUN echo "upload_max_filesize = 100M" >> /usr/local/etc/php/conf.d/uploads.ini \
    && echo "post_max_size = 100M" >> /usr/local/etc/php/conf.d/uploads.ini \
    && echo "memory_limit = 512M" >> /usr/local/etc/php/conf.d/memory.ini \
    && echo "max_execution_time = 300" >> /usr/local/etc/php/conf.d/timeouts.ini

# Copy entrypoint script
COPY ./docker/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 80

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["apache2-foreground"]
