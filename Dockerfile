# Stage 1: Build Vue assets using Node
FROM node:18 as node

WORKDIR /var/www

# Copy and install frontend dependencies
COPY package*.json ./
RUN npm install

# Copy all project files
COPY . .

# Build frontend assets with Vite
RUN npm run build

# Stage 2: PHP environment
FROM php:8.2-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    zip \
    unzip \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    libpq-dev \
    libcurl4-openssl-dev \
    && docker-php-ext-install pdo pdo_mysql zip exif pcntl

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www

# Copy built Vue assets + app code from Node stage
COPY --from=node /var/www /var/www


# Install PHP dependencies for Laravel
RUN composer install --no-interaction --prefer-dist --optimize-autoloader

# Ensure correct permissions
RUN chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache

# Expose the port Laravel will run on
EXPOSE 8000

# Start Laravel server (Render will call this as start command)
CMD php artisan migrate --force && php artisan passport:install &&php artisan passport:keys && php artisan serve --host=0.0.0.0 --port=8000

