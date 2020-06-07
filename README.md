# Pi Commander microservice
A microservice that sends commands to connected Raspberry Pi devices.

Commands are sent in form of messages, using RabbitMQ as the message broker. Daemons on Raspberry Pi end pick these messages up and execute specific tasks on the device.

## Run locally
As a prerequisite, install `make` on your OS: https://www.gnu.org/software/make/.

Also, you'd need Python 3.x and Docker.

To start the app, run the following command in a terminal
```
make start
```
The command above uses docker-compose to run the application.

The custom Dockerfile installs all required packages (which are listed in the `setup.py`) and runs the nameko service from a custom shell script (`run.sh`).

#### Run.sh
Before running the nameko service, script confirms if RabbitMQ is running. If not, nameko service won't start.

### Testing the app
Open an API client like Postman and do a POST request:
```
POST http://localhost:8001/buzzer

{ "turn_on": true }
```

To review the messages stacking in the queue use the RabbitMQ management portal: http://localhost:15673/#/queues

## Configuration
App configuration is defined in the `config.yml` file

Such configuration values can be accessed by importing the nameko's config package 
```
from nameko import config
```
And then by using the `get` method of that config object.
```
print(config.get('AMQP_URI'))
```

## CI/CD
### Build
[Travis CI](https://travis-ci.org/) builds and deploys the service to Heroku.

The file `travis.yml` contains all definitions to [build](https://travis-ci.org/github/gdyrrahitis/pi-commander-microservice) and deploy the microservice to the abovementioned cloud provider.

### Hosting
Travis CI automatically deploys to Heroku when build is successfull

```
deploy:
  provider: heroku
```

The heroku provider uses the `heroku.yml` file to deploy the application, with its addons (RabbitMQ)

```
setup:
  addons:
    - plan: cloudamqp:lemur
      as: BROKER
build:
  docker:
    web: Dockerfile-heroku
  config:
    APP_ENV: production
```

The application is deployed as a Docker container in Heroku. To build the container specifically for the cloud provider, a Dockerfile-heroku file is defined, which is slightly different from the default Dockerfile.