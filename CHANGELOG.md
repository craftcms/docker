# Release Notes for Craft CMS Docker Images

## 2021-02-05

### Added
- Added the `bcmath` extension to all images.

## 2021-02-03

### Added
- Added php `7.0` images for `craftcms/cli`, `craftcms/php-fpm`, and `craftcms/nginx`.
- Added multi-architecture images for arm64, arm/v6, arm/v7, and amd64 to support ARM based development environments like Apple Silicon.

### Changed
- PHP `7.0` no longer ship with xdebug as `pecl` no longer supports 7.0 (e.g. `pecl/xdebug requires PHP (version >= 7.2.0, version <= 8.0.99), installed version is 7.0.33`).

## 2021-01-26

### Added

- Added an option `NGINX_CONF` ARG to the `craftcms/nginx` images to allow overriding the nginx configuration file to COPY to the image.

## 2021-01-18

### Changed

- `craftcms/php-fpm:<ver>-dev` and `craftcms/nginx:<ver>-dev` images now include `git`.

## 2021-01-14

### Changed

- `craftcms/php-fpm:<ver>-dev` and `craftcms/nginx:<ver>-dev` images now include backup tools for mysql and postgres databases.

## 2021-01-04

- All `-dev*` images now ship with composer installed by default.

## 2020-12-20

- Add PHP 8.0 images without imagick until [this upstream issue](https://github.com/Imagick/imagick/issues/358) is resolved.

## 2020-12-07

### Added

- Added `craftcms/php-fpm:7.2`, `craftcms/php-fpm:7.2-dev`, `craftcms/nginx:7.4`, `craftcms/nginx:7.3`, `craftcms/nginx:7.2`, `craftcms/nginx:7.4-dev`, `craftcms/nginx:7.3-dev`, `craftcms/nginx:7.2-dev` images.
- Added `soap` extension to support Commerce ([#11](https://github.com/craftcms/docker/issues/11))

### Changed

- Cleaned up the repository structure
