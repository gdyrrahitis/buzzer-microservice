HOST=127.0.0.1
PORT=8000
NAME=pi-commander-microservice
RMQ_NAME=buzzer-service-rabbitmq
IMAGE=gdyrra/pi_commander-microservice
NETWORK=commander-network
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

install:
	pip install --no-cache-dir -e .

lint:
	flake8 --exclude=.tox

network:
	docker network create -d bridge $(NETWORK)

rmq-run:
	docker run -d \
		--name $(RMQ_NAME) \
		--network=$(NETWORK) \
		--net-alias=rabbit \
		-p "15673:15672" \
		-p "5671:5672" \
		-e RABBITMQ_DEFAULT_USER=guest \
		-e RABBITMQ_DEFAULT_PASS=guest \
		rabbitmq:3-management-alpine

rmq-remove:
	docker rm $(RMQ_NAME)

rmq-stop:
	docker stop $(RMQ_NAME)

rmq-reset: rmq-stop rmq-remove

build:
	docker build --tag $(IMAGE):$(TAG) .

d-run: build
	docker run --name=$(NAME) \
		--network=$(NETWORK) \
		-p "8001:8000" \
		-e RABBIT_PASSWORD="guest" \
		-e RABBIT_USER="guest" \
		-e RABBIT_HOST="rabbit" \
		-e RABBIT_PORT="5672" \
		-e BROKER_URL="amqp://guest:guest@rabbit:5672/" \
		-e RABBIT_MANAGEMENT_PORT="15673" \
		-e PORT=8000 \
		$(IMAGE):$(TAG)

stop:
	docker stop $(NAME)

remove:
	docker rm $(NAME)

d-reset: stop remove

start:
	docker-compose up --build

tag:
	docker tag $(IMAGE):$(FROM_TAG) $(IMAGE):$(TAG)

push:
	docker push $(IMAGE):$(TAG)

login:
	docker login --password=$(DOCKER_PASSWORD) --username=$(DOCKER_USERNAME)
