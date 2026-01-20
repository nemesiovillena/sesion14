# Products&Inventory - PHP 8.4 FPM Dockerfile
FROM php:8.4-fpm-alpine

# Build arguments
ARG USER_ID=1000
ARG GROUP_ID=1000
ARG INSTALL_XDEBUG=false

# Labels
LABEL maintainer="Products&Inventory Team"
LABEL description="PHP 8.4 FPM for Laravel 12 ecommerce"

# Install system dependencies
RUN apk add --no-cache \
    git \
    curl \
    libpng-dev \
    libjpeg-turbo-dev \
    freetype-dev \
    libzip-dev \
    zip \
    unzip \
    icu-dev \
    oniguruma-dev \
    linux-headers \
    $PHPIZE_DEPS

# Configure and install PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
        pdo_mysql \
        mbstring \
        exif \
        pcntl \
        bcmath \
        gd \
        zip \
        intl \
        opcache

# Install Redis extension
RUN pecl install redis \
    && docker-php-ext-enable redis

# Install Xdebug conditionally
RUN if [ "$INSTALL_XDEBUG" = "true" ]; then \
        pecl install xdebug \
        && docker-php-ext-enable xdebug; \
    fi

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Create non-root user
RUN addgroup -g ${GROUP_ID} laravel \
    && adduser -u ${USER_ID} -G laravel -s /bin/sh -D laravel

# Set working directory
WORKDIR /var/www

# Copy PHP configuration
COPY docker/php/php.ini /usr/local/etc/php/conf.d/custom.ini

# Set ownership
RUN chown -R laravel:laravel /var/www

# Switch to non-root user
USER laravel

# Expose PHP-FPM port
EXPOSE 9000

# Start PHP-FPM
CMD ["php-fpm"]
