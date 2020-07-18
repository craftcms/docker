FROM php:7.4-fpm-alpine

# TODO clean this up
RUN set -ex && \
    apk --no-cache add \
    postgresql-client \
    postgresql-dev \
    autoconf \
    g++ \
    make \
    freetype \
    libzip-dev \
    libpng \
    libjpeg-turbo \
    freetype-dev \
    libpng-dev \
    libjpeg-turbo-dev && \
    docker-php-ext-configure gd && \
    docker-php-ext-install -j$(nproc) \
    gd \
    pdo \
    pdo_pgsql \
    intl \
    opcache \
    zip && \
    pecl install redis && \
    docker-php-ext-enable redis && \
    apk del --no-cache \
    freetype-dev \
    libpng-dev \
    libjpeg-turbo-dev \
    autoconf \
    g++ \
    make

# setup opcache for environment variables
ARG PHP_OPCACHE_VALIDATE_TIMESTAMPS_ARG="0"
ARG PHP_OPCACHE_MAX_ACCELERATED_FILES_ARG="10000"
ARG PHP_OPCACHE_MEMORY_CONSUMPTION_ARG="128"
ARG PHP_OPCACHE_MAX_WASTED_PERCENTAGE_ARG="10"
ENV PHP_OPCACHE_VALIDATE_TIMESTAMPS=$PHP_OPCACHE_VALIDATE_TIMESTAMPS_ARG
ENV PHP_OPCACHE_MAX_ACCELERATED_FILES=$PHP_OPCACHE_MAX_ACCELERATED_FILES_ARG
ENV PHP_OPCACHE_MEMORY_CONSUMPTION=$PHP_OPCACHE_MEMORY_CONSUMPTION_ARG
ENV PHP_OPCACHE_MAX_WASTED_PERCENTAGE=$PHP_OPCACHE_MAX_WASTED_PERCENTAGE_ARG

# copy custom.ini settings
COPY craft-cms.ini /usr/local/etc/php

# make the directories and set permissions
RUN mkdir -p /app

# set the working directory for conveinence
WORKDIR /app

# set the permissions on the
RUN chown -R www-data:www-data /app

# run the container as the www-data user
USER www-data
