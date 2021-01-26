# Release Notes for Craft CMS Docker Images

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
