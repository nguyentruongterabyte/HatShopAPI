# Sử dụng PHP image chính thức với Apache
FROM php:8.1-apache

# Cài đặt các tiện ích cần thiết cho Composer
RUN apt-get update && apt-get install -y \
  git \
  unzip \
  zip

# Cài đặt các extension cần thiết cho PHP
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Cài đặt Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Đặt thư mục làm việc là /var/www/html
WORKDIR /var/www/html

# Sao chép file composer.json và cài đặt các dependencies
COPY composer.json ./
ENV COMPOSER_ALLOW_SUPERUSER=1
RUN composer install

# Sao chép toàn bộ mã nguồn vào thư mục làm việc
COPY . .

# Expose cổng 8000
EXPOSE 8000

# Khởi chạy server PHP
CMD ["php", "-S", "0.0.0.0:8000", "-t", "public"]
