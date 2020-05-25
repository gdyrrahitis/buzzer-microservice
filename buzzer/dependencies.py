import rabbitpy
from nameko import config
from nameko.extensions import DependencyProvider


AMQP_URI_KEY = 'AMQP_URI'


class BrokerWrapper:
    routing_key = 'pi_buzzer'

    def __init__(self):
        connection = rabbitpy.Connection(config.get(AMQP_URI_KEY))
        self.channel = connection.channel()
        self.exchange = rabbitpy.Exchange(self.channel, 'exch_pi')
        self.exchange.declare()
        queue = rabbitpy.Queue(self.channel, 'q_pi_buzzer')
        queue.declare()
        queue.bind(self.exchange, self.routing_key)

    def publish(self, body):
        properties = {'content_type': 'application/json'}
        message = rabbitpy.Message(self.channel, body, properties)
        message.publish(self.exchange, self.routing_key)


class Broker(DependencyProvider):
    def get_dependency(self, worker_context):
        return BrokerWrapper()
