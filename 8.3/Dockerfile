ARG PHP_VERSION
ARG PROJECT_TYPE

FROM alpine:3.13 AS iconv-build
RUN apk upgrade --no-cache \
    && apk add --no-cache gnu-libiconv

FROM php:${PHP_VERSION}-${PROJECT_TYPE}-alpine3.19

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

# MozJPEG
ENV MOZJPEG_VERSION="3.3.1"
ENV MOZJPEG_BUILD_DEPS \
    autoconf \
    automake \
    build-base \
    libtool \
    nasm \
    pkgconf \
    tar

RUN set -ex \
    && apk upgrade --no-cache \
    && apk add --no-cache --virtual .build-deps \
    $PHPIZE_DEPS \
    $MOZJPEG_BUILD_DEPS \
    freetype-dev \
    icu-dev \
    icu-data-full \
    libwebp-dev \
    imagemagick-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    libxml2-dev \
    libzip-dev \
    postgresql-dev \
    && apk add --no-cache \
    gifsicle \
    imagemagick \
    jpegoptim \
    libjpeg-turbo-utils \
    libwebp-tools \
    optipng \
    pngquant \
    && docker-php-ext-configure gd \
    --with-freetype \
    --with-jpeg \
    --with-webp \
    && docker-php-ext-install -j$(nproc) \
    bcmath \
    gd \
    intl \
    opcache \
    pdo \
    pdo_mysql \
    pdo_pgsql \
    soap \
    zip \
    && pecl install \
    redis \
    && docker-php-ext-enable \
    redis

# Install imagick from master because there's no tagged release in PECL yet with fixes for PHP 8.3
# https://github.com/Imagick/imagick/issues/640
# Workaround from https://github.com/yiisoft/yii2-docker/compare/324f7e8a36b394d637f1b327d474597b8a49f7de...master
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/
RUN install-php-extensions imagick/imagick@master

# https://github.com/craftcms/docker/issues/16
COPY --from=iconv-build /usr/lib/preloadable_libiconv.so /usr/lib/preloadable_libiconv.so

# https://github.com/docker-library/php/issues/1121
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so

# MozJPEG
WORKDIR /tmp
ADD https://github.com/mozilla/mozjpeg/archive/v${MOZJPEG_VERSION}.tar.gz ./
RUN set -ex \
    && tar -xzf v${MOZJPEG_VERSION}.tar.gz \
    && cd ./mozjpeg-${MOZJPEG_VERSION} \
    && autoreconf -fiv \
    && ./configure --with-jpeg8 \
    && make \
    && make install

RUN ln -s /opt/mozjpeg/bin/jpegtran /usr/local/bin/mozjpegtran
RUN ln -s /opt/mozjpeg/bin/cjpeg /usr/local/bin/mozcjpeg

# Cleanup
RUN RUNTIME_DEPS="$(scanelf --needed --nobanner --recursive /usr/local \
    | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
    | sort -u \
    | xargs -r apk info --installed \
    | sort -u)" \
    && apk add --no-cache --virtual .runtime-deps $RUNTIME_DEPS \
    && apk del --no-network .build-deps \
    && rm -rf /tmp/*

# copy custom.ini settings
COPY craft-cms.ini /usr/local/etc/php/conf.d/

# run container as the www-data user
USER www-data

# set the working directory for convenience
WORKDIR /app
