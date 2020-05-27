#!/bin/bash

echo $APP_ENV
if [ "$APP_ENV" != "production" ]; then
    until nc -z ${RABBIT_HOST} ${RABBIT_PORT}; do
        echo "$(date) - waiting for rabbitmq..."
        sleep 2
    done
fi

# run microservice
if [ "$APP_ENV" != "production" ]; then
    nameko run --config config.yml buzzer.service --backdoor 3000
else
    nameko run --config config.yml buzzer.service
fi