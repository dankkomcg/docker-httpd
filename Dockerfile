FROM php:5.6-apache

# definir punto de entrada de la imagen
WORKDIR /etc/apache2

# copiar el directorio de entrada del hosts
COPY ./index.php /var/www/html

# actualizar dependencias
RUN apt-get update

# instalar depencias de desarrollo
RUN apt-get install -y \
    git \
    libzip-dev \
    curl \
    sudo \
    unzip \
    libicu-dev \
    libbz2-dev \
    libpng-dev \
    libjpeg-dev \
    libmcrypt-dev \
    libreadline-dev \
    libfreetype6-dev \
    libxml2-dev \
    zip \
    g++

# añadir el fichero de configuración de PHP (podemos alternar para cada entorno de despliegue)
COPY ./php.ini-production "$PHP_INI_DIR/php.ini"

# añadimos las depencencias de php
RUN docker-php-ext-install \
    bz2 \
    intl \
    iconv \
    bcmath \
    opcache \
    calendar \
    pdo_mysql \
    mysqli \
    zip \
    soap

# añadir las extensiones con los flags correctos para soportar las configuraciones de php 5.6
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
        && docker-php-ext-install gd

# activar soporte para .htaccess
RUN a2enmod rewrite headers ssl

# copiamos los certificados
COPY ./conf/ssl /etc/apache2/ssl

# copiamos el hosts por defecto para luego añadir los enlaces de contexto
COPY ./conf/000-default.conf /etc/apache2/sites-available

# exponemos el puerto de escucha interno
EXPOSE 443
