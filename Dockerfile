FROM php:7.3-apache

RUN apt-get update && apt-get install -y \
    git \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng-dev \
    libicu-dev \
    libzip-dev \
    g++ \
    libpq-dev \
    libtidy-dev
RUN pecl install mcrypt-1.0.2
RUN docker-php-ext-install intl \
    && docker-php-ext-configure intl \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install zip \
    && docker-php-ext-install pdo \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install tidy

ENV APACHE_DOCUMENT_ROOT /app/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

RUN a2enmod rewrite

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN echo "\ndisplay_errors = ${PHP_DISPLAY_ERRORS:-Off}" >> $PHP_INI_DIR/conf.d/silverstipe-php.ini
RUN echo "\ndate.timezone = ${PHP_DATE_TIMEZONE:-Europe/London}" >> $PHP_INI_DIR/conf.d/silverstipe-php.ini

ENV PATH="/app/vendor/bin:${PATH}"

WORKDIR /app

RUN pecl install redis && docker-php-ext-enable redis

COPY app/app /app/app
COPY app/public /app/public
COPY app/themes /app/themes
COPY app/vendor /app/vendor
COPY app/composer.json /app/composer.json
COPY app/composer.lock /app/composer.lock

RUN mkdir -p public/assets
RUN chmod -R 777 public/assets

RUN echo "\nsession.save_handler = redis" >> $PHP_INI_DIR/conf.d/silverstipe-php.ini
RUN echo "\nsession.save_path = 'tcp://…-redis-master:6379'" >> $PHP_INI_DIR/conf.d/silverstipe-php.ini
