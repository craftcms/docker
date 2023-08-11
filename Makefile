.PHONY: build snyk

LOCAL_PHP_VERSION ?= 8.2

build: all-cli all-cli-dev all-php-fpm all-php-fpm-dev all-nginx all-nginx-dev
snyk: snyk-all-cli snyk-all-cli-dev snyk-all-php-fpm snyk-all-php-fpm-dev snyk-all-nginx snyk-all-nginx-dev

all-cli:
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		--build-arg PHP_VERSION=8.2 \
		--build-arg PROJECT_TYPE=cli \
		-t craftcms/cli:8.2 8.2
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		--build-arg PHP_VERSION=8.2 \
		--build-arg PROJECT_TYPE=cli \
		-t craftcms/cli:8.1 8.1
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		--build-arg PHP_VERSION=8.0 \
		--build-arg PROJECT_TYPE=cli \
		-t craftcms/cli:8.0 8.0

all-cli-dev:
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		-f 8.2/dev.Dockerfile \
		--build-arg PHP_VERSION=8.2 \
		--build-arg PROJECT_TYPE=cli \
		-t craftcms/cli:8.2-dev 8.2
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		-f 8.1/dev.Dockerfile \
		--build-arg PHP_VERSION=8.1 \
		--build-arg PROJECT_TYPE=cli \
		-t craftcms/cli:8.1-dev 8.1
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		-f 8.0/dev.Dockerfile \
		--build-arg PHP_VERSION=8.0 \
		--build-arg PROJECT_TYPE=cli \
		-t craftcms/cli:8.0-dev 8.0

all-php-fpm:
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		--build-arg PHP_VERSION=8.2 \
		--build-arg PROJECT_TYPE=fpm \
		-t craftcms/php-fpm:8.2 8.2
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		--build-arg PHP_VERSION=8.1 \
		--build-arg PROJECT_TYPE=fpm \
		-t craftcms/php-fpm:8.1 8.1
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		--build-arg PHP_VERSION=8.0 \
		--build-arg PROJECT_TYPE=fpm \
		-t craftcms/php-fpm:8.0 8.0

all-php-fpm-dev:
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		-f 8.2/dev.Dockerfile \
		--build-arg PHP_VERSION=8.2 \
		--build-arg PROJECT_TYPE=php-fpm \
		-t craftcms/php-fpm:8.2-dev 8.2
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		-f 8.1/dev.Dockerfile \
		--build-arg PHP_VERSION=8.1 \
		--build-arg PROJECT_TYPE=php-fpm \
		-t craftcms/php-fpm:8.1-dev 8.1
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		-f 8.0/dev.Dockerfile \
		--build-arg PHP_VERSION=8.0 \
		--build-arg PROJECT_TYPE=php-fpm \
		-t craftcms/php-fpm:8.0-dev 8.0

all-nginx:
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		--build-arg PHP_VERSION=8.2 \
		-t craftcms/nginx:8.2 nginx
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		--build-arg PHP_VERSION=8.1 \
		-t craftcms/nginx:8.1 nginx
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		--build-arg PHP_VERSION=8.0 \
		-t craftcms/nginx:8.0 nginx

all-nginx-dev:
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		--build-arg PHP_VERSION=8.2 \
		--build-arg NGINX_CONF=dev.default.conf \
		-t craftcms/nginx:8.2-dev nginx
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		--build-arg PHP_VERSION=8.1 \
		--build-arg NGINX_CONF=dev.default.conf \
		-t craftcms/nginx:8.1-dev nginx
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		--build-arg PHP_VERSION=8.0 \
		--build-arg NGINX_CONF=dev.default.conf \
		-t craftcms/nginx:8.0-dev nginx

setup:
	docker buildx create --name all-platforms --platform linux/amd64,linux/arm64
	docker buildx use all-platforms
	docker buildx inspect --bootstrap

