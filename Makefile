DOCKER_REPO ?= docker.io/
IMAGE ?= maxbeck/tomcat-s2i
TAG ?= latest

build:
	docker build -t "${DOCKER_REPO}$(IMAGE):$(TAG)" .

push: build
	docker push "${DOCKER_REPO}$(IMAGE):$(TAG)"
