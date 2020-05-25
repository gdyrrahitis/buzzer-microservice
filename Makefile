HOST=127.0.0.1
PORT=8000
TAG=gdyrrahitis/pi_buzzer-microservice

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
	docker build --tag $(TAG) .

d-run:
	docker run --name=pi_buzzer_microservice $(TAG)

d-rm:
	docker rm pi_buzzer_microservice

dco-up:
	docker-compose up --build

# TODO: docker tag
# TODO: docker push

