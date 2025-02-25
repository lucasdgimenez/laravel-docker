# Usa a imagem oficial do PHP 8 com Apache
FROM php:8.2-apache

# Instala extensões necessárias para o Laravel
RUN apt-get update && apt-get install -y \
    unzip \
    git \
    curl \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    && docker-php-ext-install pdo pdo_mysql mbstring exif pcntl bcmath gd sockets

# Instala o Composer
#COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
# Instala o Composer manualmente (para evitar problemas com COPY --from)
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Define o diretório de trabalho
WORKDIR /var/www/html

# Copia os arquivos do Laravel para o contêiner
COPY . .

COPY docker/apache/000-default.conf /etc/apache2/sites-available/000-default.conf

# Define permissões corretas
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 775 /var/www/html/storage \
    && chmod -R 775 /var/www/html/bootstrap/cache

# Ativa o módulo de reescrita do Apache
RUN a2enmod rewrite

# Expõe a porta 80
EXPOSE 80

# Comando de inicialização
CMD ["apache2-foreground"]


