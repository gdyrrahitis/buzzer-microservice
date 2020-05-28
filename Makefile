HOST=127.0.0.1
PORT=8000
NAME=pi-commander-microservice
IMAGE=gdyrra/pi_commander-microservice
TAG ?= dev
FROM_TAG ?= dev

.PHONY: clean-pyc clean-build

clean-pyc:
	find . -name '*.pyc' -exec rm --force {} +
	find . -name '*.pyo' -exec rm --force {} +
	find . -name '*~' -exec rm --force {} +

clean-build:
	rm --force --recursive build/
	rm --force --recursive dist/
	rm --force --recursive *.egg-info

lint:
	flake8 --exclude=.tox

build:
	docker build --tag $(IMAGE):$(TAG) .

d-run:
	docker run --name=$(NAME) $(TAG)

remove:
	docker rm $(NAME)

start:
	docker-compose up --build

tag:
	docker tag $(IMAGE):$(FROM_TAG) $(IMAGE):$(TAG)

push:
	docker push $(IMAGE):$(TAG)

login:
	docker login --password=$(DOCKER_PASSWORD) --username=$(DOCKER_USERNAME)
