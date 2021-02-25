ARG PHP_VERSION
ARG PROJECT_TYPE

FROM php:${PHP_VERSION}-${PROJECT_TYPE}-alpine

# setup general options for environment variables
ARG PHP_MEMORY_LIMIT_ARG="256M"
ENV PHP_MEMORY_LIMIT=${PHP_MEMORY_LIMIT_ARG}
ARG PHP_MAX_EXECUTION_TIME_ARG="120"
ENV PHP_MAX_EXECUTION_TIME=${PHP_MAX_EXECUTION_TIME_ARG}
ARG PHP_UPLOAD_MAX_FILESIZE_ARG="20M"
ENV PHP_UPLOAD_MAX_FILESIZE=${PHP_UPLOAD_MAX_FILESIZE_ARG}
ARG PHP_MAX_INPUT_VARS_ARG="1000"
ENV PHP_MAX_INPUT_VARS=${PHP_MAX_INPUT_VARS_ARG}
ARG PHP_POST_MAX_SIZE_ARG="8M"
ENV PHP_POST_MAX_SIZE=${PHP_POST_MAX_SIZE_ARG}

# setup opcache for environment variables
ARG PHP_OPCACHE_ENABLE_ARG="1"
ARG PHP_OPCACHE_REVALIDATE_FREQ_ARG="0"
ARG PHP_OPCACHE_VALIDATE_TIMESTAMPS_ARG="0"
ARG PHP_OPCACHE_MAX_ACCELERATED_FILES_ARG="10000"
ARG PHP_OPCACHE_MEMORY_CONSUMPTION_ARG="128"
ARG PHP_OPCACHE_MAX_WASTED_PERCENTAGE_ARG="10"
ARG PHP_OPCACHE_INTERNED_STRINGS_BUFFER_ARG="16"
ARG PHP_OPCACHE_FAST_SHUTDOWN_ARG="1"
ENV PHP_OPCACHE_ENABLE=$PHP_OPCACHE_ENABLE_ARG
ENV PHP_OPCACHE_REVALIDATE_FREQ=$PHP_OPCACHE_REVALIDATE_FREQ_ARG
ENV PHP_OPCACHE_VALIDATE_TIMESTAMPS=$PHP_OPCACHE_VALIDATE_TIMESTAMPS_ARG
ENV PHP_OPCACHE_MAX_ACCELERATED_FILES=$PHP_OPCACHE_MAX_ACCELERATED_FILES_ARG
ENV PHP_OPCACHE_MEMORY_CONSUMPTION=$PHP_OPCACHE_MEMORY_CONSUMPTION_ARG
ENV PHP_OPCACHE_MAX_WASTED_PERCENTAGE=$PHP_OPCACHE_MAX_WASTED_PERCENTAGE_ARG
ENV PHP_OPCACHE_INTERNED_STRINGS_BUFFER=$PHP_OPCACHE_INTERNED_STRINGS_BUFFER_ARG
ENV PHP_OPCACHE_FAST_SHUTDOWN=$PHP_OPCACHE_FAST_SHUTDOWN_ARG

RUN set -ex && \
    apk --no-cache add \
    postgresql-client \
    postgresql-dev \
    autoconf \
    g++ \
    make \
    freetype \
    # gnu-libiconv=1.15-r3 \
    libzip-dev \
    libpng \
    libjpeg-turbo \
    freetype-dev \
    libpng-dev \
    libjpeg-turbo-dev \
    libxml2-dev \
    icu-dev \
    imagemagick \
    imagemagick-dev \
    imagemagick-libs && \
    docker-php-ext-configure gd && \
    docker-php-ext-install -j$(nproc) \
    bcmath \
    gd \
    pdo \
    pdo_mysql \
    pdo_pgsql \
    intl \
    soap \
    opcache \
    zip && \
    pecl install imagick redis && \
    docker-php-ext-enable imagick redis && \
    apk del --no-cache \
    freetype-dev \
    libpng-dev \
    libjpeg-turbo-dev \
    autoconf \
    g++ \
    make \
    imagemagick-dev

# https://github.com/docker-library/php/issues/1121
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so

# copy custom.ini settings
COPY craft-cms.ini /usr/local/etc/php/conf.d/

# copy the blackfire script
# COPY blackfire-install.sh /tmp/blackfire-install.sh

# run the installation script
# RUN set -ex && sh /tmp/blackfire-install.sh && rm -rf /tmp/blackfire*

# make the directories and set permissions
RUN mkdir -p /app

# set the permissions on the
RUN chown -R www-data:www-data /app

# set the working directory for conveinence
WORKDIR /app

# run container as the www-data user
USER www-data
