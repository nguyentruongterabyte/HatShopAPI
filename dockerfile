# Use PHP image with Apache
FROM php:8.1-apache

# Install necessary tools
RUN apt-get update && apt-get install -y \
  git \
  unzip \
  zip

# Install PHP extensions
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy composer.json and install dependencies
COPY composer.json ./
COPY composer.lock ./
ENV COMPOSER_ALLOW_SUPERUSER=1
RUN composer install

# Copy entire source code to working directory
COPY . .

# Generate autoload files
RUN composer dump-autoload --optimize

# Expose port 8000
EXPOSE 8000

# Start PHP server
CMD ["php", "-S", "0.0.0.0:8000", "-t", "public"]
