# Sử dụng image PHP với Apache
FROM php:8.1.25-apache

# Cài đặt các extension cần thiết cho PHP
RUN docker-php-ext-install mysqli pdo pdo_mysql && docker-php-ext-enable mysqli

# Copy toàn bộ project vào thư mục gốc của Apache
COPY . /var/www/html/

# Thiết lập quyền cho thư mục
RUN chown -R www-data:www-data /var/www/html
# Expose cổng 80
EXPOSE 80
