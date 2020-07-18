ORGANIZATION ?= craftcms
PROJECT ?= php-fpm
TAG ?= 7.4
IMAGE ?= ${ORGANIZATION}/${PROJECT}:${TAG}

.PHONY: build

build:
	docker build -t $(ORGANIZATION)/$(PROJECT):$(TAG) .
