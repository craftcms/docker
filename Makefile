.PHONY: build

PHP_TEST ?= 8.0

build: all-cli all-cli-dev all-php-fpm all-php-fpm-dev all-nginx all-nginx-dev

all-cli:
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		--build-arg PHP_VERSION=8.0 \
		--build-arg PROJECT_TYPE=cli \
		-t craftcms/cli:8.0 8.0
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		--build-arg PHP_VERSION=7.4 \
		--build-arg PROJECT_TYPE=cli \
		-t craftcms/cli:7.4 7.4
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		--build-arg PHP_VERSION=7.3 \
		--build-arg PROJECT_TYPE=cli \
		-t craftcms/cli:7.3 7.3
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		--build-arg PHP_VERSION=7.2 \
		--build-arg PROJECT_TYPE=cli \
		-t craftcms/cli:7.2 7.2
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		--build-arg PHP_VERSION=7.1 \
		--build-arg PROJECT_TYPE=cli \
		-t craftcms/cli:7.1 7.1
	docker buildx build --load --platform linux/amd64 --builder all-platforms --build-arg PHP_VERSION=7.0 \
		--build-arg PROJECT_TYPE=cli \
		-t craftcms/cli:7.0 7.0

all-cli-dev:
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		-f 8.0/dev.Dockerfile \
		--build-arg PHP_VERSION=8.0 \
		--build-arg PROJECT_TYPE=cli \
		-t craftcms/cli:8.0-dev 8.0
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		-f 7.4/dev.Dockerfile \
		--build-arg PHP_VERSION=7.4 \
		--build-arg PROJECT_TYPE=cli \
		-t craftcms/cli:7.4-dev 7.4
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		-f 7.3/dev.Dockerfile \
		--build-arg PHP_VERSION=7.3 \
		--build-arg PROJECT_TYPE=cli \
		-t craftcms/cli:7.3-dev 7.3
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		-f 7.2/dev.Dockerfile \
		--build-arg PHP_VERSION=7.2 \
		--build-arg PROJECT_TYPE=cli \
		-t craftcms/cli:7.2-dev 7.2
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		-f 7.1/dev.Dockerfile \
		--build-arg PHP_VERSION=7.1 \
		--build-arg PROJECT_TYPE=cli \
		-t craftcms/cli:7.1-dev 7.1
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		-f 7.0/dev.Dockerfile \
		--build-arg PHP_VERSION=7.0 \
		--build-arg PROJECT_TYPE=cli \
		-t craftcms/cli:7.0-dev 7.0

all-php-fpm:
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		--build-arg PHP_VERSION=8.0 \
		--build-arg PROJECT_TYPE=fpm \
		-t craftcms/php-fpm:8.0 8.0
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		--build-arg PHP_VERSION=7.4 \
		--build-arg PROJECT_TYPE=fpm \
		-t craftcms/php-fpm:7.4 7.4
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		--build-arg PHP_VERSION=7.3 \
		--build-arg PROJECT_TYPE=fpm \
		-t craftcms/php-fpm:7.3 7.3
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		--build-arg PHP_VERSION=7.2 \
		--build-arg PROJECT_TYPE=fpm \
		-t craftcms/php-fpm:7.2 7.2
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		--build-arg PHP_VERSION=7.1 \
		--build-arg PROJECT_TYPE=fpm \
		-t craftcms/php-fpm:7.1 7.1
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		--build-arg PHP_VERSION=7.0 \
		--build-arg PROJECT_TYPE=fpm \
		-t craftcms/php-fpm:7.0 7.0

all-php-fpm-dev:
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		-f 8.0/dev.Dockerfile \
		--build-arg PHP_VERSION=8.0 \
		--build-arg PROJECT_TYPE=php-fpm \
		-t craftcms/php-fpm:8.0-dev 8.0
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		-f 7.4/dev.Dockerfile \
		--build-arg PHP_VERSION=7.4 \
		--build-arg PROJECT_TYPE=php-fpm \
		-t craftcms/php-fpm:7.4-dev 7.4
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		-f 7.3/dev.Dockerfile \
		--build-arg PHP_VERSION=7.3 \
		--build-arg PROJECT_TYPE=php-fpm \
		-t craftcms/php-fpm:7.3-dev 7.3
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		-f 7.2/dev.Dockerfile \
		--build-arg PHP_VERSION=7.2 \
		--build-arg PROJECT_TYPE=php-fpm \
		-t craftcms/php-fpm:7.2-dev 7.2
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		-f 7.1/dev.Dockerfile \
		--build-arg PHP_VERSION=7.1 \
		--build-arg PROJECT_TYPE=php-fpm \
		-t craftcms/php-fpm:7.1-dev 7.1
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		-f 7.0/dev.Dockerfile \
		--build-arg PHP_VERSION=7.0 \
		--build-arg PROJECT_TYPE=php-fpm \
		-t craftcms/php-fpm:7.0-dev 7.0

all-nginx:
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		--build-arg PHP_VERSION=8.0 \
		-t craftcms/nginx:8.0 nginx
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		--build-arg PHP_VERSION=7.4 \
		-t craftcms/nginx:7.4 nginx
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		--build-arg PHP_VERSION=7.3 \
		-t craftcms/nginx:7.3 nginx
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		--build-arg PHP_VERSION=7.2 \
		-t craftcms/nginx:7.2 nginx
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		--build-arg PHP_VERSION=7.1 \
		-t craftcms/nginx:7.1 nginx
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		--build-arg PHP_VERSION=7.0 \
		-t craftcms/nginx:7.0 nginx

all-nginx-dev:
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		--build-arg PHP_VERSION=8.0-dev \
		--build-arg NGINX_CONF=dev.default.conf \
		-t craftcms/nginx:8.0-dev nginx
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		--build-arg PHP_VERSION=7.4-dev \
		--build-arg NGINX_CONF=dev.default.conf \
		-t craftcms/nginx:7.4-dev nginx
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		--build-arg PHP_VERSION=7.3-dev \
		--build-arg NGINX_CONF=dev.default.conf \
		-t craftcms/nginx:7.3-dev nginx
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		--build-arg PHP_VERSION=7.2-dev \
		--build-arg NGINX_CONF=dev.default.conf \
		-t craftcms/nginx:7.2-dev nginx
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		--build-arg PHP_VERSION=7.1-dev \
		--build-arg NGINX_CONF=dev.default.conf \
		-t craftcms/nginx:7.1-dev nginx
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		--build-arg PHP_VERSION=7.0-dev \
		--build-arg NGINX_CONF=dev.default.conf \
		-t craftcms/nginx:7.0-dev nginx

setup:
	docker buildx create --name all-platforms --platform linux/amd64,linux/arm64
	docker buildx use all-platforms
	docker buildx inspect --bootstrap

run:
	docker buildx build --load --platform linux/amd64 \
		--build-arg PHP_VERSION=${PHP_TEST} \
		--build-arg PROJECT_TYPE=fpm \
		-t craftcms/php-fpm:${PHP_TEST} ${PHP_TEST}
	docker run --rm -it craftcms/php-fpm:${PHP_TEST} sh
