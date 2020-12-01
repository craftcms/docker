.PHONY: build

build: all-php-fpm all-php-fpm-dev all-nginx all-nginx-dev

all-php-fpm:
	docker build --build-arg PHP_VERSION=7.4 \
		--build-arg PROJECT_TYPE=fpm \
		-t craftcms/php-fpm:7.4 7.4
	docker build --build-arg PHP_VERSION=7.3 \
		--build-arg PROJECT_TYPE=fpm \
		-t craftcms/php-fpm:7.3 7.3
	docker build --build-arg PHP_VERSION=7.2 \
		--build-arg PROJECT_TYPE=fpm \
		-t craftcms/php-fpm:7.2 7.2
all-php-fpm-dev:
	docker build -f 7.4/dev.Dockerfile \
		--build-arg PHP_VERSION=7.4 \
		--build-arg PROJECT_TYPE=php-fpm \
		-t craftcms/php-fpm:7.4-dev 7.4
	docker build -f 7.3/dev.Dockerfile \
		--build-arg PHP_VERSION=7.3 \
		--build-arg PROJECT_TYPE=php-fpm \
		-t craftcms/php-fpm:7.3-dev 7.3
	docker build -f 7.2/dev.Dockerfile \
		--build-arg PHP_VERSION=7.2 \
		--build-arg PROJECT_TYPE=php-fpm \
		-t craftcms/php-fpm:7.2-dev 7.2

all-nginx:
	docker build --build-arg PHP_VERSION=7.4 \
		-t craftcms/nginx:7.4 nginx
	docker build --build-arg PHP_VERSION=7.3 \
		-t craftcms/nginx:7.3 nginx
	docker build --build-arg PHP_VERSION=7.2 \
		-t craftcms/nginx:7.2 nginx
all-nginx-dev:
	docker build --build-arg PHP_VERSION=7.4-dev \
		-t craftcms/nginx:7.4-dev nginx
	docker build --build-arg PHP_VERSION=7.3-dev \
		-t craftcms/nginx:7.3-dev nginx
	docker build --build-arg PHP_VERSION=7.2-dev \
		-t craftcms/nginx:7.2-dev nginx