local:
	docker buildx build --load --platform linux/amd64 \
		--build-arg PHP_VERSION=${LOCAL_PHP_VERSION} \
		--build-arg PROJECT_TYPE=fpm \
		-t craftcms/php-fpm:${LOCAL_PHP_VERSION} ${LOCAL_PHP_VERSION}
	docker buildx build --load --platform linux/amd64 \
		-f ${LOCAL_PHP_VERSION}/dev.Dockerfile \
		--build-arg PHP_VERSION=${LOCAL_PHP_VERSION} \
		--build-arg PROJECT_TYPE=php-fpm \
		-t craftcms/php-fpm:${LOCAL_PHP_VERSION}-dev ${LOCAL_PHP_VERSION}

	docker buildx build --load --platform linux/amd64 \
		--build-arg PHP_VERSION=${LOCAL_PHP_VERSION} \
		--build-arg PROJECT_TYPE=cli \
		-t craftcms/cli:${LOCAL_PHP_VERSION} ${LOCAL_PHP_VERSION}
	docker buildx build --load --platform linux/amd64 \
		-f ${LOCAL_PHP_VERSION}/dev.Dockerfile \
		--build-arg PHP_VERSION=${LOCAL_PHP_VERSION} \
		--build-arg PROJECT_TYPE=cli \
		-t craftcms/cli:${LOCAL_PHP_VERSION}-dev ${LOCAL_PHP_VERSION}

	docker buildx build --load --platform linux/amd64 \
		--build-arg PHP_VERSION=${LOCAL_PHP_VERSION} \
		-t craftcms/nginx:${LOCAL_PHP_VERSION} nginx
	docker buildx build --load --platform linux/amd64 \
		--build-arg PHP_VERSION=${LOCAL_PHP_VERSION} \
		--build-arg NGINX_CONF=dev.default.conf \
		-t craftcms/nginx:${LOCAL_PHP_VERSION}-dev nginx

run:
	docker buildx build --load --platform linux/amd64 \
		--build-arg PHP_VERSION=${LOCAL_PHP_VERSION} \
		--build-arg PROJECT_TYPE=fpm \
		-t craftcms/php-fpm:${LOCAL_PHP_VERSION} ${LOCAL_PHP_VERSION}
	docker run --rm -it craftcms/php-fpm:${LOCAL_PHP_VERSION} sh

run-dev:
	docker buildx build --load --platform linux/amd64 \
		-f ${LOCAL_PHP_VERSION}/dev.Dockerfile \
		--build-arg PHP_VERSION=${LOCAL_PHP_VERSION} \
		--build-arg PROJECT_TYPE=php-fpm \
		-t craftcms/php-fpm:${LOCAL_PHP_VERSION}-dev ${LOCAL_PHP_VERSION}
	docker run --rm -it craftcms/php-fpm:${LOCAL_PHP_VERSION}-dev sh

snyk-local:
	snyk container test \
		craftcms/php-fpm:${LOCAL_PHP_VERSION} \
		craftcms/php-fpm:${LOCAL_PHP_VERSION}-dev \
		craftcms/cli:${LOCAL_PHP_VERSION} \
		craftcms/cli:${LOCAL_PHP_VERSION}-dev \
		craftcms/nginx:${LOCAL_PHP_VERSION} \
		craftcms/nginx:${LOCAL_PHP_VERSION}-dev

snyk-all-cli:
	snyk container test \
	craftcms/cli:8.2 \
	craftcms/cli:8.1 \
	craftcms/cli:8.0

snyk-all-cli-dev:
	snyk container test \
	craftcms/cli:8.2-dev \
	craftcms/cli:8.1-dev \
	craftcms/cli:8.0-dev

snyk-all-php-fpm:
	snyk container test \
	craftcms/php-fpm:8.2 \
	craftcms/php-fpm:8.1 \
	craftcms/php-fpm:8.0

snyk-all-php-fpm-dev:
	snyk container test \
	craftcms/php-fpm:8.2-dev \
	craftcms/php-fpm:8.1-dev \
	craftcms/php-fpm:8.0-dev

snyk-all-nginx:
	snyk container test \
	craftcms/nginx:8.2 \
	craftcms/nginx:8.1 \
	craftcms/nginx:8.0

snyk-all-nginx-dev:
	snyk container test \
	craftcms/nginx:8.2-dev \
	craftcms/nginx:8.1-dev \
	craftcms/nginx:8.0-dev
